import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:inguewa/api/api.dart';
import 'package:inguewa/function/function.dart';
import 'package:inguewa/service/item.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profil extends StatefulWidget {
  final data;
  const Profil(this.data, {Key? key}) : super(key: key);

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
    try {
      if (response['status'] == 'success') {
        setState(() {
          services = response['services'];
          categories = response['categories'];
          filteredList = services;
          load = false;
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
      filteredList = services.where((item) =>
      item['name'].toString().toLowerCase().contains(query) ||
          item['description'].toString().toLowerCase().contains(query)
      ).toList();
    });
  }

  image(item) {
    if (item['image_one'] != null) {
      return NetworkImage(api.getbaseUpload() + item['image_one']);
    }
    if (item['image_two'] != null) {
      return NetworkImage(api.getbaseUpload() + item['image_two']);
    }
    return AssetImage('assets/images/74e6e7e382d0ff5d7773ca9a87e6f6f8817a68a.png');
  }

  Widget searchBar(TextEditingController searchController, Function filterItems) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Colors.white,
        boxShadow: [BoxShadow(blurRadius: 8, color: Colors.grey.shade300)],
      ),
      child: TextField(
        controller: searchController,
        style: TextStyle(color: Colors.black),
        onChanged: (text) => filterItems(),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 15),
          hintText: 'Recherchez un service...',
          hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          suffixIcon: Icon(BootstrapIcons.search, color: Colors.grey, size: 20),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        toolbarHeight: 60,
        title: Text(
          '${widget.data['first_name']} ${widget.data['last_name']}',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
            fontFamily: 'louisewalker',
          ),
        ),
        backgroundColor: Colors.redAccent,
        elevation: 0,
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                widget.data['business_logo'] != null
                    ? Container(
                  height: 250,
                  width: double.infinity,
                  child: Image.network(
                    api.getbaseUpload() + widget.data['business_logo'],
                    fit: BoxFit.cover,
                  ),
                )
                    : SizedBox(),
                Container(
                  height: 250,
                  width: double.infinity,
                  color: Colors.black.withOpacity(0.4),
                ),
                Positioned(
                  top: 20,
                  right: 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${widget.data['business_name']}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${widget.data['business_phone']}',
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        '${widget.data['business_email']}',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 120,
                  left: 20,
                  child: CircleAvatar(
                    radius: 60,
                    backgroundImage: NetworkImage(
                      api.getbaseUpload() + widget.data['avatar'],
                    ),
                    backgroundColor: Color.fromARGB(255, 244, 244, 244),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: searchBar(searchController, filterItems),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                'Services',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: load
                  ? Center(child: CircularProgressIndicator(color: secondaryColor()))
                  : services.isEmpty
                  ? Center(child: Text("Aucun service", style: TextStyle(fontSize: 16)))
                  : Padding(
                padding: const EdgeInsets.all(5),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      for (var item in filteredList)
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
                          child: Container(
                            margin: EdgeInsets.only(bottom: 20),
                            padding: EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.3),
                                  blurRadius: 10,
                                  offset: Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 70,
                                  height: 70,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    image: DecorationImage(
                                      image: image(item),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 15),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item['name'],
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        '${item['price']} XOF',
                                        style: TextStyle(fontSize: 14),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        '${item['description'].length <= 30 ? item['description'] : item['description'].substring(0, 30) + '...'}',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
