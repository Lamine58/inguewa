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
  const SignIn(this.context,{Key? key}) : super(key: key);

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
            CircularProgressIndicator(color:primaryColor()),
            paddingLeft(20),
            Text('Veuillez patienter ...')
          ],
        ),
      ),
    );

    try {
      var response = await api.post('sign-in', {
        "phone":phone.text,
        "first_name":first_name.text,
        "last_name":last_name.text,
        "email":email.text,
        "password":password.text,
        }
      );

      if (response['status'] == 'success') {
        toast(widget.context,response['message']);
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('cusstomerData', jsonEncode(response['customer']));
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
    return  Container(
        padding: EdgeInsets.only(left:20,right:20,bottom: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    logo(150),
                    paddingTop(20),
                    TextFormField(
                      controller: first_name,
                      keyboardType: TextInputType.name,
                      textInputAction:TextInputAction.next,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Veuillez saisir nom';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(15),
                        hintText: 'Nom',
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: Icon(FluentIcons.person_48_regular),
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
                      controller: last_name,
                      keyboardType: TextInputType.name,
                      textInputAction:TextInputAction.next,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Veuillez saisir votre';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(15),
                        hintText: 'Prénom',
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: Icon(FluentIcons.person_48_regular),
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
                      controller: email,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction:TextInputAction.next,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Veuillez saisir votre e-mail';
                        }
                        if(!isValidEmail(value)){
                          return 'Veuillez saisir une adresse e-mail valide';
                        }
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
                    Container(
                      padding: EdgeInsets.only(left: 12,right: 5,top: 2,bottom: 2),
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1,
                          color: Color.fromARGB(250, 202, 202, 202)
                        ),
                        borderRadius: BorderRadius.circular(7)
                      ),
                      child: InternationalPhoneNumberInput(
                        validator: (data){},
                        inputDecoration: InputDecoration(
                          hintText: 'Téléphone',
                          contentPadding: EdgeInsets.only(bottom:15),
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                            color: Color(0xffbbbbbb),
                            fontSize: 14
                          )
                        ),
                        initialValue: phoneNumber,
                        onInputChanged: (PhoneNumber number) {
                          phone.text = number.phoneNumber!;
                        },
                        textStyle: TextStyle(
                          fontSize: 14,
                        ),
                        selectorConfig: SelectorConfig(
                          selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                        ),
                        errorMessage: 'Numéro invalide',
                        selectorTextStyle: TextStyle(color: Colors.black),
                        formatInput: false,
                        inputBorder: InputBorder.none,
                        keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
                        onSaved: (PhoneNumber number) {
                          setState(() {
                            phone.text = number.phoneNumber!;
                          });
                        },
                        searchBoxDecoration: InputDecoration(
                          hintText: 'Rechercher',
                          contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                        ),
                      ),
                    ),
                    paddingTop(16),
                    TextFormField(
                      controller: password,
                      textInputAction:TextInputAction.next,
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
                      ),
                    ),
                    paddingTop(16),
                    TextFormField(
                      controller: confirm_password,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Veuillez s'il vous plait entrez votre mot de passe";
                        }
                        if (password.text!=confirm_password.text) {
                          return "Mot de passe différent";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(15),
                        hintText: 'Confirmer le mot de passe',
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
                      ),
                    ),
                    paddingTop(16),
                  ],
                )
              ),
              paddingTop(16),
              GestureDetector(
                onTap: () {
                  if (_formKey.currentState?.validate() ?? false) {
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
              paddingTop(100)
            ],
          )
        )
      );
  }
}