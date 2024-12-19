import 'dart:convert';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:inguewa/api/api.dart';
import 'package:inguewa/auth/forget-password.dart';
import 'package:inguewa/function/function.dart';
import 'package:inguewa/tabs/tabs.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Password extends StatefulWidget {
  final context;
  const Password(this.context, {Key? key}) : super(key: key);

  @override
  State<Password> createState() => _PasswordState();
}

class _PasswordState extends State<Password> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool see_password = false;
  bool isLoading = false;
  late Api api = Api();

  void _auth() async {
    setState(() {
      isLoading = true;
    });

    showDialog(
      context: widget.context,
      builder: (context) =>
          AlertDialog(
            contentPadding: EdgeInsets.all(15),
            content: Row(
              children: [
                CircularProgressIndicator(color: Colors.pinkAccent),
                // Changement de couleur
                SizedBox(width: 20),
                Text('Veuillez patienter ...',
                    style: TextStyle(color: Colors.black87))
                // Texte amélioré
              ],
            ),
          ),
    );

    try {
      var response = await api.post('login', {
        "login": _email.text,
        "password": _password.text
      });
      if (response['status'] == 'success') {
        toast(widget.context, response['message']);
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('customerData', jsonEncode(response['customer']));
        Navigator.pop(widget.context);
        Navigator.pushAndRemoveUntil(
            widget.context,
            MaterialPageRoute(builder: (context) => Tabs(context, 0)),
                (route) => false);
      } else {
        Navigator.pop(widget.context);
        _showResultDialog(response['message']);
      }
    } catch (error) {
      Navigator.pop(widget.context);
      _showResultDialog('Erreur: $error');
    }
    setState(() {
      isLoading = false;
    });
  }

  void _showResultDialog(String result) {
    showDialog(
      context: widget.context,
      builder: (context) =>
          AlertDialog(
            title: Text('Réponse',
                style: TextStyle(fontSize: 20, fontFamily: 'Dancing Script')),
            content: Text(
                result, style: TextStyle(fontWeight: FontWeight.w300)),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(asset('loginf.png')),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        children: [
          SizedBox(height: 270),
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      paddingTop(10),
                      logo(150),
                      paddingTop(20),
                      // Email Input
                      _buildInputContainer(
                        controller: _email,
                        hintText: 'Email',
                        icon: FluentIcons.mail_48_regular,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) =>
                        value!.isEmpty ? 'Veuillez saisir votre e-mail' : null,
                      ),
                      paddingTop(16.0),
                      // Password Input
                      _buildInputContainer(
                        controller: _password,
                        hintText: 'Mot de passe',
                        icon: FluentIcons.key_32_regular,
                        obscureText: !see_password,
                        validator: (value) =>
                        value!.isEmpty
                            ? 'Veuillez entrer votre mot de passe'
                            : null,
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              see_password = !see_password;
                            });
                          },
                          child: Icon(
                            see_password
                                ? Icons.remove_red_eye_outlined
                                : Icons.visibility_off_outlined,
                            color: Colors.pinkAccent,
                          ),
                        ),
                      ),
                      paddingTop(20.0),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ForgetPassword()),
                          );
                        },
                        child: Text(
                          'Mot de passe oublié?',
                          style: TextStyle(
                            color: Colors.redAccent,
                            fontWeight: FontWeight.w100,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ),
                      paddingTop(20.0),
                      // Bouton SE CONNECTER
                      GestureDetector(
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            _auth();
                          }
                        },
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.redAccent,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.redAccent.withOpacity(0.5),
                                spreadRadius: 1,
                                blurRadius: 6,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Center(
                            child: isLoading
                                ? CircularProgressIndicator(color: Colors.white)
                                : Text(
                              'SE CONNECTER',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

// Méthode réutilisable pour le design des champs input
  Widget _buildInputContainer({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool obscureText = false,
    Widget? suffixIcon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: Icon(icon, color: Colors.redAccent),
          suffixIcon: suffixIcon,
          hintStyle: TextStyle(color: Color(0xFFB9B9B9)),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        ),
        validator: validator,
      ),
    );
  }
}