// ignore_for_file: prefer_const_constructors

import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:inguewa/auth/login.dart';
import 'package:inguewa/function/function.dart';
import 'package:latlong2/latlong.dart';


class Location extends StatelessWidget {

  MapController mapController = MapController();

  Location({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 40,
        backgroundColor: secondaryColor(),
        title: 
          Text(
            'A proximité',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w100,
              fontFamily: 'louisewalker',
            ),
          ),
          actions: [
            GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => Login(context)));
              },
              child: Container(
                padding: EdgeInsets.only(left: 15,right: 15),
                child: Icon(BootstrapIcons.person_circle,color: Color.fromARGB(255, 189, 189, 189).withOpacity(0.5)),
              ),
            )
          ],
        ),
      body: 
        Stack(
        children: [
          SizedBox(
            width: MediaQuery.sizeOf(context).width,
            height: MediaQuery.sizeOf(context).height,
            child: FlutterMap(
              mapController: mapController,
              options: MapOptions(
                initialCenter: LatLng(5.3623365,-3.9988786),
                initialZoom: 12,
              ),
              children: [
                TileLayer(
                  urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: const ['a', 'b', 'c'],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
