// ignore_for_file: prefer_const_constructors, empty_catches, prefer_const_literals_to_create_immutables, use_build_context_synchronously
import 'dart:convert';
import 'dart:io';

import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:inguewa/api/api.dart';
import 'package:inguewa/function/function.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class UpdateService extends StatefulWidget {
  final categories;
  final service;
  const UpdateService(this.categories,this.service,{super.key});

  @override
  State<UpdateService> createState() => _UpdateServiceState();
}

class _UpdateServiceState extends State<UpdateService> {


  late Api api = Api();
  var services = [];
  TextEditingController searchController = TextEditingController();
  List filteredList = [];
  List<String> categories = ['Catégorie'];
  var _selectedItem = 'Catégorie';
  var categories_ids = {};
  late TextEditingController name = TextEditingController();
  late TextEditingController price = TextEditingController();
  late TextEditingController description = TextEditingController();

  var _imageOneFile;
  var _imageTwoFile;

  init() async {
    setState(() {
      filteredList = services;
      for(var item in widget.categories){
        categories.add(item['name']);
        categories_ids[item['name']]=item['id'];
        name.text = widget.service['name'];
        price.text = widget.service['price'];
        description.text = widget.service['description'];
        _selectedItem = widget.service['category']['name'];
      }
    });
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

    return  AssetImage('assets/images/74e6e7e382d0ff5d7773ca9a87e6f6f8817a68a.png');
  }

  image_two(item){

    if(item['image_two']!=null) {
      return NetworkImage(api.getbaseUpload() + item['image_two']);
    }

    return  AssetImage('assets/images/74e6e7e382d0ff5d7773ca9a87e6f6f8817a68a.png');
  }

  void _showResultDialog(String result) {
    final snackBar = SnackBar(
      backgroundColor: secondaryColor(),
      content: Text(result),
      duration: Duration(seconds: 5),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> _pickImage(dataFile) async {

    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(5))),
      builder: (BuildContext context) {
        return Container(
          height: 200,
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              paddingTop(10),
              GestureDetector(
                onTap: (){
                  _source(ImageSource.gallery,dataFile);
                },
                child: Row(
                  children: [
                    Icon(BootstrapIcons.image,color: primaryColor()),
                    paddingLeft(10),
                    Text('Ouvrir la galerie',style: TextStyle(fontFamily: 'Roboto'))
                  ],
                ),
              ),
              paddingTop(10),
              Divider(),
              paddingTop(10),
              GestureDetector(
                onTap: (){
                  _source(ImageSource.camera,dataFile);
                },
                child: Row(
                  children: [
                    Icon(BootstrapIcons.camera,color: primaryColor()),
                    paddingLeft(10),
                    Text('Ouvrir la camera',style: TextStyle(fontFamily: 'Roboto'))
                  ],
                ),
              ),
              paddingTop(10),
            ],
          ),
        );
      },
    );

  }

  _source(source,dataFile) async {

    Navigator.pop(context);
    final pickedImage = await ImagePicker().pickImage(source: source);

    var data;

    if (pickedImage != null) {
      data = await compressImage(pickedImage.path, targetSize: 250 * 1024);
    }

    setState(() {
      if (data != null) {
        if(dataFile=='_imageOneFile')
          _imageOneFile = File(data.path);
        if(dataFile=='_imageTwoFile')
          _imageTwoFile = File(data.path);
      }
    });
  }

  void _deleted() async {
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        contentPadding: EdgeInsets.all(15),
        content: Row(
          children: [
            CircularProgressIndicator(color:primaryColor()),
            paddingLeft(20),
            Text('Veuillez patienter ...')
          ],
        ),
      ),
    );

    try {
      var response = await api.post('delete-service', {"id":widget.service['id']});
      if (response['status'] == 'success') {
        Navigator.pop(context);
        _showResultDialog(response['message']);
        Navigator.pop(context);
      } else {
        Navigator.pop(context);
        _showResultDialog(response['message']);
      }
    } catch (error) {
       Navigator.pop(context);
      _showResultDialog('Erreur: $error');
    }
  }

  void _postData() async {

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        contentPadding: EdgeInsets.all(15),
        content: Row(
          children: [
            CircularProgressIndicator(color:primaryColor()),
            paddingLeft(20),
            Text('Veuillez patienter ...')
          ],
        ),
      ),
    );

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var data = jsonDecode(prefs.getString('customerData')!);
    var id = data['id'];

    Map<String, String> formData = {
      'id': widget.service['id'],
      'category_id': categories_ids[_selectedItem],
      'name': name.text.trim(),
      'price': price.text.trim(),
      'description': description.text.trim(),
    };

    List images = [_imageOneFile, _imageTwoFile];

    var request = http.MultipartRequest(
      'POST',
      Uri.parse(api.getbaseUrl()+'/update-service')
    );

    formData.forEach((key, value) {
      request.fields[key] = value;
    });


    if(_imageOneFile!=null){
      request.files.add(await http.MultipartFile.fromPath(
        'image_one', 
        _imageOneFile?.path,
      ));
    }

    if(_imageTwoFile!=null){
      request.files.add(await http.MultipartFile.fromPath(
        'image_two', 
        _imageTwoFile?.path,
      ));
    }
    var response = await request.send();

    if (response.statusCode == 200) {
      final jsonResponse = await response.stream.bytesToString();
      var data = json.decode(jsonResponse);
      if (data['status'] == 'success') {
        Navigator.pop(context);
        toast(context,data['message']);
        Navigator.pop(context);
      }else{
        Navigator.pop(context);
        toast(context,'Erreur lors de l\'enregistrement du service');
      }
    } else {
      Navigator.pop(context);
      toast(context,'Erreur lors de l\'enregistrement du service');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white
        ),
        backgroundColor: secondaryColor(),
        title: Text(
            'Modifié le service',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w100,
              fontFamily: 'louisewalker',
            ),
          ),
        toolbarHeight: 40,
      ),
      body:
        SingleChildScrollView(
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(10),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                Padding(
                  padding: const EdgeInsets.only(left: 40,right: 40),
                  child: Container(
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: (){
                              _pickImage('_imageOneFile');
                            },
                            child: Container(
                              height: 120,
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                image: DecorationImage(
                                  image: _imageOneFile != null
                                  ? FileImage(_imageOneFile) as ImageProvider<Object>
                                  : image(widget.service),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                        paddingLeft(10),
                        Expanded(
                          child: GestureDetector(
                            onTap: (){
                              _pickImage('_imageTwoFile');
                            },
                            child: Container(
                              height: 120,
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                image: DecorationImage(
                                  image: _imageTwoFile != null
                                  ? FileImage(_imageTwoFile) as ImageProvider<Object>
                                  : image_two(widget.service),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                paddingTop(15),
                Container(
                  padding: EdgeInsets.all(5),
                  width: double.infinity,
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: DropdownButton<String>(
                          value: _selectedItem,
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedItem = newValue!;
                            });
                          },
                          items: categories.map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                      TextField(
                        controller: name,
                        textCapitalization : TextCapitalization.words,
                        decoration: InputDecoration(
                          hintText: "Libellé du service / de l'articcle"
                        ),
                      ),
                      paddingTop(5),
                      TextField(
                        controller: price,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: "Montant"
                        ),
                      ),
                      paddingTop(5),
                      TextField(
                        controller: description,
                        textCapitalization : TextCapitalization.sentences,
                        maxLines: 4,
                        decoration: InputDecoration(
                          hintText: "Description"
                        ),
                      ),
                      paddingTop(20),
                      SizedBox(
                        width: double.infinity, 
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: secondaryColor(),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          onPressed: (){
                            if(name.text.trim()=='' || price.text.trim()==''  || _selectedItem=='Catégorie'){
                              _showResultDialog('Merci de sélectionner la catégorie, le libellé et le prix');
                              return;
                            }
                            _postData();
                          },
                          child: Text('Modifier le service',style: TextStyle(color: Colors.white,fontSize: 14),textAlign: TextAlign.center)
                        ),
                      ),
                      paddingTop(10),
                      SizedBox(
                        width: double.infinity, 
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: redColor(),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          onPressed: (){
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Confirmation'),
                                  content: Text('Voulez-vous vraiment supprimer ce service?'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop(false);
                                      },
                                      child: Text('Non'),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        Navigator.pop(context);
                                        _deleted();
                                      },
                                      child: Text('Oui'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Text('Supprimer le service',style: TextStyle(color: Colors.white,fontSize: 14),textAlign: TextAlign.center)
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
                ),
        )
    );
  }
}