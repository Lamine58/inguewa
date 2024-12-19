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

    try {
      if (response['status'] == 'success') {
        setState(() {
          events_all = response['data'];
          load = false;
          filteredList = events_all;
        });
      }
    } catch (err) {
      print(err);
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
      filteredList = events_all.where((item) =>
      item['name'].toString().toLowerCase().contains(query) ||
          item['description'].toString().toLowerCase().contains(query)
      ).toList();
    });
  }

  // Custom search bar widget (same as home page)
  Widget searchBar(TextEditingController searchController, Function filterItems) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Colors.white,
        boxShadow: [BoxShadow(blurRadius: 8, color: Colors.grey.withOpacity(0.2))],
      ),
      child: TextField(
        controller: searchController,
        style: TextStyle(color: Colors.black),
        onChanged: (text) => filterItems(),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 15),
          hintText: 'Rechercher...',
          hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          suffixIcon: Icon(BootstrapIcons.search, color: primaryColor(), size: 20),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 20,
        backgroundColor:  Colors.redAccent,

      ),
      body: load
          ? Center(child: CircularProgressIndicator(color: Colors.redAccent,))
          : Column(
        children: [
          // Replacing the old search bar with the custom one
          Container(
            padding: EdgeInsets.all(10),
            child: searchBar(searchController, filterItems),
          ),
          paddingTop(5),
          Expanded(
            child: events_all.isNotEmpty
                ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 5,
                    childAspectRatio: (1 / 1.17)),
                itemCount: filteredList.length,
                itemBuilder: (context, index) {
                  String eventName = filteredList[index]['name'] ?? '';
                  String displayName = eventName.length > 15
                      ? '${eventName.substring(0, 15)}...'
                      : eventName;

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              Party(filteredList[index]),
                        ),
                      );
                    },
                    child: Container(
                      width: filteredList.length > 1
                          ? MediaQuery.sizeOf(context).width / 2 + 20
                          : MediaQuery.sizeOf(context).width - 15,
                      margin: EdgeInsets.only(right: 10),
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            width: 1, color: Color.fromARGB(255, 220, 220, 220)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            children: [
                              Container(
                                height: 130,
                                width: filteredList.length > 1
                                    ? MediaQuery.sizeOf(context).width / 2 + 20
                                    : MediaQuery.sizeOf(context).width - 15,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(9),
                                  child: Image.network(
                                    api.getbaseUpload() + filteredList[index]['banner'],
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      width: 1, color: Color.fromARGB(255, 220, 220, 220)),
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
                                    ),
                                  ),
                                  child: shortDate(filteredList[index]['date']),
                                ),
                              )
                            ],
                          ),
                          paddingTop(3),
                          Text(displayName, style: TextStyle(fontFamily: 'louisewalker')),
                          Text('${filteredList[index]['space']}', style: TextStyle(fontSize: 12)),
                          paddingTop(5),
                          Row(
                            children: [
                              Icon(BootstrapIcons.calendar_week, size: 20),
                              paddingLeft(10),
                              Text(
                                '${filteredList[index]['date']} à ${filteredList[index]['hour']}',
                                style: TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                          paddingTop(5),
                        ],
                      ),
                    ),
                  );
                },
              ),
            )
                : Center(child: Text('Aucun évènement')),
          ),
          paddingTop(50),
        ],
      ),
    );
  }
}
