import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:inguewa/api/api.dart';
import 'package:inguewa/customer/profil.dart';
import 'package:inguewa/function/function.dart';

class Shop extends StatefulWidget {
  const Shop({Key? key}) : super(key: key);

  @override
  State<Shop> createState() => _ShopState();
}

class _ShopState extends State<Shop> {
  var load = true;
  late Api api = Api();
  List<dynamic> customers = [];
  TextEditingController searchController = TextEditingController();
  List filteredList = [];

  init() async {
    var response = await api.get('customers');
    try {
      if (response['status'] == 'success') {
        setState(() {
          customers = response['data'];
          load = false;
          filteredList = customers;
        });
      }
    } catch (err) {
      print(err);
    }
  }

  image(item) {
    if (item['avatar'] != null) {
      return Image.network(api.getbaseUpload() + item['business_logo'], fit: BoxFit.cover);
    }
    return Image.asset('assets/images/74e6e7e382d0ff5d7773ca9a87e6f6f8817a68a.png', fit: BoxFit.cover);
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
      filteredList = customers.where((item) =>
      item['business_name'].toString().toLowerCase().contains(query) ||
          item['business_phone'].toString().toLowerCase().contains(query)
      ).toList();
    });
  }

  // Custom app bar widget (header)
  Widget customAppBar(String title) {
    return AppBar(
      iconTheme: IconThemeData(color: Colors.white),
      toolbarHeight: 70,
      backgroundColor: primaryColor(),  // Same color as home page
      title: Text(
        title,
        style: TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
          fontFamily: 'louisewalker',
        ),
      ),
    );
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

  // Custom provider card widget
  Widget providerCard(BuildContext context, item) {
    String eventName = item['business_name'];
    String displayName = eventName.length > 15 ? eventName.substring(0, 15) : eventName;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Profil(item),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Container(
                height: 150,
                width: double.infinity,
                child: image(item),
              ),
            ),

            Text(
              displayName,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 5),
            Text(
              item['phone'],
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
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
        backgroundColor: Colors.redAccent,
      ),
      body: load
          ? Center(child: CircularProgressIndicator(color: primaryColor()))  // Same color as home page
          : Column(
        children: [
          SizedBox(height: 20),
          // Re-designed search bar with the same appearance as home page
          searchBar(searchController, filterItems),
          SizedBox(height: 20),
          Expanded(
            child: customers.isNotEmpty
                ? Padding(
              padding: const EdgeInsets.all(15.0),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  childAspectRatio: 0.75,
                ),
                itemCount: filteredList.length,
                itemBuilder: (context, index) {
                  return providerCard(context, filteredList[index]);
                },
              ),
            )
                : Center(child: Text('Aucun membre pour l\'instant', style: TextStyle(fontSize: 16, color: Colors.black))),
          ),
        ],
      ),
    );
  }
}
