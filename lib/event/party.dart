// ignore_for_file: prefer_const_constructors, empty_catches, prefer_const_literals_to_create_immutables
import 'dart:convert';

import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:inguewa/api/api.dart';
import 'package:inguewa/customer/profil.dart';
import 'package:inguewa/function/function.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';

class Party extends StatefulWidget {
  final party;
  const Party(this.party,{super.key});

  @override
  State<Party> createState() => _PartyState();
}

class _PartyState extends State<Party> {

  late Api api = Api();
  var images = [];
  var phone = '';
  var id  = '';
  var customer;

  init() async {

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {

      images.add(widget.party['banner']);
      var data = jsonDecode(prefs.getString('customerData')!);
      id = data['id'];
      phone = data['business_phone'];
      customer = data;
      
    });

  }


  avatar(){
    return NetworkImage(api.getbaseUpload()+customer['business_logo']);
  }


  image(image){

    if(image!=null) {
      return NetworkImage(api.getbaseUpload() + image);
    }
    return  AssetImage('assets/images/74e6e7e382d0ff5d7773ca9a87e6f6f8817a68a.png');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white
        ),
        toolbarHeight: 40,
        backgroundColor: secondaryColor(),
        title: 
          Text(
            'Evènment',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w100,
              fontFamily: 'louisewalker',
            ),
          ),
        ),
        body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FlutterCarousel(
                options: CarouselOptions(
                  height: 300.0, 
                  showIndicator: true,
                ),
                items: images.map((data) {
                  return Builder(
                    builder: (BuildContext context) {
                    return Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          image: DecorationImage(
                            image: image(data),
                            fit: BoxFit.contain,
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
              paddingTop(20),
              GestureDetector(
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Profil(customer),
                    ),
                  );
                },
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: avatar(),
                      backgroundColor: Color.fromARGB(255, 244, 244, 244),
                      radius: 40,
                    ),
                    paddingLeft(10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text('${customer['business_name']}',style: TextStyle(color:const Color.fromARGB(255, 0, 0, 0),fontSize: 25,height: 1.2),textAlign: TextAlign.start),
                            paddingLeft(5),
                            Padding(
                              padding: const EdgeInsets.only(bottom:5),
                              child: Icon(BootstrapIcons.patch_check_fill,color: const Color.fromARGB(255, 98, 242, 103),),
                            )
                          ],
                        ),
                        Text('${customer['business_phone']}',style: TextStyle(color:Color.fromARGB(255, 0, 0, 0),fontSize: 13,height: 1.2),textAlign: TextAlign.start),
                        Text('${customer['business_email']}',style: TextStyle(color:const Color.fromARGB(255, 0, 0, 0),fontSize: 14,height: 1.2),textAlign: TextAlign.start),
                      ],
                    ),
                  ],
                ),
              ),
              paddingTop(10),
              Text(widget.party['name'],style: TextStyle(fontSize: 25),),
              Text('${widget.party['space']} le ${widget.party['date']} à ${widget.party['hour']}',style: TextStyle(fontSize: 12),),
              paddingTop(20),
              Text(widget.party['description'],style: TextStyle(fontSize: 14),),
              paddingTop(20),
              Container(
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
                      await FlutterPhoneDirectCaller.callNumber(phone);
                  },
                  child: Row(
                    children: [
                      Expanded(child: Text('Infoline : ${phone}',style: TextStyle(color: Colors.white))),
                      Icon(Icons.phone,color: Colors.white)
                    ],
                  )
                )
              ),
              paddingTop(100),
            ],
          ),
        ),
      )
    );
  }
}