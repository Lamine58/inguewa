// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:inguewa/function/function.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({Key? key}) : super(key: key);

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final _email = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(
          color: secondaryColor()
        ),
        actions: [
          Padding(
            padding: EdgeInsets.all(5),
            child: logo(120),
          )
        ],
      ),
      backgroundColor: Colors.white,
      body: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Text(
                      'Vous avez oublié votre mot de passe ?',
                      style: TextStyle(
                        color: secondaryColor(),
                        fontWeight: FontWeight.w100,
                        fontSize: 20,
                      ),
                    ),
                    paddingTop(10),
                    Text('Saisissez l’adresse e-mail associé à votre compte. Cliquez sur soumettre pour que votre mot de passe vous soit envoyé par e-mail.'),
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
                  ],
                )
              ),
              paddingTop(20.0),
              GestureDetector(
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    
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
                              'INSCRIPTION',
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
        ),
      );
  }
}