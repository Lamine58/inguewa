// ignore_for_file: prefer_const_constructors

import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:inguewa/function/function.dart';

class Support extends StatefulWidget {
  const Support({Key? key}) : super(key: key);

  @override
  State<Support> createState() => _SupportState();
}

class _SupportState extends State<Support> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white
        ),
        backgroundColor: Colors.redAccent,
        title: Text(
          'Supprots',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w100,
            fontFamily: 'louisewalker',
          ),
        ),
        toolbarHeight: 40,
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      logo(150),
                      paddingTop(30),
                      Icon(BootstrapIcons.headset,size: 70,color: Colors.redAccent,),
                      paddingTop(5),
                      Text('(+225) 0102030405 / (+225) 0102030405',textAlign: TextAlign.center,),
                      paddingTop(5),
                      Text('(+225) 0102030405',textAlign: TextAlign.center,),
                      paddingTop(10),
                      Icon(BootstrapIcons.chat_dots,size: 70,color:Colors.redAccent,),
                      paddingTop(10),
                      Text('support@inguewa.ci',textAlign: TextAlign.center,),
                      paddingTop(20),
                      Text("Chez Inguewa, votre satisfaction est notre priorité. Notre équipe dévouée est là pour vous aider à résoudre tout problème ou répondre à toute question que vous pourriez avoir. N'hésitez pas à nous contacter pour toute assistance ou assistance technique",textAlign: TextAlign.center,),
                    ],
                  ),
                ),
              ),
            )
          )
        ],
      )
    );
  }
}