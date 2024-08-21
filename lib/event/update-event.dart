// ignore_for_file: prefer_const_constructors, empty_catches, prefer_const_literals_to_create_immutables, use_build_context_synchronously
import 'dart:convert';
import 'dart:io';

import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:inguewa/api/api.dart';
import 'package:inguewa/function/function.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class UpdateEvent extends StatefulWidget {
  final event;
  const UpdateEvent(this.event,{super.key});

  @override
  State<UpdateEvent> createState() => _UpdateEventState();
}

class _UpdateEventState extends State<UpdateEvent> {


  late Api api = Api();
  var events = [];
  TextEditingController searchController = TextEditingController();
  List filteredList = [];
  late TextEditingController name = TextEditingController();
  late TextEditingController space = TextEditingController();
  late TextEditingController description = TextEditingController();
  late TextEditingController date = TextEditingController();
  late TextEditingController hour = TextEditingController();

  var dateFormatter = MaskTextInputFormatter(
    mask: '##/##/####', 
    filter: { "#": RegExp(r'[0-9]') },
    type: MaskAutoCompletionType.lazy
  );


  var hourFormatter = MaskTextInputFormatter(
    mask: '##:##', 
    filter: { "#": RegExp(r'[0-9]') },
    type: MaskAutoCompletionType.lazy
  );


  var _imageFile;

  init() async {
    setState(() {
      filteredList = events;
        name.text = widget.event['name'];
        space.text = widget.event['space'];
        description.text = widget.event['description'];
        date.text = widget.event['date'];
        hour.text = widget.event['hour'];
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
      filteredList = events.where((item) =>
          item['name'].toString().toLowerCase().contains(query) ||
          item['description'].toString().toLowerCase().contains(query)
      ).toList();
    });
  }

  image(item){

    if(item['banner']!=null) {
      return NetworkImage(api.getbaseUpload() + item['banner']);
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

  Future<void> _pickImage() async {

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
                  _source(ImageSource.gallery);
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
                  _source(ImageSource.camera);
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

  _source(source) async {

    Navigator.pop(context);
    final pickedImage = await ImagePicker().pickImage(source: source);

    var data;

    if (pickedImage != null) {
      data = await compressImage(pickedImage.path, targetSize: 250 * 1024);
    }

    setState(() {
      if (data != null) {
        _imageFile = File(data.path);
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
      var response = await api.post('delete-event', {"id":widget.event['id']});
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
      'id': widget.event['id'],
      'customer_id': id,
      'name': name.text.trim(),
      'description': description.text.trim(),
      'date': date.text.trim(),
      'hour': hour.text.trim(),
      'space': space.text.trim(),
    };

    var request = http.MultipartRequest(
      'POST',
      Uri.parse(api.getbaseUrl()+'/update-event')
    );

    formData.forEach((key, value) {
      request.fields[key] = value;
    });

    if(_imageFile!=null){
      request.files.add(await http.MultipartFile.fromPath(
        'image', 
        _imageFile?.path,
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
        toast(context,'Erreur lors de l\'enregistrement de l\'évènement');
      }
    } else {
      Navigator.pop(context);
      toast(context,'Erreur lors de l\'enregistrement de l\'évènement');
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
            'Modifié l\'évènement',
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
                  padding: const EdgeInsets.all(10),
                  child: Container(
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: (){
                              _pickImage();
                            },
                            child: _imageFile != null
                              ? Container(
                              height: 150,
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                image: DecorationImage(
                                  image:  FileImage(_imageFile) as ImageProvider<Object>,
                                  fit: BoxFit.cover
                                ),
                              ),
                              ) : widget.event['banner']!=null
                               ? Container(
                                height: 150,
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  image: DecorationImage(
                                    image:  image(widget.event),
                                    fit: BoxFit.cover
                                  ),
                                )
                              ) : Container(
                              color: Colors.grey[300],
                              height: 150,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Choisissez votre bannière',style: TextStyle(color: const Color.fromARGB(255, 150, 150, 150))),
                                ],
                              ),
                            ),
                          ),
                        ),
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
                      TextField(
                        controller: name,
                        textCapitalization : TextCapitalization.words,
                        decoration: InputDecoration(
                          hintText: "Titre de l'évènement"
                        ),
                      ),
                      paddingTop(5),
                      TextField(
                        controller: space,
                        textCapitalization : TextCapitalization.words,
                        decoration: InputDecoration(
                          hintText: "Lieu"
                        ),
                      ),
                      paddingTop(5),
                      TextField(
                        keyboardType: TextInputType.number,
                        inputFormatters: [dateFormatter],
                        controller: date,
                        textCapitalization : TextCapitalization.words,
                        decoration: InputDecoration(
                          hintText: "Date"
                        ),
                      ),
                      paddingTop(5),
                      TextField(
                        keyboardType: TextInputType.number,
                        inputFormatters: [hourFormatter],
                        controller: hour,
                        textCapitalization : TextCapitalization.words,
                        decoration: InputDecoration(
                          hintText: "Heure"
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
                            if(name.text.trim()=='' || date.text.trim()=='' || hour.text.trim()==''  || space.text.trim()==''){
                              toast(context,'Merci de saisir le titre, le lieu, la date et l\'heure de l\'évènement');
                              return;
                            }
                            _postData();
                          },
                          child: Text('Modifier l\'évènement',style: TextStyle(color: Colors.white,fontSize: 14),textAlign: TextAlign.center)
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
                                  content: Text('Voulez-vous vraiment supprimer ce évènement?'),
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
                          child: Text('Supprimer l\'évènement',style: TextStyle(color: Colors.white,fontSize: 14),textAlign: TextAlign.center)
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