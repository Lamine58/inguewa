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
  final BuildContext context;
  const Profil(this.context, {Key? key}) : super(key: key);

  @override
  State<Profil> createState() => _ProfilState();
}

class _ProfilState extends State<Profil> {
  late Api api = Api();
  var avatar;
  var fullName = '';
  var email = '';
  var state = 'PENDING';
  var user;
  bool isLoading = true;

  _navigateMenu(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  @override
  void initState() {
    super.initState();
    _initializeProfileData();
  }

  // Function to load user data from SharedPreferences
  _initializeProfileData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      var data = jsonDecode(prefs.getString('customerData')!);
      user = data;
      email = data["email"];
      state = data["state"];
      avatar = data["avatar"] == null
          ? AssetImage('assets/images/avatar.jpg')
          : NetworkImage(api.getbaseUpload() + data["avatar"]);
      fullName = data["first_name"] == null
          ? 'Non défini'
          : '${data["first_name"]} ${data["last_name"]}';
      isLoading = false; // Data has been loaded
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 20,
        backgroundColor: Colors.redAccent,

      ),
      body: isLoading
          ? _buildLoadingScreen()
          : _buildProfileScreen(context),
    );
  }

  // Loading screen UI
  Widget _buildLoadingScreen() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  // Profile screen UI
  Widget _buildProfileScreen(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          // Profile header (avatar, name, email)
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProfileHeader(),
                SizedBox(height: 25),
              ],
            ),
          ),

          // Menu Section
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildMenu(),
                    SizedBox(height: 30),
                    _buildSettings(),
                  ],
                ),
              ),
            ),
          ),

          // Bottom Section (App version and Logout)
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [

                SizedBox(height: 5),
                _buildVersion(),
                SizedBox(height: 5),

              ],
            ),
          ),
        ],
      ),
    );
  }

  // Profile Header UI (Avatar, Name, Email)
  Widget _buildProfileHeader() {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              widget.context,
              MaterialPageRoute(builder: (context) => Customer()),
            );
          },
          child: CircleAvatar(
            radius: 55.0,
            backgroundColor: Color.fromARGB(255, 244, 244, 244),
            backgroundImage: avatar,
          ),
        ),
        SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(fullName, style: TextStyle(fontSize: 25, color: Colors.redAccent, height: 1)),
              Text(email, style: TextStyle(color: Color.fromARGB(255, 123, 123, 123))),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    widget.context,
                    MaterialPageRoute(builder: (context) => Customer()),
                  );
                },
                child: Container(
                  margin: EdgeInsets.only(top: 7),
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 30),
                  child: Text(
                    'Modifier',
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.redAccent,),
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(width: 1.5, color: Colors.redAccent,),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  // Menu UI
  Widget _buildMenu() {
    return Container(
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
          SizedBox(height: 8),
          _menuItem('Membres', BootstrapIcons.people, () {
            _navigateMenu(context, Customers());
          }),
          SizedBox(height: 8),
          // Grey Divider
          Divider(
            color: Colors.grey,  // Grey color for the divider
            thickness: 1,         // Thickness of the divider
          ),
          SizedBox(height: 8),

          _menuItem('Cotisation', BootstrapIcons.cash_coin, () {
            _navigateMenu(context, Contributions(widget.context));
          }),
          SizedBox(height: 8),

          // Grey Divider
          Divider(
            color: Colors.grey,  // Grey color for the divider
            thickness: 1,         // Thickness of the divider
          ),
          SizedBox(height: 8),
          _menuItem('Evènements', BootstrapIcons.mic, () {
            _navigateMenu(context, Events(widget.context));
          }),
          SizedBox(height: 8),

          // Grey Divider
          Divider(
            color: Colors.grey,  // Grey color for the divider
            thickness: 1,         // Thickness of the divider
          ),
          SizedBox(height: 8),
          _menuItem('Services', BootstrapIcons.window_stack, () {
            _navigateMenu(context, Services(widget.context));
          }),
          SizedBox(height: 8),
        ],
      ),
    );
  }

  // Menu Item Widget (Reusable)
  Widget _menuItem(String text, IconData icon, Function() onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 10),
        child: Row(
          children: [
            Icon(icon, color: Color(0xff7d848b), size: 26),
            SizedBox(width: 13),
            Expanded(
              child: Text(text, style: TextStyle(fontSize: 16, color: Color(0xff7d848b))),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: Color(0xff7d848b)),
          ],
        ),
      ),
    );
  }

  // Settings (Profile, Support, Logout)
  Widget _buildSettings() {
    return Container(
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
          SizedBox(height: 8),
          _menuItem('Votre profil', BootstrapIcons.person_badge, () {
            _navigateMenu(context, Customer());
          }),
          SizedBox(height: 8),

          // Grey Divider
          Divider(
            color: Colors.grey,  // Grey color for the divider
            thickness: 1,         // Thickness of the divider
          ),

          SizedBox(height: 8),

          _menuItem('Contactez le support', BootstrapIcons.headset, () {
            _navigateMenu(context, Support());
          }),
          Divider(
            color: Colors.grey,  // Grey color for the divider
            thickness: 1,         // Thickness of the divider
          ),
          SizedBox(height: 8),
          _logoutItem(),

          SizedBox(height: 8),
        ],
      ),

    );
  }

  // Red "Déconnexion" item
  Widget _logoutItem() {
    return GestureDetector(
      onTap: () {
        _showLogoutDialog();
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 10),
        child: Row(
          children: [
            Icon(BootstrapIcons.box_arrow_left, color: Colors.red, size: 26),
            SizedBox(width: 13),
            Expanded(
              child: Text('Déconnexion', style: TextStyle(fontSize: 16, color: Colors.red)),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.red),
          ],
        ),
      ),
    );
  }

  // App Version at the bottom
  Widget _buildVersion() {
    return Container(
      padding: EdgeInsets.all(10),
      child: Center(
        child: Text('v1.0.0-beta', style: TextStyle(color: grayColor(), fontSize: 12)),
      ),
    );
  }

  // Logout Dialog
  void _showLogoutDialog() {
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
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Tabs(context, 0)), (routes) => false);
              },
              child: Text('Oui'),
            ),
          ],
        );
      },
    );
  }
}
