import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:inguewa/api/api.dart';
import 'package:inguewa/service/item.dart';

class Service extends StatefulWidget {
  final id;
  const Service(this.id, {Key? key}) : super(key: key);

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
    try {
      if (response['status'] == 'success') {
        setState(() {
          services = response['data'];
          load = false;
          filteredList = services;
        });
      }
    } catch (err) {
      print(err);
    }
  }

  image(item) {
    if (item['image_one'] != null) {
      return Image.network(api.getbaseUpload() + item['image_one'], fit: BoxFit.cover);
    }

    if (item['image_two'] != null) {
      return Image.network(api.getbaseUpload() + item['image_two'], fit: BoxFit.cover);
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
      filteredList = services.where((item) =>
      item['name'].toString().toLowerCase().contains(query) ||
          item['description'].toString().toLowerCase().contains(query)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: Colors.redAccent,
        title: Text(
          'Nos Services',
          style: TextStyle(
            color: Colors.white,
            fontSize: 26,
            fontWeight: FontWeight.bold,
            fontFamily: 'louisewalker',
          ),
        ),
      ),
      body: load
          ? Center(child: CircularProgressIndicator(color: Colors.redAccent))
          : SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 10,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: searchController,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    hintText: 'Rechercher un service...',
                    hintStyle: TextStyle(color: Colors.grey),
                    prefixIcon: Icon(BootstrapIcons.search, color: Colors.grey),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            services.isNotEmpty
                ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  childAspectRatio: 0.75,
                ),
                itemCount: filteredList.length,
                itemBuilder: (context, index) {
                  String eventName = filteredList[index]['name'] ?? '';
                  String displayName = eventName.length > 15 ? '${eventName.substring(0, 15)}...' : eventName;

                  return GestureDetector(
                    onTap: () {
                      // Navigate to the Item page when the card is tapped
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Item(filteredList[index]),
                        ),
                      );
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      elevation: 4, // Lighter shadow to make it more subtle
                      shadowColor: Colors.black26,
                      color: Colors.white, // Ensuring the background is white
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Item(filteredList[index]),
                            ),
                          );
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(18),
                              child: Container(
                                height: 150,
                                width: double.infinity,
                                child: image(filteredList[index]),
                              ),
                            ),
                            SizedBox(height: 8),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                displayName,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  fontFamily: 'louisewalker',
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                filteredList[index]['price'],
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.green,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            )
                : Center(child: Text('Aucun service disponible', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
          ],
        ),
      ),
    );
  }
}
