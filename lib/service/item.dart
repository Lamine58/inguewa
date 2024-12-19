import 'dart:convert';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:inguewa/api/api.dart';
import 'package:inguewa/customer/profil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';

class Item extends StatefulWidget {
  final item;
  const Item(this.item, {super.key});

  @override
  State<Item> createState() => _ItemState();
}

class _ItemState extends State<Item> {
  late Api api = Api();
  var images = [];
  var phone = '';
  var id = '';
  var customer;

  init() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      print(widget.item);

      print('ddddddddddddddddddddddddddddddddd');

      images.add(widget.item['image_one']);
      widget.item['qte'] = 1;

      if (widget.item['image_two'] != null) {
        images.add(widget.item['image_two']);
      }

      // var data = jsonDecode(prefs.getString('customerData')!);
      var data =  widget.item['customer'];
      id = data['id'];
      phone = data['business_phone'];
      customer = data;
    //  customer = widget.item['customer'];
    });
  }

  avatar() {
    return NetworkImage(api.getbaseUpload() + customer['business_logo']);
  }

  image(image) {
    if (image != null) {
      return NetworkImage(api.getbaseUpload() + image);
    }
    return AssetImage('assets/images/74e6e7e382d0ff5d7773ca9a87e6f6f8817a68a.png');
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        toolbarHeight: 40,
        backgroundColor: Colors.redAccent,
        title: Text(
          'Produit',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w100,
            fontFamily: 'louisewalker',
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
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
                    SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
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
                          SizedBox(height: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    '${customer['business_name']}',
                                    style: TextStyle(
                                      color: const Color.fromARGB(255, 0, 0, 0),
                                      fontSize: 25,
                                      height: 1.2,
                                    ),
                                    textAlign: TextAlign.start,
                                  ),
                                  SizedBox(height: 5),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 5),
                                    child: Icon(
                                      BootstrapIcons.patch_check_fill,
                                      color: const Color.fromARGB(255, 98, 242, 103),
                                    ),
                                  )
                                ],
                              ),
                              Text(
                                '${customer['business_phone']}',
                                style: TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 13, height: 1.2),
                                textAlign: TextAlign.start,
                              ),
                              Text(
                                '${customer['business_email']}',
                                style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0), fontSize: 14, height: 1.2),
                                textAlign: TextAlign.start,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      widget.item['name'],
                      style: TextStyle(fontSize: 25),
                    ),
                    Text(
                      '${widget.item['price']} XOF',
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(height: 10),
                    Text(
                      widget.item['description'],
                      style: TextStyle(fontSize: 14),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 50,
              margin: EdgeInsets.all(10),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                onPressed: () async {
                  await FlutterPhoneDirectCaller.callNumber(phone);
                },
                child: Row(
                  children: [
                    Expanded(child: Text('Contact : ${phone}', style: TextStyle(color: Colors.white))),
                    Icon(Icons.phone, color: Colors.white)
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
