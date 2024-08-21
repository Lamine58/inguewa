// ignore_for_file: prefer_const_constructors, no_logic_in_create_state, prefer_typing_uninitialized_variables, prefer_const_declarations, no_leading_underscores_for_local_identifiers, unused_local_variable
import 'dart:convert';

import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inguewa/account/profil.dart';
import 'package:inguewa/account/shop.dart';
import 'package:inguewa/api/api.dart';
import 'package:inguewa/auth/login.dart';
import 'package:inguewa/event/event.dart';
import 'package:inguewa/function/function.dart';
import 'package:inguewa/home/home.dart';
import 'package:inguewa/service/service.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Tabs extends StatefulWidget {
  final index;
  final context;
  const Tabs(this.context,int this.index,{Key? key}) : super(key: key);
  
  @override
  State<Tabs> createState() => _TabsState(index);
}

class _TabsState extends State<Tabs> {

  _TabsState(this.index);

  final int index;
  late Api api = Api();
  var data;

  init() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      data = jsonDecode(prefs.getString('customerData') ?? 'null');
      refresh(data,prefs);
    });
  }

  @override
  void initState() {
    super.initState();
    init();
  }


  refresh(data,prefs) async {
    
    var response = await api.post('data', {"id":data['id']});

    try{
      if (response['status'] == 'success') {
        print(response);
        await prefs.setString('customerData', jsonEncode(response['customer']));
      }
    }catch(err){}

  }

  

  @override
  Widget build(BuildContext contexts) {

    PersistentTabController _controller;
    _controller = PersistentTabController(initialIndex: index);
    final iconSize = 27.0;

    List<Widget> _buildScreens(){
      return [
        Home(),
        Shop(),
        Service(null),
        Event(),
        data==null ? Login(context) : Profil(context),
      ];
    }

    List<PersistentBottomNavBarItem> _navBarsItems() {
        return [
            PersistentBottomNavBarItem(
                icon: Padding(
                  padding: const EdgeInsets.only(top:8.0),
                  child: Icon(BootstrapIcons.house,color: whiteColor()),
                ),
                inactiveIcon: Padding(
                  padding: const EdgeInsets.only(top:8.0),
                  child: Icon(BootstrapIcons.house,color: grayColor()),
                ),
                title: 'Acceuil',
                textStyle: TextStyle(fontSize: 11),
                activeColorPrimary: whiteColor(),
                inactiveColorPrimary: secondaryColor(),
                inactiveColorSecondary: secondaryColor(),
                iconSize: iconSize,
            ),
            PersistentBottomNavBarItem(
                icon: Padding(
                  padding: const EdgeInsets.only(top:8.0),
                  child: Icon(BootstrapIcons.shop,color: whiteColor()),
                ),
                inactiveIcon: Padding(
                  padding: const EdgeInsets.only(top:8.0),
                  child: Icon(BootstrapIcons.shop,color: grayColor()),
                ),
                title: 'Prestataires',
                textStyle: TextStyle(fontSize: 11),
                activeColorPrimary: whiteColor(),
                inactiveColorPrimary: secondaryColor(),
                inactiveColorSecondary: secondaryColor(),
                iconSize: iconSize,
            ),
            PersistentBottomNavBarItem(
                icon: Padding(
                  padding: const EdgeInsets.only(top:8.0),
                  child: Icon(BootstrapIcons.bag,color: whiteColor()),
                ),
                inactiveIcon: Padding(
                  padding: const EdgeInsets.only(top:8.0),
                  child: Icon(BootstrapIcons.bag,color: grayColor()),
                ),
                title: 'Services',
                textStyle: TextStyle(fontSize: 10),
                activeColorPrimary: whiteColor(),
                inactiveColorPrimary: secondaryColor(),
                inactiveColorSecondary: secondaryColor(),
                iconSize: iconSize
            ),
            PersistentBottomNavBarItem(
                icon: Padding(
                  padding: const EdgeInsets.only(top:8.0),
                  child: Icon(BootstrapIcons.calendar2_date,color: whiteColor()),
                ),
                inactiveIcon: Padding(
                  padding: const EdgeInsets.only(top:8.0),
                  child: Icon(BootstrapIcons.calendar2_date,color: grayColor()),
                ),
                title: 'Evènements',
                textStyle: TextStyle(fontSize: 10),
                activeColorPrimary: whiteColor(),
                inactiveColorPrimary: secondaryColor(),
                inactiveColorSecondary: secondaryColor(),
                iconSize: iconSize
            ),
            PersistentBottomNavBarItem(
                icon: Padding(
                  padding: const EdgeInsets.only(top:8.0),
                  child: Icon(BootstrapIcons.person_circle,color: whiteColor()),
                ),
                inactiveIcon: Padding(
                  padding: const EdgeInsets.only(top:8.0),
                  child: Icon(BootstrapIcons.person_circle,color: grayColor()),
                ),
                title: 'Espace',
                textStyle: TextStyle(fontSize: 10),
                activeColorPrimary: whiteColor(),
                inactiveColorPrimary: secondaryColor(),
                inactiveColorSecondary: secondaryColor(),
                iconSize: iconSize
            ),
        ];
    }

    return Scaffold(
      body:PersistentTabView(
        decoration: NavBarDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: EdgeInsets.all(20),
        padding: EdgeInsets.all(3),
        backgroundColor: CupertinoColors.black,
        context,
        controller: _controller,
        screens: _buildScreens(),
        items: _navBarsItems(),
        handleAndroidBackButtonPress: true,
        resizeToAvoidBottomInset: true,
        stateManagement: true, 
        navBarStyle: NavBarStyle.style2,
      ),
    );
  }
}