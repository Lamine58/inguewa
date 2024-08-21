// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:inguewa/api/api.dart';
import 'package:inguewa/function/function.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

class Slide extends StatefulWidget {
  final banner;
  const Slide(this.banner,{super.key});

  @override
  State<Slide> createState() => _SlideState();
}

class _SlideState extends State<Slide> {

  late Api api = Api();
  var contacts = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var data = widget.banner['phone'].replaceAll(' ', '');
    contacts = data.split('/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 40,
        backgroundColor: secondaryColor(),
        iconTheme: IconThemeData(color: Colors.white),
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
        body: SingleChildScrollView(
          child: Column(
            children: [
              Image.network(api.getbaseUpload()+widget.banner['banner'],fit: BoxFit.cover),
              Container(
                padding: EdgeInsets.all(15),
                child: Text(widget.banner['description']),
              ),
              for(var contact in contacts)
                Container(
                  margin: EdgeInsets.only(left: 15,right: 15,top: 10),
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: secondaryColor(),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      )
                    ),
                    onPressed: () async {
                        await FlutterPhoneDirectCaller.callNumber(contact);
                    },
                    child: Row(
                      children: [
                        Expanded(child: Text('Numéro : ${contact}',style: TextStyle(color: Colors.white))),
                        Icon(Icons.phone,color: Colors.white)
                      ],
                    )
                  )
                ),
              paddingTop(100),
            ],
          ),
        ),
      );
  }
}