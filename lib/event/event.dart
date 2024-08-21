// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:inguewa/api/api.dart';
import 'package:inguewa/event/party.dart';
import 'package:inguewa/function/function.dart';

class Event extends StatefulWidget {
  const Event({Key? key}) : super(key: key);

  @override
  State<Event> createState() => _EventState();
}

class _EventState extends State<Event> {

  var load = true;
  late Api api = Api();
  List<dynamic> events_all = [];
  TextEditingController searchController = TextEditingController();
  List filteredList = [];


  init() async {
    
    var response = await api.get('party');

    try{
      if (response['status'] == 'success') {
        setState(() {
          events_all = response['data'];
          load = false;
          filteredList = events_all;
        });
      }
    }catch(err){
      print(err);
    }
    
  }

  @override
  void initState() {
    // TODO: implement initState
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

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 40,
        backgroundColor: secondaryColor(),
        title: 
          Text(
            'Evènements',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w100,
              fontFamily: 'louisewalker',
            ),
          ),
        ),
        body:  load ? Center(child: CircularProgressIndicator(color:secondaryColor())) : Column(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(asset('arriere-plan-vectoriel-motif-pointille-dans-style-aborigene_619130-1631.png')),
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
            paddingTop(5),
            Expanded(
              child: events_all.isNotEmpty ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 5,
                    childAspectRatio: (1 / 1.17)
                  ),
                  itemCount: filteredList.length,
                  itemBuilder: (context, index) {

                    String eventName = filteredList[index]['name'] ?? '';
                    String displayName = eventName.length > 15
                        ? '${eventName.substring(0, 15)}...'
                        : eventName;

                    return GestureDetector(
                        onTap: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Party(filteredList[index]),
                            ),
                          );
                        },
                        child: Container(
                          width: filteredList.length>1 ? MediaQuery.sizeOf(context).width/2+20 : MediaQuery.sizeOf(context).width-15,
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
                                    width: filteredList.length>1 ? MediaQuery.sizeOf(context).width/2+20 : MediaQuery.sizeOf(context).width-15,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(9),
                                      child: Image.network(api.getbaseUpload()+filteredList[index]['banner'],
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
                                      child: shortDate(filteredList[index]['date'])
                                    ),
                                  )
                                ],
                              ),
                              paddingTop(3),
                              Text(displayName,style: TextStyle(fontFamily: 'louisewalker')),
                              Text('${filteredList[index]['space']}',style: TextStyle(fontSize: 12)),
                              paddingTop(5),
                              Row(
                                children: [
                                  Icon(BootstrapIcons.calendar_week,size: 20),
                                  paddingLeft(10),
                                  Text('${filteredList[index]['date']} à ${filteredList[index]['hour']}',style: TextStyle(fontSize: 12)),
                                ],
                              ),
                              paddingTop(5),
                            ],
                          ),
                        ),
                      );
                  },
                ),
                  
              ) : Center(child: Text('Aucun évènement'),)
            ),
            paddingTop(50)
          ],
        ),
      );
  }
}