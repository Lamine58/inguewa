// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, prefer_interpolation_to_compose_strings
import 'dart:convert';

import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:inguewa/api/api.dart';
import 'package:inguewa/contribution/contribution.dart';
import 'package:inguewa/function/function.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Contributions extends StatefulWidget {
  final context;
  const Contributions(this.context,{Key? key}) : super(key: key);

  @override
  State<Contributions> createState() => _ContributionsState();
}

class _ContributionsState extends State<Contributions> {

  var load = true;
  int selectedOption = 0;
  List filteredList = [];
  List itemList = [];
  // ignore: non_constant_identifier_names
  dynamic next_page_url;
  TextEditingController searchController = TextEditingController();
  List options = [];
  final ScrollController _scrollController = ScrollController();
  late Api api = Api();
  bool _isLoading = false;

  String lang = 'Français';

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
        _loadData();
    }
  }

  @override
  void initState() {
    super.initState();
    init();
    data();
    searchController.addListener(filterItems);
    _scrollController.addListener(_scrollListener);
  }

  Future<void> _loadData() async {

    // if (!_isLoading && next_page_url!=null) {

    //   setState(() {
    //     _isLoading = true;
    //   });

    //   try {

    //     dynamic response;

    //     response = await api.url(next_page_url+'&id='+widget.id);

    //     if (response != false) {
    //       setState(() {
    //         var data = response['data']['data'];
    //         next_page_url = response['data']['next_page_url'];
    //         _isLoading = false;
    //         data.forEach((acte) {
    //           itemList.add(acte);
    //         });
    //         filteredList = itemList;
    //       });
    //     }
    //   } catch (e) {
    //     print(e);
    //     print('Veuillez verifier votre connexion internet');
    //   }
    // }
  }

  data() async {

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var data = jsonDecode(prefs.getString('customerData') ?? 'null');
    
    var response = await api.get('contributions?id=${data['id']}');

    try{
      if (response['status'] == 'success') {
        setState(() {
          itemList = response['data'];
          filteredList = itemList;
          load = false;
        });
      }
    }catch(err){}

  }

  init() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.getString('lang')!=null){
      setState(() {
        lang = prefs.getString('lang')!;
      });
    }
  }

  void filterItems() {
    String query = searchController.text.toLowerCase();
    setState(() {
      filteredList = itemList.where((item) =>  item['name'].toString().toLowerCase().contains(query)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white
        ),
        backgroundColor: secondaryColor(),
        title: Text(
          'Cotisations (${itemList.length})',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w100,
            fontFamily: 'louisewalker',
          ),
        ),
        toolbarHeight: 40,
      ),
      body: 
        Column(
        children: [
          Container(
            padding: EdgeInsets.only(left: 15,right: 15,top: 20),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 40,right: 40),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(0xfff1f3f4),
                        borderRadius: BorderRadius.circular(50.0), 
                      ),
                      child: TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(top: 7,bottom: 7,left: 35,right: 5),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.transparent, 
                              width:1.2
                            ),
                            borderRadius: BorderRadius.circular(50.0), 
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.transparent,
                              width:1.2,
                            ),
                            borderRadius: BorderRadius.circular(50.0), 
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.transparent,
                              width:1.2,
                            ),
                            borderRadius: BorderRadius.circular(50.0), 
                          ),
                          prefixIcon: Container(
                            width: 47,
                            margin: EdgeInsets.only(right: 10),
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50.0), 
                              color: secondaryColor(),
                            ),
                            child: Icon(BootstrapIcons.search, color: Colors.white,size: 24),
                          ),
                          suffixIcon: Icon(BootstrapIcons.funnel,color: secondaryColor()),
                          hintText: 'Recherchez une cotisation',
                          hintStyle: TextStyle(
                            color: Color(0xffbbbbbb),
                            fontSize: 14
                          )
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          load==false && filteredList.isEmpty
          ? Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(25),topRight: Radius.circular(25))
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child : Text('Aucune cotisation pour l\'instant')
                  ),
                ],
              ),
            ),
          )
          : load
          ? Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(25),topRight: Radius.circular(25))
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(child: CircularProgressIndicator(color: secondaryColor())),
                ],
              ),
            ),
          )
          : Expanded(
            child:Container(
            padding: EdgeInsets.only(top: 15,left: 5,right: 5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(25),topRight: Radius.circular(25))
            ),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: filteredList.length,
                      itemBuilder: (context, index) {
                        final item = filteredList[index];
                        return Container(
                          padding: EdgeInsets.all(7),
                          width: double.infinity,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                widget.context,
                                MaterialPageRoute(builder: (context) => Contribution(item,item['id']))
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 237, 237, 237),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Container(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(item['name'],textAlign:TextAlign.start,style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Roboto',fontSize: 15)),
                                          paddingTop(3),
                                          Text(item['amount'] ?? 'Non définie',textAlign:TextAlign.start,style: TextStyle(fontFamily: 'Roboto')),
                                          Text(dateLang(item['created_at']),textAlign:TextAlign.start,style: TextStyle(fontFamily: 'Roboto',fontSize: 12)),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Icon(Icons.chevron_right,color: primaryColor())
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}