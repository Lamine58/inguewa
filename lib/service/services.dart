// ignore_for_file: prefer_const_constructors, empty_catches, prefer_const_literals_to_create_immutables
import 'dart:convert';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:inguewa/api/api.dart';
import 'package:inguewa/function/function.dart';
import 'package:inguewa/service/add-service.dart';
import 'package:inguewa/service/update-service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Services extends StatefulWidget {

  final context;
  const Services(this.context,{super.key});

  @override
  State<Services> createState() => _ServicesState();
}

class _ServicesState extends State<Services> {


  late Api api = Api();
  late bool load = true;
  var services = [];
  TextEditingController searchController = TextEditingController();
  List filteredList = [];
  List categories = [];
  var customer;

  init() async {

    setState(() {
      load = true;
    });

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    var data = jsonDecode(prefs.getString('customerData')!);
    var id = data['id'];
    customer = data;

    var response = await api.get('get-services?id=$id');
    try{
      if (response['status'] == 'success') {
        setState(() {
          services = response['services'];
          categories = response['categories'];
          filteredList = services;
          load = false;
        });
      }
    }catch(err){
    }
  }

  @override
  void initState() {
    super.initState();
    init();
    searchController.addListener(filterItems);
  }

  void filterItems() {
    String query = searchController.text.toLowerCase();
    setState(() {
      filteredList = services.where((item) =>
          item['name'].toString().toLowerCase().contains(query) ||
          item['description'].toString().toLowerCase().contains(query)
      ).toList();
    });
  }


  image(item){

    if(item['image_one']!=null) {
      return NetworkImage(api.getbaseUpload() + item['image_one']);
    }

    if(item['image_two']!=null) {
      return NetworkImage(api.getbaseUpload() + item['image_two']);
    }

    return  AssetImage('assets/images/74e6e7e382d0ff5d7773ca9a87e6f6f8817a68a.png');
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
          'Services (${services.length})',
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
        padding: const EdgeInsets.all(15),
        margin: EdgeInsets.only(bottom: 70),
        child: SizedBox(
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
                widget.context,
                MaterialPageRoute(
                  builder: (context) => AddService(categories,context),
                ),
              ).then((_) {
                init();
              });
            },
            child: Text('Ajouter un service',style: TextStyle(color: Colors.white,fontSize: 14),textAlign: TextAlign.center)
          ),
        ),
      ),
      body: load ? Center(child: CircularProgressIndicator(color: secondaryColor())) : !load && services.isEmpty ? 
        Center(child:
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(BootstrapIcons.window_stack,size: 100,color: Color.fromARGB(74, 238, 147, 0),),
              paddingTop(5),
              Text("Aucun service pour l'instant"),
            ],
          )
       ) :
        SingleChildScrollView(
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(10),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                Padding(
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
                        hintText: 'Recherchez un service',
                        hintStyle: TextStyle(
                          color: Color(0xffbbbbbb),
                          fontSize: 14
                        )
                      ),
                    ),
                  ),
                ),
                paddingTop(20),
                SingleChildScrollView(
                  child: Column(
                    children: [
                      for(var item in filteredList)
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              widget.context,
                              MaterialPageRoute(
                                builder: (context) => UpdateService(categories,item),
                              ),
                            ).then((_) {
                              init();
                            });
                          },
                          onLongPress: (){

                            if(customer['state']=='ADMIN'){
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Confirmation'),
                                      content: item['state']=="PENDING" ? Text('Voulez-vous vraiment valider la publication de ce évènement ?') : Text('Voulez-vous vraiment retirer la publication de ce évènement ?') ,
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop(false);
                                          },
                                          child: Text('Non'),
                                        ),
                                        TextButton(
                                          onPressed: () async {

                                            var response = await api.post('state', {"id":item['id'],"type":"service"});
                                            Navigator.pop(context);

                                            setState(() {
                                              item['state'] = 'WAIT';
                                            });

                                            setState(() {
                                              try{
                                                if (response['status'] == 'success') {
                                                  item['state'] = response['state'];
                                                }
                                              }catch(err){
                                                item['state'] = 'FAILD';
                                              }

                                            });
                                          },
                                          child: Text('Oui'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                            }
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.all(0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(10),
                                      height: 70,
                                      width: 70,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        image: DecorationImage(
                                          image: image(item),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    paddingLeft(10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            item['name'],
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          paddingTop(7),
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  '${item['price']} XOF',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                item['state']=='PENDING' 
                                                ? 'En attente'
                                                : item['state']=='WAIT' ?
                                                'Publication en cours'
                                                : item['state']=='FAILD' ?
                                                'Echec de la publication'
                                                : 'Valider',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Text(
                                            '${item['description'].length <= 30 ? item['description'] : item['description'].substring(0, 30) + '...'}',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w200,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Divider(),
                            ],
                          ),
                        ),
                    ],
                  ),
                )
              ],
            ),
          ),
                ),
        )
    );
  }
}