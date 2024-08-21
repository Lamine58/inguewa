// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:inguewa/api/api.dart';
import 'package:inguewa/banner/slide.dart';
import 'package:inguewa/event/party.dart';
import 'package:inguewa/function/function.dart';
import 'package:inguewa/service/service.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  var categories = [];
  var banners = [];
  var load = true;
  late Api api = Api();
  List<dynamic> events_all = [];
  List<dynamic> events_coming = [];
  TextEditingController searchController = TextEditingController();
  List filteredList = [];


  @override
  void initState() {
    super.initState();
    init();
    searchController.addListener(filterItems);
  }


  void filterItems() {
    String query = searchController.text.toLowerCase();
    setState(() {
      filteredList = events_all.where((item) =>
          item['name'].toString().toLowerCase().contains(query) ||
          item['description'].toString().toLowerCase().contains(query)
      ).toList();
    });
  }

  init() async {
    
    var response = await api.get('get-data');

    try{
      if (response['status'] == 'success') {
        setState(() {
          categories = response['categories'];
          banners = response['banners'];
          events_all = response['events'];
          events_coming = response['events_coming'];
          load = false;
          filteredList = events_all;
        });
      }
    }catch(err){
      print(err);
    }
    
  }

  Future<void> _refreshPage() async {
    await Future.delayed(Duration(seconds: 3));
    setState(() {
      init();
    });
  }


  @override
  Widget build(BuildContext context) {

    return RefreshIndicator(
      onRefresh: _refreshPage,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 40,
          backgroundColor: secondaryColor(),
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
          body: load ? Center(child: CircularProgressIndicator(color:secondaryColor())) : Column(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(asset('arriere-plan-vectoriel-motif-pointille-dans-style-aborigene_619130-1630.avif')),
                    fit: BoxFit.cover, // or BoxFit.fill depending on your need
                  ),
                ),
                child: SizedBox(
                  height: 55,
                  child: TextField(
                    controller: searchController,
                    style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(10),
                        hintText: 'Recherche',
                        labelStyle: TextStyle(color: Colors.white),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        hintStyle: TextStyle(color: Color.fromARGB(169, 255, 255, 255),fontWeight: FontWeight.w300,fontSize: 15),
                        filled: true,
                        fillColor: const Color.fromARGB(255, 0, 0, 0)?.withOpacity(.8),
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
                        suffixIcon: Icon(BootstrapIcons.search,color: Color.fromARGB(188, 255, 255, 255),size: 20),
                        prefixIcon: Container(child: Image.asset(asset('cauris.png')),padding: EdgeInsets.all(7),)
                      ),
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Container(
                          padding: EdgeInsets.all(7),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              for(var banner in banners)
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Slide(banner),
                                      ),
                                    );
                                  },
                                  child: Stack(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(right: 10),
                                        height: 150,
                                        width: MediaQuery.sizeOf(context).width-70,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(9),
                                          child: Image.network(
                                            api.getbaseUpload()+banner['banner'],
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          border: Border.all(width: 1,color: Color.fromARGB(255, 220, 220, 220))
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 10,
                                        right: 20,
                                        child: Container(
                                          padding: EdgeInsets.only(left: 10,top: 3,bottom: 3,right: 3),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(15),
                                            color: Colors.white,
                                            border: Border.all(
                                              width: .5,
                                              color: Color.fromARGB(255, 209, 176, 76),
                                            )
                                          ),
                                          child: Row(
                                            children: [
                                              Text('Voir plus',style: TextStyle(fontFamily: 'Polyester',fontSize: 12),),
                                              paddingLeft(10),
                                              Container(
                                                height: 23,
                                                width: 23,
                                                child: Icon(Icons.arrow_forward,color: Colors.white,size: 15,),
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(50),
                                                  color: Color.fromARGB(255, 209, 176, 76),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text('Services',style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),),
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Container(
                          padding: EdgeInsets.all(7),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              for(var icon in categories)
                                GestureDetector(
                                  onTap: (){
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Service(icon['id']),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(right: 7,left: 7),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          height: 50,
                                          width: 50,
                                          padding: EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(50),
                                            border: Border.all(width: 1,color: secondaryColor())
                                          ),
                                          child: Image.network(api.getbaseUpload()+icon['icon']),
                                        ),
                                        Text(icon['name'],style: TextStyle(fontSize: 12),textAlign: TextAlign.center)
                                      ],
                                    ),
                                  ),
                                )
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text('Événements venir',style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),),
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Container(
                          padding: EdgeInsets.all(7),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              for(var event in events_coming)
                                GestureDetector(
                                  onTap: (){
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Party(event),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    width: events_all.length>1 ? MediaQuery.sizeOf(context).width/2+20 : MediaQuery.sizeOf(context).width-15,
                                    margin: EdgeInsets.only(right: 10),
                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(width: 1,color: Color.fromARGB(255, 220, 220, 220))
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Stack(
                                          children: [
                                            Container(
                                              height: 130,
                                              width: events_all.length>1 ? MediaQuery.sizeOf(context).width/2+20 : MediaQuery.sizeOf(context).width-15,
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(9),
                                                child: Image.network(api.getbaseUpload()+event['banner'],
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(10),
                                                border: Border.all(width: 1,color: Color.fromARGB(255, 220, 220, 220))
                                              ),
                                            ),
                                            Positioned(
                                              top: 7,
                                              left: 7,
                                              child: Container(
                                                padding: EdgeInsets.all(5),
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(5),
                                                  color: Colors.white,
                                                  border: Border.all(
                                                    width: .5,
                                                    color: Color.fromARGB(255, 209, 176, 76),
                                                  )
                                                ),
                                                child: shortDate(event['date'])
                                              ),
                                            )
                                          ],
                                        ),
                                        paddingTop(3),
                                        Text(event['name'],style: TextStyle(fontFamily: 'louisewalker')),
                                        Text('${event['space']}',style: TextStyle(fontSize: 12)),
                                        paddingTop(5),
                                        Row(
                                          children: [
                                            Icon(BootstrapIcons.calendar_week,size: 20),
                                            paddingLeft(10),
                                            Text('${event['date']} à ${event['hour']}',style: TextStyle(fontSize: 12)),
                                          ],
                                        ),
                                        paddingTop(5),
                                      ],
                                    ),
                                  ),
                                ),
                              if(events_all.isEmpty)
                                Center(child: Text('Aucun évènement a venir'),)
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10,top: 5),
                        child: Text('Tout les événements',style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),),
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Container(
                          padding: EdgeInsets.all(7),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              for(var event in filteredList)
                                GestureDetector(
                                  onTap: (){
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Party(event),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    width: events_all.length>1 ? MediaQuery.sizeOf(context).width/2+20 : MediaQuery.sizeOf(context).width-15,
                                    margin: EdgeInsets.only(right: 10),
                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(width: 1,color: Color.fromARGB(255, 220, 220, 220))
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Stack(
                                          children: [
                                            Container(
                                              height: 130,
                                              width: events_all.length>1 ? MediaQuery.sizeOf(context).width/2+20 : MediaQuery.sizeOf(context).width-15,
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(9),
                                                child: Image.network(api.getbaseUpload()+event['banner'],
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(10),
                                                border: Border.all(width: 1,color: Color.fromARGB(255, 220, 220, 220))
                                              ),
                                            ),
                                            Positioned(
                                              top: 7,
                                              left: 7,
                                              child: Container(
                                                padding: EdgeInsets.all(5),
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(5),
                                                  color: Colors.white,
                                                  border: Border.all(
                                                    width: .5,
                                                    color: Color.fromARGB(255, 209, 176, 76),
                                                  )
                                                ),
                                                child: shortDate(event['date'])
                                              ),
                                            )
                                          ],
                                        ),
                                        paddingTop(3),
                                        Text(event['name'],style: TextStyle(fontFamily: 'louisewalker')),
                                        Text('${event['space']}',style: TextStyle(fontSize: 12)),
                                        paddingTop(5),
                                        Row(
                                          children: [
                                            Icon(BootstrapIcons.calendar_week,size: 20),
                                            paddingLeft(10),
                                            Text('${event['date']} à ${event['hour']}',style: TextStyle(fontSize: 12)),
                                          ],
                                        ),
                                        paddingTop(5),
                                      ],
                                    ),
                                  ),
                                ),
                              if(events_all.isEmpty)
                                Center(child: Text('Aucun évènement a venir'),)
                            ],
                          ),
                        ),
                      ),
                      paddingTop(80)
                    ],
                  ),
                )
              )
            ],
          ),
        ),
    );
  }
}