// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:inguewa/api/api.dart';
import 'package:inguewa/function/function.dart';
import 'package:inguewa/service/item.dart';

class Service extends StatefulWidget {
  final id;
  const Service(this.id,{Key? key}) : super(key: key);

  @override
  State<Service> createState() => _ServiceState();
}

class _ServiceState extends State<Service> {

  var load = true;
  late Api api = Api();
  List<dynamic> services = [];
  TextEditingController searchController = TextEditingController();
  List filteredList = [];


  init() async {
    
    var response = await api.get('shop?id=${widget.id}');

    try{
      if (response['status'] == 'success') {
        setState(() {
          services = response['data'];
          load = false;
          filteredList = services;
        });
      }
    }catch(err){
      print(err);
    }
    
  }

  image (item) {

    if(item['image_one']!=null) {
      return Image.network(api.getbaseUpload() + item['image_one'],fit: BoxFit.cover,);
    }

    if(item['image_two']!=null) {
      return Image.network(api.getbaseUpload() + item['image_two'],fit: BoxFit.cover,);
    }

    return  Image.asset('assets/images/74e6e7e382d0ff5d7773ca9a87e6f6f8817a68a.png',fit: BoxFit.cover,);
    
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
      filteredList = services.where((item) =>
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
            'Services',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w100,
              fontFamily: 'louisewalker',
            ),
          )
        ),
        body: load ? Center(child: CircularProgressIndicator(color: secondaryColor())) : Column(
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
                      fillColor: const Color.fromARGB(255, 0, 0, 0).withOpacity(.8),
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
              child: services.isNotEmpty ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 5,
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
                            builder: (context) => Item(filteredList[index]),
                          ),
                        );
                      },
                      child: Container(
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
                                  width: MediaQuery.sizeOf(context).width/2+20,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(9),
                                    child: image(filteredList[index]),
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(width: 1,color: Color.fromARGB(255, 220, 220, 220))
                                  ),
                                ),
                                Positioned(
                                  top: 7,
                                  right: 7,
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
                                    child: Icon(BootstrapIcons.heart,color: primaryColor(),size: 15,),
                                  ),
                                )
                              ],
                            ),
                            paddingTop(3),
                            Text(displayName,style: TextStyle(fontFamily: 'louisewalker')),
                            Text(filteredList[index]['price'],style: TextStyle(fontSize: 12)),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ) :
              Center(child: Text('Aucun service'),)
            )
          ],
        ),
      );
  }
}