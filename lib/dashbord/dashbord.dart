// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:inguewa/function/function.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 40,
        backgroundColor: secondaryColor(),
        title: 
          Text(
            'Inguewa',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w100,
              fontFamily: 'louisewalker',
            ),
          ),
        ),
        body: Container(
          padding: EdgeInsets.all(15),
          child: SingleChildScrollView(
            child: Column(
              children: [

                Container(
                  padding: EdgeInsets.only(left: 15,right: 15),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                          },
                          child: Card(
                            margin: EdgeInsets.all(0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(17),
                            ),
                            color: Colors.white,
                            elevation: 0,
                            child: Container(
                              padding: EdgeInsets.only(left: 10,right: 10,top: 20,bottom: 20),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(17)
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    child: Image.asset('assets/images/file.png',height: 35),
                                    decoration: BoxDecoration(
                                      color: Color(0xfffff7ee),
                                      borderRadius: BorderRadius.circular(50)
                                    ),
                                  ),
                                  paddingTop(10),
                                  Text('Collectes\nEn attente',style: TextStyle(fontSize: 14,color: Colors.black,fontWeight: FontWeight.w700),textAlign: TextAlign.center,),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      paddingLeft(7),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(17),
                            ),
                            color: Colors.white,
                            elevation: 0,
                            child: Container(
                              padding: EdgeInsets.only(left: 10,right: 10,top: 20,bottom: 20),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(17)
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    child: Image.asset('assets/images/error.png',height: 35),
                                    decoration: BoxDecoration(
                                      color: Color(0xfffee4ea),
                                      borderRadius: BorderRadius.circular(50)
                                    ),
                                  ),
                                  paddingTop(10),
                                  Text('Collectes\nRejetées',style: TextStyle(fontSize: 14,color: Colors.black,fontWeight: FontWeight.w700),textAlign: TextAlign.center,),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 7,left: 15,right: 15,bottom: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                          },
                          child: Card(
                            margin: EdgeInsets.all(0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(17),
                            ),
                            color: Colors.white,
                            elevation: 0,
                            child: Container(
                              padding: EdgeInsets.only(left: 10,right: 10,top: 20,bottom: 20),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(17)
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    child: Image.asset('assets/images/approval.png',height: 35),
                                    decoration: BoxDecoration(
                                      color: Color(0xffe3f9ed),
                                      borderRadius: BorderRadius.circular(50)
                                    ),
                                  ),
                                  paddingTop(10),
                                  Text('Collectes\nValidées',style: TextStyle(fontSize: 14,color: Colors.black,fontWeight: FontWeight.w700),textAlign: TextAlign.center,),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      paddingLeft(10),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                  
                 
                          },
                          child: Card(
                            margin: EdgeInsets.all(0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(17),
                            ),
                            color: Colors.white,
                            elevation: 0,
                            child: Container(
                              padding: EdgeInsets.only(left: 15,right: 15,top: 20,bottom: 20),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(17)
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    child: Image.asset('assets/images/questionnaire-1.png',height: 35),
                                    decoration: BoxDecoration(
                                      color: Color.fromARGB(255, 238, 242, 253),
                                      borderRadius: BorderRadius.circular(50)
                                    ),
                                  ),
                                  paddingTop(10),
                                  Text('Nouvelle\nCollecte',style: TextStyle(fontSize: 14,color: Colors.black,fontWeight: FontWeight.w700),textAlign: TextAlign.center,),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                paddingTop(15),
              ],
            ),
          ),
        ),
      );
  }
}