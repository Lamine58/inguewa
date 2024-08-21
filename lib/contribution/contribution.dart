// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, prefer_interpolation_to_compose_strings
import 'dart:convert';

import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:inguewa/api/api.dart';
import 'package:inguewa/function/function.dart';
import 'package:inguewa/payement/payment.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Contribution extends StatefulWidget {

  var contribution;
  var contribution_id;

  Contribution(this.contribution,this.contribution_id,{Key? key}) : super(key: key);

  @override
  State<Contribution> createState() => _ContributionState();
}

class _ContributionState extends State<Contribution> {

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
  String amount = '';
  String total = '';
  NumberFormat currencyFormatter = NumberFormat.currency(locale: 'fr_XOF', symbol: 'XOF');
  var customer_id = '';

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
    searchController.addListener(filterItems);
    _scrollController.addListener(_scrollListener);
  }

  Future<void> _loadData() async {

    if (!_isLoading && next_page_url!=null) {

      setState(() {
        _isLoading = true;
      });

      try {

        dynamic response;

        response = await api.url(next_page_url+'&customer_id='+customer_id+'&contribution_id='+widget.contribution_id);
        
        print(response['data']);

        if (response != false) {
          setState(() {
            var data = response['data']['data'];
            next_page_url = response['data']['next_page_url'];
            total = response['total'].toString();
            amount = currencyFormatter.format(response['amount']);
            _isLoading = false;
            data.forEach((acte) {
              itemList.add(acte);
            });
            filteredList = itemList;
          });
        }
      } catch (e) {
        print(e);
        print('Veuillez verifier votre connexion internet');
      }
    }
  }
  

  init() async {

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var data = jsonDecode(prefs.getString('customerData') ?? 'null');
    customer_id = data['id'];

    var response = await api.get('payments?customer_id='+customer_id+'&contribution_id='+widget.contribution_id);

    try{
      if (response['status'] == 'success') {
        setState(() {
          itemList = response['data']['data'];
          next_page_url = response['data']['next_page_url'];
          total = response['total'].toString();
          amount = currencyFormatter.format(response['amount']);
          filteredList = itemList;
          load = false;
        });
      }
    }catch(err){
      print(err);
    }
  }

  void filterItems() {
    String query = searchController.text.toLowerCase();
    setState(() {
      filteredList = itemList.where((item) =>  item['reference_operateur'].toString().toLowerCase().contains(query)).toList();
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
          widget.contribution['name'],
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w100,
            fontFamily: 'louisewalker',
          ),
        ),
        toolbarHeight: 40,
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        padding: const EdgeInsets.only(top:0,bottom: 20,left: 10,right: 10),
        child: Row(
          children: [
            Expanded(
              child: Container(
                width: double.infinity, 
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: secondaryColor(),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Payment(widget.contribution,customer_id,widget.contribution_id),
                      ),
                    );
                  },
                  child: Text('Payer ma cotisation',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w300),textAlign: TextAlign.center)
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: secondaryColor(),
      body: 
        Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Transactions : $total",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w300),textAlign: TextAlign.start),
                paddingTop(5),
                Text("Total cotiser : $amount",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w300),textAlign: TextAlign.start),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 15,right: 15,top: 10),
            decoration: BoxDecoration(
              color: secondaryColor(),
            ),
            child: Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 55,
                    child: TextField(
                      style: TextStyle(color: Colors.white), // Couleur du texte
                      controller: searchController,
                        decoration: InputDecoration(
                          hintText: 'Recherche',
                          labelStyle: TextStyle(color: Colors.white), // Couleur du texte du label
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          hintStyle: TextStyle(color: Color.fromARGB(90, 245, 245, 245),fontWeight: FontWeight.w300),
                          filled: true,
                          fillColor: Colors.grey[200]?.withOpacity(0.2), // Couleur de fond (sera obscurcie par le dégradé)
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Colors.transparent,
                            )
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Color.fromARGB(77, 255, 255, 255),
                            )
                          ),
                          suffixIcon: Icon(BootstrapIcons.search,color: const Color.fromARGB(77, 255, 255, 255),)
                        ),
                    ),
                  ),
                )
              ],
            ),
          ),
          paddingTop(20),
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
                    child : Text('Aucune transaction')
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
                                          Text(item['reference_operateur'],textAlign:TextAlign.start,style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Roboto',fontSize: 15)),
                                          paddingTop(3),
                                          Text(currencyFormatter.format(double.parse(item['amount'])),textAlign:TextAlign.start,style: TextStyle(fontFamily: 'Roboto')),
                                          Text(dateLang(item['created_at']),textAlign:TextAlign.start,style: TextStyle(fontFamily: 'Roboto',fontSize: 12)),
                                        ],
                                      ),
                                    ),
                                  ),
                                  ImageChannel(item['channel'])
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