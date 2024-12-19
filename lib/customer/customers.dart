// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:inguewa/api/api.dart';
import 'package:inguewa/customer/profil.dart';
import 'package:inguewa/function/function.dart';
import 'package:inguewa/service/item.dart';

class Customers extends StatefulWidget {

  const Customers({Key? key}) : super(key: key);
  @override
  State<Customers> createState() => _CustomersState();
}

class _CustomersState extends State<Customers> {

  var load = true;
  late Api api = Api();
  List<dynamic> customers = [];
  TextEditingController searchController = TextEditingController();
  List filteredList = [];


  init() async {
    
    var response = await api.get('customers');

    try{
      if (response['status'] == 'success') {
        setState(() {
          customers = response['data'];
          load = false;
          filteredList = customers;
        });
      }
    }catch(err){
      print(err);
    }
    
  }

  image (item) {

    if(item['avatar']!=null) {
      return Image.network(api.getbaseUpload() + item['avatar'],fit: BoxFit.cover,);
    }

    return  Image.asset('assets/images/avatar.jpg',fit: BoxFit.cover,);
    
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
      filteredList = customers.where((item) =>
          item['first_name'].toString().toLowerCase().contains(query) ||
          item['last_name'].toString().toLowerCase().contains(query)
      ).toList();
    });
  }
  
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white
        ),
        toolbarHeight: 40,
        backgroundColor:  Colors.redAccent,
        title: 
          Text(
            'Membres',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w100,
              fontFamily: 'louisewalker',
            ),
          )
        ),
        body: load ? Center(child: CircularProgressIndicator(color:  Colors.redAccent,)) : Column(
          children: [
            Container(
              padding: EdgeInsets.all(10),

              child: SizedBox(
                height: 55,
                 child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Rechercher...',
                  prefixIcon: Icon(BootstrapIcons.search),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color:   Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                ),
              ),
              ),
            ),
            paddingTop(5),
            Expanded(
              child: customers.isNotEmpty ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 5,
                  ),
                  itemCount: filteredList.length,
                  itemBuilder: (context, index) {

                    String eventName = filteredList[index]['first_name']+' '+filteredList[index]['last_name'];
                    String displayName = eventName.length > 15
                        ? eventName.substring(0, 15)
                        : eventName;

                    return GestureDetector(
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Profil(filteredList[index]),
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
                                )
                              ],
                            ),
                            paddingTop(3),
                            Text(displayName,style: TextStyle(fontFamily: 'louisewalker')),
                            Text(filteredList[index]['phone'],style: TextStyle(fontSize: 12)),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ) : Center(child: Text('Aucun membre pour l\'instant'),)
            )
          ],
        ),
      );
  }
}