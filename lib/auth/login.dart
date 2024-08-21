// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:inguewa/auth/password.dart';
import 'package:inguewa/auth/sign-in.dart';
import 'package:inguewa/function/function.dart';

class Login extends StatefulWidget {

  final BuildContext context;
  const Login(this.context,{Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 50,
          backgroundColor: whiteColor(),
          title: 
            Text(
              'Inguewa',
              style: TextStyle(
                color: secondaryColor(),
                fontSize: 20,
                fontWeight: FontWeight.w100,
                fontFamily: 'louisewalker',
              ),
            ),
            bottom: TabBar(
              padding: EdgeInsets.all(10),
              indicatorColor: primaryColor(),
              unselectedLabelColor: secondaryColor(),
              indicatorWeight: 3,
              labelColor: primaryColor(),
              tabs: const [
                Tab(text:'Connexion'),
                Tab(text: 'Inscription',),
              ],
            ),
          ),
          backgroundColor: Colors.white,
          body: TabBarView(
            children: [
              SingleChildScrollView(
                child: Password(widget.context),
              ),
              SingleChildScrollView(
                child: SignIn(widget.context),
              ),
            ],
          ),
        ),
      );
  }
}