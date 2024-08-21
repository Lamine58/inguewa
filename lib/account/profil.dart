// ignore_for_file: prefer_const_constructors, sort_child_properties_last, prefer_const_literals_to_create_immutables
import 'dart:convert';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:inguewa/api/api.dart';
import 'package:inguewa/contribution/contributions.dart';
import 'package:inguewa/customer/customer.dart';
import 'package:inguewa/customer/customers.dart';
import 'package:inguewa/event/events.dart';
import 'package:inguewa/function/function.dart';
import 'package:inguewa/inguewa/support.dart';
import 'package:inguewa/service/services.dart';
import 'package:inguewa/tabs/tabs.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profil extends StatefulWidget {
  final context;
  const Profil(this.context,{Key? key}) : super(key: key);

  @override
  State<Profil> createState() => _ProfilState();
}


class _ProfilState extends State<Profil> {
  
  late Api api = Api();

  var avatar;
  var full_name = '';
  var email = '';
  var state = 'PENDING';
  var user;

  _navigateMenu(context, page) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => page
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
  
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {

      var data = jsonDecode(prefs.getString('customerData')!);
      user = data;
      email = data["email"];
      state = data["state"];
      avatar = data["avatar"]==null ? AssetImage('assets/images/avatar.jpg') : NetworkImage(api.getbaseUpload()+data["avatar"]);

      if(data["first_name"]==null){
        full_name = 'Non défini';
      }else{
        full_name = '${data["first_name"]} ${data["last_name"]}';
      }

    });
  }

  @override
  Widget build(BuildContext context) {

    _item(text,icon,{line=true}){
      return Container(
        margin: EdgeInsets.only(bottom: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(padding: EdgeInsets.only(top: 7),child: Icon(icon,color: Color(0xff7d848b),size: 26,)),
            paddingLeft(13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  paddingTop(2),
                  Container(
                    padding: line ? EdgeInsets.only(bottom: 10,top:3) : EdgeInsets.only(top:3),
                    width: double.infinity,
                    child: Text(text,style: TextStyle(fontSize: 16,color: Color(0xff7d848b))),
                    decoration: BoxDecoration(
                      border: line ? Border(
                        bottom: BorderSide(
                          width: 1.5,
                          color: Color.fromARGB(255, 241, 241, 241)
                        )
                      ) : Border()
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      );
    }
    _itemIcon(text,image,{line=true}){
      return Container(
        margin: EdgeInsets.only(bottom: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            image,
            paddingLeft(13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    padding: line ? EdgeInsets.only(bottom: 7,top:3) : EdgeInsets.only(top:3),
                    width: double.infinity,
                    child: Text(text,style: TextStyle(fontSize: 16,color: Color(0xff7d848b))),
                    decoration: BoxDecoration(
                      border: line ? Border(
                        bottom: BorderSide(
                          width: 1.5,
                          color: Color.fromARGB(255, 241, 241, 241)
                        )
                      ) : Border()
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
      toolbarHeight: 40,
      backgroundColor: secondaryColor(),
      title: 
        Text(
          'Espace',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w100,
            fontFamily: 'louisewalker',
          ),
        ),
      ),
      body: state=='PENDING'
      ? Container(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            logo(150),
            paddingTop(10),
            Text('Votre compte n\'a pas encore été activer par l\'administrateur',textAlign: TextAlign.center,style: TextStyle(fontSize: 16)),
          ],
        ),
      )
      : Container(
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      paddingTop(20),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                widget.context,
                                MaterialPageRoute(builder: (context) => Customer())
                              );
                            },
                            child: SizedBox(
                              child: CircleAvatar(
                                radius: 55.0,
                                backgroundColor: Color.fromARGB(255, 244, 244, 244),
                                backgroundImage: avatar,
                              )
                            ),
                          ),
                          paddingLeft(15),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(full_name,style: TextStyle(fontSize: 25,color: primaryColor(),height: 1)),
                                Text(email,style: TextStyle(color: Color.fromARGB(255, 123, 123, 123))),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      widget.context,
                                      MaterialPageRoute(builder: (context) => Customer())
                                    );
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(top:7),
                                    padding: EdgeInsets.only(top: 5,bottom: 5,left: 30,right: 30),
                                    child: Text('Modifier',style: TextStyle(fontWeight: FontWeight.bold,color:primaryColor())),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      border: Border.all(
                                        width: 1.5,
                                        color: primaryColor()
                                      )
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                      paddingTop(25),
                      Container(
                        padding: EdgeInsets.all(12),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: const Color.fromARGB(255, 212, 212, 212).withOpacity(0.5),
                              spreadRadius: 1,
                              blurRadius: 9,
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: (){
                                _navigateMenu(context, Customers());
                              },
                              child: _item('Membres',BootstrapIcons.people)
                            ),
                            GestureDetector(
                              onTap: (){
                                _navigateMenu(context, Contributions(widget.context));
                              },
                              child: _item('Cotisation',BootstrapIcons.cash_coin)
                            ),
                            GestureDetector(
                              onTap: (){
                                _navigateMenu(context, Events(widget.context));
                              },
                              child: _item('Evènements',BootstrapIcons.mic)
                            ),
                            GestureDetector(
                              onTap: (){
                                _navigateMenu(context, Services(widget.context));
                              },
                              child: _item('Services',BootstrapIcons.window_stack,line: false),
                            ),
                            // GestureDetector(
                            //   onTap: (){
                            //     _navigateMenu(context, 'transactions');
                            //   },
                            //   child: _item('Transactions',BootstrapIcons.credit_card,line: false)
                            // ),
                          ], 
                        )
                      ),
                      paddingTop(30),
                      Container(
                        padding: EdgeInsets.all(12),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: const Color.fromARGB(255, 212, 212, 212).withOpacity(0.5),
                              spreadRadius: 1,
                              blurRadius: 9,
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  widget.context,
                                  MaterialPageRoute(builder: (context) => Customer())
                                );
                              },
                              child: _item('Votre profil',BootstrapIcons.person_badge)
                            ),
                            GestureDetector(
                              onTap: (){
                                _navigateMenu(context, Support());
                              },
                              child: _item('Contactez le support',BootstrapIcons.headset),
                            ),
                            GestureDetector(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('Confirmation'),
                                        content: Text('Voulez-vous vraiment vous déconnecter?'),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop(false);
                                            },
                                            child: Text('Non'),
                                          ),
                                          TextButton(
                                            onPressed: () async {
                                              final SharedPreferences prefs = await SharedPreferences.getInstance();
                                              await prefs.remove('customerData');
                                              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Tabs(context,0)),(routes)=>false);
                                            },
                                            child: Text('Oui'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                              },
                              child: _item('Déconnexion',BootstrapIcons.box_arrow_left,line:false)
                            ),
                          ], 
                        ),
                      ),
                      paddingTop(15),
                      Center(child: Text('v1.0.0-beta',style: TextStyle(color: grayColor()),)),
                      paddingTop(30)
                    ]
                  ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DrawerButtonItem extends StatelessWidget {
  const DrawerButtonItem({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        Scaffold.of(context).openDrawer();
      },
      icon: Image.asset('assets/images/menu.png',width: 22),
      color: Colors.white,
      highlightColor: Colors.transparent,
      constraints: const BoxConstraints.tightFor(
        width: 50.0,
        height: 50.0,
      ),
    );
  }
}
