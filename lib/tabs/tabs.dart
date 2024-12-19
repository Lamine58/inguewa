import 'dart:convert';

import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:inguewa/account/profil.dart';
import 'package:inguewa/account/shop.dart';
import 'package:inguewa/api/api.dart';
import 'package:inguewa/auth/login.dart';
import 'package:inguewa/event/event.dart';
import 'package:inguewa/home/home.dart';
import 'package:inguewa/service/service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Tabs extends StatefulWidget {
  final int index;
  final BuildContext context;
  const Tabs(this.context, this.index, {Key? key}) : super(key: key);

  @override
  State<Tabs> createState() => _TabsState(index);
}

class _TabsState extends State<Tabs> {
  _TabsState(this.index);

  final int index;
  late Api api = Api();
  var data;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = index;
    init();
  }

  init() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      data = jsonDecode(prefs.getString('customerData') ?? 'null');
      refresh(data, prefs);
    });
  }

  refresh(data, prefs) async {
    var response = await api.post('data', {"id": data['id']});
    try {
      if (response['status'] == 'success') {
        await prefs.setString('customerData', jsonEncode(response['customer']));
      }
    } catch (err) {}
  }

  // Liste des écrans pour chaque onglet
  List<Widget> _screens() {
    return [
      Home(),
      Shop(),
      Service(null),
      Event(),
      data == null ? Login(context) : Profil(context),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens()[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        backgroundColor: Colors.white,
        selectedItemColor: Colors.redAccent,
        unselectedItemColor: Colors.black,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed, // Supporte plus de 4 onglets
        items: [
          BottomNavigationBarItem(
            icon: Icon(BootstrapIcons.house),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Icon(BootstrapIcons.shop),
            label: 'Prestataires',
          ),
          BottomNavigationBarItem(
            icon: Icon(BootstrapIcons.bag),
            label: 'Services',
          ),
          BottomNavigationBarItem(
            icon: Icon(BootstrapIcons.calendar2_date),
            label: 'Évènements',
          ),
          BottomNavigationBarItem(
            icon: Icon(BootstrapIcons.person_circle),
            label: 'Espace',
          ),
        ],
      ),
    );
  }
}
