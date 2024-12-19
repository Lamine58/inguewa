// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_element

import 'dart:convert';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:inguewa/api/api.dart';
import 'package:inguewa/function/function.dart';
import 'package:inguewa/tabs/tabs.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignIn extends StatefulWidget {
  final context;
  const SignIn(this.context, {Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController first_name = TextEditingController();
  late TextEditingController last_name = TextEditingController();
  late TextEditingController email = TextEditingController();
  late TextEditingController phone = TextEditingController();
  late TextEditingController password = TextEditingController();
  late TextEditingController confirm_password = TextEditingController();
  late Api api = Api();
  var phoneNumber = PhoneNumber(isoCode: 'CI');

  void _auth() async {
    showDialog(
      context: widget.context,
      builder: (context) => AlertDialog(
        contentPadding: EdgeInsets.all(15),
        content: Row(
          children: [
            CircularProgressIndicator(color: primaryColor()),
            SizedBox(width: 20),
            Text('Veuillez patienter ...')
          ],
        ),
      ),
    );

    try {
      var response = await api.post('sign-in', {
        "phone": phone.text,
        "first_name": first_name.text,
        "last_name": last_name.text,
        "email": email.text,
        "password": password.text,
      });

      if (response['status'] == 'success') {
        toast(widget.context, response['message']);
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('customerData', jsonEncode(response['customer']));
        Navigator.pop(widget.context);
        Navigator.pushAndRemoveUntil(widget.context,
            MaterialPageRoute(builder: (context) => Tabs(context, 0)), (route) => false);
      } else {
        Navigator.pop(widget.context);
        _showResultDialog(response['message']);
      }
    } catch (error) {
      Navigator.pop(widget.context);
      _showResultDialog('Erreur: $error');
    }
  }

  void _showResultDialog(String result) {
    showDialog(
      context: widget.context,
      builder: (context) => AlertDialog(
        title: Text(
          'Réponse',
          style: TextStyle(fontSize: 20),
        ),
        content: Text(result, style: TextStyle(fontWeight: FontWeight.w300)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Form(
              key: _formKey,
              child: Column(
                children: [
                  logo(150),
                  SizedBox(height: 20),
                  // Nom
                  _buildInputContainer(
                    controller: first_name,
                    hintText: 'Nom',
                    icon: FluentIcons.person_48_regular,
                    validator: (value) =>
                    value!.isEmpty ? 'Veuillez saisir votre nom' : null,
                  ),
                  // Prénom
                  _buildInputContainer(
                    controller: last_name,
                    hintText: 'Prénom',
                    icon: FluentIcons.person_48_regular,
                    validator: (value) =>
                    value!.isEmpty ? 'Veuillez saisir votre prénom' : null,
                  ),
                  // Email
                  _buildInputContainer(
                    controller: email,
                    hintText: 'Email',
                    icon: FluentIcons.mail_48_regular,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value!.isEmpty) return 'Veuillez saisir votre email';
                      if (!isValidEmail(value))
                        return 'Veuillez saisir une adresse e-mail valide';
                      return null;
                    },
                  ),
                  // Téléphone
                  Container(
                    margin: EdgeInsets.only(bottom: 16),
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    decoration: _containerDecoration(),
                    child: InternationalPhoneNumberInput(
                      initialValue: phoneNumber,
                      onInputChanged: (PhoneNumber number) {
                        phone.text = number.phoneNumber!;
                      },
                      inputDecoration: InputDecoration(
                        hintText: 'Téléphone',
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: Colors.grey[400]),
                      ),
                      selectorConfig: SelectorConfig(
                        selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                      ),
                    ),
                  ),
                  // Mot de passe
                  _buildInputContainer(
                    controller: password,
                    hintText: 'Mot de passe',
                    icon: FluentIcons.key_32_regular,
                    obscureText: true,
                    validator: (value) => value!.isEmpty
                        ? 'Veuillez saisir votre mot de passe'
                        : null,
                  ),
                  // Confirmer le mot de passe
                  _buildInputContainer(
                    controller: confirm_password,
                    hintText: 'Confirmer le mot de passe',
                    icon: FluentIcons.key_32_regular,
                    obscureText: true,
                    validator: (value) {
                      if (value!.isEmpty) return 'Veuillez confirmer le mot de passe';
                      if (value != password.text)
                        return 'Les mots de passe ne correspondent pas';
                      return null;
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            // Bouton INSCRIPTION
            GestureDetector(
              onTap: () {
                if (_formKey.currentState?.validate() ?? false) {
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
                  child: Text(
                    'INSCRIPTION',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  // Fonction pour styliser les champs
  Widget _buildInputContainer({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    String? Function(String?)? validator,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: _containerDecoration(),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: Icon(icon, color: Colors.grey),
          border: InputBorder.none,
          hintStyle: TextStyle(color: Colors.grey[400]),
          contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        ),
        validator: validator,
      ),
    );
  }

  // Fonction de décoration des containers
  BoxDecoration _containerDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.2),
          spreadRadius: 1,
          blurRadius: 6,
          offset: Offset(0, 2),
        ),
      ],
    );
  }
}
