// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, avoid_unnecessary_containers, sort_child_properties_last, deprecated_member_use
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:inguewa/api/api.dart';
import 'package:inguewa/function/function.dart';
import 'package:inguewa/service/item.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profil extends StatefulWidget {

  final data;
  const Profil(this.data,{Key? key}) : super(key: key);

  @override
  State<Profil> createState() => _ProfilState();

}

class _ProfilState extends State<Profil> {

  late Api api = Api();
  late bool load = true;
  var services = [];
  TextEditingController searchController = TextEditingController();
  List filteredList = [];
  List categories = [];

  init() async {

    setState(() {
      load = true;
    });

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    var response = await api.get('get-services?id=${this.widget.data['id']}');
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
        toolbarHeight: 40,
        title: Text(
          '${widget.data['first_name']} ${widget.data['last_name']}',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w100,
            fontFamily: 'louisewalker',
          ),
        ),
        backgroundColor: secondaryColor(),
        elevation: 0,
      ),
      body: Container(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Stack(
                    children: [
                      widget.data['business_logo']!=null ?
                      Container(
                        height: 200,
                        width: double.infinity,
                        child: Image.network(
                          api.getbaseUpload() + widget.data['business_logo'],
                          fit: BoxFit.cover,
                        ),
                      ) : SizedBox(),
                      Container(
                        height: 200,
                        width: double.infinity,
                        color: Colors.black.withOpacity(0.4),
                      ),
                    ],
                  ),
                  Positioned(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            Text('${widget.data['business_name']}',style: TextStyle(color:Colors.white,fontSize: 25,height: 1.2),textAlign: TextAlign.end),
                            paddingLeft(5),
                            Padding(
                              padding: const EdgeInsets.only(bottom:5),
                              child: Icon(BootstrapIcons.patch_check_fill,color: const Color.fromARGB(255, 98, 242, 103),),
                            )
                          ],
                        ),
                        Text('${widget.data['business_phone']}',style: TextStyle(color:Colors.white,fontSize: 15,height: 1.2),textAlign: TextAlign.end),
                        Text('${widget.data['business_email']}',style: TextStyle(color:Colors.white,fontSize: 17,height: 1.2),textAlign: TextAlign.end),
                      ],
                    ),
                    bottom: 50,
                    right: 10,
                  ),
                  Positioned(
                    top: 120,
                    left: 20,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius:BorderRadius.circular(150),
                        border: Border.all(
                          width: 5,
                          color: Color.fromARGB(37, 255, 255, 255)
                        )
                      ),
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(api.getbaseUpload()+widget.data['avatar']),
                        backgroundColor: Color.fromARGB(255, 244, 244, 244),
                      ),
                      height: 120,
                      width: 120,
                    ),
                  ),
                  paddingTop(240),
                ],
              ),
              paddingTop(20),
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
                          color: primaryColor(),
                        ),
                        child: Icon(BootstrapIcons.search, color: Colors.white,size: 24),
                      ),
                      suffixIcon: Icon(BootstrapIcons.funnel,color: primaryColor()),
                      hintText: 'Recherchez un service',
                      hintStyle: TextStyle(
                        color: Color(0xffbbbbbb),
                        fontSize: 14
                      )
                    ),
                  ),
                ),
              ),
              paddingTop(10),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Text('Services',style: TextStyle(fontSize: 20),),
              ),
              Expanded(
                child: load ? Center(child: CircularProgressIndicator(color: secondaryColor())) : services.isEmpty ?  Center(child: Text("Aucun service")) : Padding(
                  padding: const EdgeInsets.all(5),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        for(var item in filteredList)
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Item(item),
                                ),
                              ).then((_) {
                                init();
                              });
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
                                                )
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
                  ),
                ),
              ),
              paddingTop(80),
            ],
          ),
        ),
      )
    );
  }
}