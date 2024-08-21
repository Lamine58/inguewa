// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors
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
  const Password(this.context,{Key? key}) : super(key: key);

  @override
  State<Password> createState() => _PasswordState();
}

class _PasswordState extends State<Password> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late bool see_password = false;
  late Api api = Api();

  void _auth() async {
    
    showDialog(
      context: widget.context,
      builder: (context) => AlertDialog(
        contentPadding: EdgeInsets.all(15),
        content: Row(
          children: [
            CircularProgressIndicator(color:primaryColor()),
            paddingLeft(20),
            Text('Veuillez patienter ...')
          ],
        ),
      ),
    );

    try {
      var response = await api.post('login', {"login":_email.text,"password":_password.text});
      if (response['status'] == 'success') {
        toast(widget.context,response['message']);
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('customerData', jsonEncode(response['customer']));
        Navigator.pop(widget.context);
        Navigator.pushAndRemoveUntil(widget.context, MaterialPageRoute(builder: (context) => Tabs(context,0)),(route)=>false);
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
        title: Text('Réponse',style: TextStyle(fontSize: 20),),
        content: Text(result,style: TextStyle(fontWeight: FontWeight.w300)),
      ),
    );
  }

  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Form(
            key: _formKey,
            child: Column(
              children: [
                paddingTop(60),
                logo(150),
                paddingTop(20),
                TextFormField(
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Veuillez saisir votre e-mail';
                    }
                    // if(!validateEmail(_email.text)){
                    //   return 'Veuillez saisir une adresse e-mail valide';
                    // }
                    return null;
                  },
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(15),
                    hintText: 'Email',
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: Icon(FluentIcons.mail_48_regular),
                    hintStyle: TextStyle(
                      color: Color(0xFFB9B9B9),
                      fontFamily: 'Golt'
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(7), // set border radius
                    ),
                    prefixIconColor: Color(0xFFB9B9B9),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFE5E5E5)),
                      borderRadius: BorderRadius.circular(7), // set border radius
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color.fromARGB(250, 202, 202, 202)),
                      borderRadius: BorderRadius.circular(7), 
                    ),
                  ),
                ),
                paddingTop(16.0),
                TextFormField(
                  controller: _password,
                  obscureText: !see_password,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Veuillez s'il vous plait entrez votre mot de passe";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(15),
                    hintText: 'Mot de passe',
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: Icon(FluentIcons.key_32_regular),
                    hintStyle: TextStyle(
                      color: Color(0xFFB9B9B9),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(7), // set border radius
                    ),
                    prefixIconColor: Color(0xFFB9B9B9),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color.fromARGB(250, 202, 202, 202)),
                      borderRadius: BorderRadius.circular(7), // set border radius
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color.fromARGB(250, 202, 202, 202)),
                      borderRadius: BorderRadius.circular(7), 
                    ),
                    suffixIcon: GestureDetector(
                      onTap: (){
                        setState(() {
                          see_password = !see_password;
                        });
                      },
                      child: Icon(
                        see_password ? Icons.remove_red_eye_outlined : Icons.visibility_off_outlined,
                      )
                    )
                  ),
                ),
              ],
            )
          ),
          paddingTop(20.0),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ForgetPassword()
                ),
              );
            },
            child: Text(
              'Mot de passe oublié?',
              style: TextStyle(
                color: secondaryColor(),
                fontWeight: FontWeight.w100
              ),
              textAlign:TextAlign.right
            ),
          ),
          paddingTop(20.0),
          GestureDetector(
            onTap: () {
              if (_formKey.currentState!.validate()) {
                _auth();
              }
            },
            child: Container(
              width: double.infinity,
              height: 50,
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(asset('arriere-plan-vectoriel-motif-pointille-dans-style-aborigene_619130-1630.avif')),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'SE CONNECTER',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      )
    );
  }
}