import 'package:flutter/material.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:inguewa/api/api.dart';
import 'package:inguewa/banner/slide.dart';
import 'package:inguewa/event/party.dart';
import 'package:inguewa/service/service.dart';
import 'dart:async'; // Pour utiliser Timer

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
  List<dynamic> eventsAll = [];
  List<dynamic> eventsComing = [];
  List filteredList = [];
  TextEditingController searchController = TextEditingController();
  late PageController _pageController; // Controller pour le carousel
  late Timer _timer; // Timer pour changer les pages automatiquement

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    init();
    searchController.addListener(filterItems);
    _startAutoSlide(); // Lance le défilement automatique
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer.cancel(); // Annule le timer lorsque le widget est détruit
    super.dispose();
  }

  void _startAutoSlide() {
    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      if (_pageController.hasClients) {
        int nextPage = (_pageController.page!.toInt() + 1) % banners.length;
        _pageController.animateToPage(nextPage, duration: Duration(seconds: 1), curve: Curves.easeInOut);
      }
    });
  }

  void filterItems() {
    String query = searchController.text.toLowerCase();
    setState(() {
      filteredList = eventsAll.where((item) =>
      item['name'].toString().toLowerCase().contains(query) ||
          item['description'].toString().toLowerCase().contains(query)).toList();
    });
  }

  Future<void> init() async {
    var response = await api.get('get-data');
    if (response['status'] == 'success') {
      setState(() {

        categories = response['categories'];
        banners = response['banners'];
        eventsAll = response['events'];
        eventsComing = response['events_coming'];
        load = false;
        filteredList = eventsAll;

        print(eventsAll);
        print('dddddddddddddddddddddddddddddddddddddddddddddddddd');
      });
    }
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
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
        onRefresh: init,
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildSearchBar(),
              _buildBannerCarousel(),
              _buildSectionTitle('Services'),
              _buildCategoryGrid(),
              _buildSectionTitle('Événements à venir'),
              _buildEventGrid(eventsComing),
              _buildSectionTitle('Tous les événements'),
              _buildEventGrid(filteredList),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
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
    );
  }


  Widget _buildBannerCarousel() {
    return SizedBox(
      height: 180,
      child: PageView.builder(
        controller: _pageController,
        itemCount: banners.length,
        itemBuilder: (context, index) {
          var banner = banners[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: GestureDetector(

              onTap: () {

                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => Slide(banner)));
              } ,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(api.getbaseUpload() + banner['banner'],
                    width: MediaQuery.of(context).size.width * 0.8,
                    fit: BoxFit.cover),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCategoryGrid() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 0.9,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          var icon = categories[index];
          return GestureDetector(
            onTap: () => Navigator.push(
                context, MaterialPageRoute(builder: (_) => Service(icon['id']))),
            child: Column(
              children: [
                Image.network(api.getbaseUpload() + icon['icon'],
                    width: 50, height: 50, fit: BoxFit.contain),
                SizedBox(height: 5),
                Text(icon['name'],
                    style: TextStyle(fontSize: 12),
                    textAlign: TextAlign.center),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, top: 10, bottom: 5),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(title,
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
      ),
    );
  }

  Widget _buildEventGrid(List<dynamic> events) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 0.75,
        ),
        itemCount: events.length,
        itemBuilder: (context, index) {
          var event = events[index];
          return GestureDetector(
            onTap: () {
            //  print(events);
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => Party(event)));
            },
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    api.getbaseUpload() + event['banner'],
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 5),
                Text(event['name'],
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14)),
                SizedBox(height: 3),
                Text('${event['date']} à ${event['hour']}',
                    style: TextStyle(fontSize: 12)),
              ],
            ),
          );
        },
      ),
    );
  }
}
