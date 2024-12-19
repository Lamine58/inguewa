// ignore_for_file: prefer_const_constructors, sort_child_properties_last, prefer_const_literals_to_create_immutables, unnecessary_new, use_build_context_synchronously
import 'dart:convert';
import 'dart:io';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:inguewa/api/api.dart';
import 'package:inguewa/function/function.dart';
import 'package:inguewa/tabs/tabs.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class Customer extends StatefulWidget {
  
  const Customer({super.key});
  @override
  State<Customer> createState() => _CustomerState();
}

class _CustomerState extends State<Customer> {

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  var civilityController;
  final TextEditingController birthdayController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();


  final TextEditingController businessNameController = TextEditingController();
  final TextEditingController businessPhoneController = TextEditingController();
  final TextEditingController businessEmailController = TextEditingController();
  late String id = '';
  late String type = 'Personnel';
  final _formKey = GlobalKey<FormState>();
  final _formCompanyKey = GlobalKey<FormState>();
  late bool displayPassword = false;
  late bool spinner = false;
  late Api api = Api();
  late PageController pageController = PageController();

  
  var _avatarFile;
  var _avatar_url;

  var _logoFile;
  var _logo_url;

  @override
  void initState() {
    super.initState();
    init();
  }

  var dateFormatter = new MaskTextInputFormatter(
    mask: '##/##/####', 
    filter: { "#": RegExp(r'[0-9]') },
    type: MaskAutoCompletionType.lazy
  );

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  init() async {
    
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var data = jsonDecode(prefs.getString('customerData')!);
 
    setState(() {
      phoneController.text = data['phone'];
      id = data['id'];
      _avatar_url = data['avatar'];
      emailController.text = data['email'] ?? '';
      firstNameController.text = data['first_name'] ?? '';
      lastNameController.text = data['last_name'] ?? '';
      addressController.text = data['location'] ?? '';
      civilityController = data['civility'];
      birthdayController.text = data['birthday'] ?? '';
      _logo_url = data['business_logo'];
      businessNameController.text = data['business_name'] ?? '';
      businessPhoneController.text = data['business_phone'] ?? '';
      businessEmailController.text = data['business_email'] ?? '';
    });
  }

  Future<void> _pickImage() async {

    return showModalBottomSheet(
      shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(5))),
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          height: 150,
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              paddingTop(5),
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
              paddingTop(5),
              Divider(),
              paddingTop(5),
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
              paddingTop(5),
            ],
          ),
        );
      },
    );

  }

  Future<void> _pickLogo() async {

    return showModalBottomSheet(
      shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(5))),
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          height: 150,
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              paddingTop(5),
              GestureDetector(
                onTap: (){
                  _sourceLogo(ImageSource.gallery);
                },
                child: Row(
                  children: [
                    Icon(BootstrapIcons.image,color: primaryColor()),
                    paddingLeft(10),
                    Text('Ouvrir la galerie',style: TextStyle(fontFamily: 'Roboto'))
                  ],
                ),
              ),
              paddingTop(5),
              Divider(),
              paddingTop(5),
              GestureDetector(
                onTap: (){
                  _sourceLogo(ImageSource.camera);
                },
                child: Row(
                  children: [
                    Icon(BootstrapIcons.camera,color: primaryColor()),
                    paddingLeft(10),
                    Text('Ouvrir la camera',style: TextStyle(fontFamily: 'Roboto'))
                  ],
                ),
              ),
              paddingTop(5),
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
        _avatarFile = File(data.path);
      }
    });
  }

  _sourceLogo(source) async {

    Navigator.pop(context);
    final pickedImage = await ImagePicker().pickImage(source: source);

    var data;

    if (pickedImage != null) {
      data = await compressImage(pickedImage.path, targetSize: 250 * 1024);
    }

    setState(() {
      if (data != null) {
        _logoFile = File(data.path);
      }
    });
  }
  
  void _saveData() async {
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        contentPadding: EdgeInsets.all(15),
        content: Row(
          children: [
            CircularProgressIndicator(),
            paddingLeft(20),
            Text('Veuillez patientez ...')
          ],
        ),
      ),
    );
      
    var photo = _avatarFile;

    try {

      var response;

      if(photo!=null){

        response = await api.upload('customer-data',photo, {
          "id": id,
          "email": emailController.text,
          "first_name": firstNameController.text,
          "last_name": lastNameController.text,
          "location": addressController.text,
          "civility": civilityController,
          "birthday": birthdayController.text,
          "password": passwordController.text,
        });

      }else{
        
        response = await api.post('customer-data', {
          "id": id,
          "email": emailController.text,
          "first_name": firstNameController.text,
          "last_name": lastNameController.text,
          "location": addressController.text,
          "civility": civilityController,
          "birthday": birthdayController.text,
          "password": passwordController.text,
        });
      }
      

      if (response['status'] == 'success') {

        Navigator.pop(context);
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('customerData', jsonEncode(response['customer']));
        final snackBar = SnackBar(
          backgroundColor: secondaryColor(),
          content: Text(response['message']),
          duration: Duration(seconds: 5),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Tabs(context,0)),(route)=>false);

      } else {
        Navigator.pop(context);
        _showResultDialog(response['message']);
      }
    } catch (error) {
       Navigator.pop(context);
      _showResultDialog('Erreur: $error');
    }

  }

  void _saveDataBusiness() async {
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        contentPadding: EdgeInsets.all(15),
        content: Row(
          children: [
            CircularProgressIndicator(),
            paddingLeft(20),
            Text('Veuillez patientez ...')
          ],
        ),
      ),
    );
      
    var photo = _logoFile;

    try {

      var response;

      if(photo!=null){

        response = await api.upload('customer-business',photo, {
          "id": id,
          "business_name": businessNameController.text,
          "business_phone": businessPhoneController.text,
          "business_email": businessEmailController.text,
        });

      }else{
        
        response = await api.post('customer-business', {
          "id": id,
          "business_name": businessNameController.text,
          "business_phone": businessPhoneController.text,
          "business_email": businessEmailController.text,
        });
      }

      if (response['status'] == 'success') {

        Navigator.pop(context);
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('customerData', jsonEncode(response['customer']));
        final snackBar = SnackBar(
          backgroundColor: secondaryColor(),
          content: Text(response['message']),
          duration: Duration(seconds: 5),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Tabs(context,0)),(route)=>false);

      } else {
        Navigator.pop(context);
        _showResultDialog(response['message']);
      }
    } catch (error) {
       Navigator.pop(context);
      _showResultDialog('Erreur: $error');
    }

  }

  void _showResultDialog(String result) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Réponse',style: TextStyle(fontSize: 20),),
        content: Text(result,style: TextStyle(fontWeight: FontWeight.w300)),
      ),
    );
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
        title: Text(
          'Profil',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w100,
            fontFamily: 'louisewalker',
          ),
        ),
        backgroundColor:Colors.redAccent,
        elevation: 0,
      ),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      type = 'Personnel';
                    });
                    pageController.previousPage(duration: Duration(milliseconds: 300), curve: Curves.ease);
                  },
                  child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 241, 241, 241),
                      border: Border(
                        bottom: BorderSide(
                          width: 1.5,
                          color: type=='Personnel' ? Colors.redAccent : Colors.transparent
                        )
                      )
                    ),
                    child: Text(textAlign: TextAlign.center,'Personnel', style: TextStyle(color: Colors.redAccent),),
                  ),
                ),
              ),
              VerticalDivider(width: 1,),
              Expanded(
                child: GestureDetector(
                  onTap: (){
                    setState(() {
                      type = 'Professionnel';
                    });
                    pageController.nextPage(duration: Duration(milliseconds: 300), curve: Curves.ease);
                  },
                  child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 241, 241, 241),
                      border: Border(
                        bottom: BorderSide(
                          width: 1.5,
                          color: type=='Professionnel' ? Colors.redAccent : Colors.transparent
                        )
                      )
                    ),
                    child: Text(textAlign: TextAlign.center,'Professionnel', style: TextStyle(color: Colors.redAccent),),
                  ),
                ),
              )
            ],
          ),
          Expanded(
            child: PageView(
              controller: pageController,
              children: [
                SizedBox(
                  child: SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsets.only(left: 20,right: 20,bottom: 20),
                      child: Column(
                        children: [
                          Form(
                            key: _formKey,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  GestureDetector(
                                    onTap: (){
                                      _pickImage();
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(20),
                                      child: Center(
                                        child:  Stack(
                                          children: [
                                            _avatarFile != null
                                            ? CircleAvatar(
                                                backgroundImage:  FileImage(_avatarFile), 
                                                backgroundColor: Color.fromARGB(255, 244, 244, 244),
                                                radius: 60,
                                              )
                                            : (_avatar_url!= null && _avatar_url!='') ?
                                            CircleAvatar(
                                                backgroundImage:  NetworkImage(api.getbaseUpload()+_avatar_url), 
                                                backgroundColor: Color.fromARGB(255, 244, 244, 244),
                                                radius: 60,
                                              )
                                            : CircleAvatar(
                                              backgroundImage: const AssetImage('assets/images/avatar.jpg'), 
                                              backgroundColor: Color.fromARGB(255, 244, 244, 244),
                                              radius: 60,
                                            ),
                                            Positioned(
                                              bottom: 5,
                                              right: 0,
                                              child: Container(
                                                padding: EdgeInsets.only(top:7,right: 7,left:7,bottom: 7),
                                                decoration: BoxDecoration(
                                                  color: primaryColor(),
                                                  borderRadius: BorderRadius.circular(50)
                                                ),
                                                child: Icon(BootstrapIcons.camera_fill,color: Colors.white)
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(15),
                                    height: 55,
                                    width: MediaQuery.sizeOf(context).width,
                                    decoration: BoxDecoration(
                                      color: Color.fromARGB(255, 204, 204, 204).withOpacity(0.3),
                                      borderRadius: BorderRadius.circular(5)
                                    ),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton<String>(
                                        style: TextStyle(fontFamily: 'Toboggan',color:Colors.black,fontSize: 15,),
                                        iconSize: 23,
                                        value: civilityController,
                                        onChanged: (String? data) {
                                          setState(() {
                                            civilityController = data!;
                                          });
                                        },
                                        items: <String> ['M.','Mme','Mlle']
                                          .map<DropdownMenuItem<String>>((String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                                  paddingTop(15),
                                  TextFormField(
                                    textInputAction: TextInputAction.next,
                                    textCapitalization: TextCapitalization.words,
                                    controller: firstNameController,
                                    style: TextStyle(color: Colors.black,fontWeight: FontWeight.w300),
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.only(left:15,top: 15,bottom: 20,right: 15),
                                      labelText: 'Nom',
                                      labelStyle: TextStyle(color: Color.fromARGB(255, 120, 120, 120),fontWeight: FontWeight.w300),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      filled: true,
                                      fillColor: Color.fromARGB(255, 204, 204, 204).withOpacity(0.3),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5),
                                        borderSide: BorderSide(
                                          color: Color.fromARGB(134, 255, 255, 255),
                                        )
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5),
                                        borderSide: BorderSide(
                                          color: Color.fromARGB(134, 255, 255, 255),
                                        )
                                      ),
                                    ),
                                    keyboardType: TextInputType.emailAddress,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Veuillez saisir votre nom';
                                      }
                                      return null;
                                    },
                                  ),
                                  paddingTop(15),
                                  TextFormField(
                                    textInputAction: TextInputAction.next,
                                    textCapitalization: TextCapitalization.words,
                                    controller: lastNameController,
                                    style: TextStyle(color: Colors.black,fontWeight: FontWeight.w300),
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.only(left:15,top: 15,bottom: 20,right: 15),
                                      labelText: 'Prénoms',
                                      labelStyle: TextStyle(color: Color.fromARGB(255, 120, 120, 120),fontWeight: FontWeight.w300),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      filled: true,
                                      fillColor: Color.fromARGB(255, 204, 204, 204).withOpacity(0.3),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5),
                                        borderSide: BorderSide(
                                          color: Color.fromARGB(134, 255, 255, 255),
                                        )
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5),
                                        borderSide: BorderSide(
                                          color: Color.fromARGB(134, 255, 255, 255),
                                        )
                                      ),
                                    ),
                                    keyboardType: TextInputType.emailAddress,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Veuillez saisir votre prénom';
                                      }
                                      return null;
                                    },
                                  ),
                                  paddingTop(15),
                                  TextFormField(
                                    inputFormatters: [dateFormatter],
                                    textInputAction: TextInputAction.next,
                                    controller: birthdayController,
                                    style: TextStyle(color: Colors.black,fontWeight: FontWeight.w300),
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.only(left:15,top: 15,bottom: 20,right: 15),
                                      labelText: 'Date de naissance',
                                      labelStyle: TextStyle(color: Color.fromARGB(255, 120, 120, 120),fontWeight: FontWeight.w300),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      filled: true,
                                      fillColor: Color.fromARGB(255, 204, 204, 204).withOpacity(0.3),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5),
                                        borderSide: BorderSide(
                                          color: Color.fromARGB(134, 255, 255, 255),
                                        )
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5),
                                        borderSide: BorderSide(
                                          color: Color.fromARGB(134, 255, 255, 255),
                                        )
                                      ),
                                    ),
                                    keyboardType: TextInputType.emailAddress,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Veuillez saisir votre date de naissance';
                                      }
                                      return null;
                                    },
                                  ),
                                  paddingTop(15),
                                  TextFormField(
                                    textInputAction: TextInputAction.next,
                                    readOnly: true,
                                    controller: phoneController,
                                    style: TextStyle(color: Colors.black,fontWeight: FontWeight.w300),
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.only(left:15,top: 15,bottom: 20,right: 15),
                                      labelText: 'Téléphone',
                                      labelStyle: TextStyle(color: Color.fromARGB(255, 120, 120, 120),fontWeight: FontWeight.w300),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      filled: true,
                                      fillColor: Color.fromARGB(255, 204, 204, 204).withOpacity(0.3),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5),
                                        borderSide: BorderSide(
                                          color: Color.fromARGB(134, 255, 255, 255),
                                        )
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5),
                                        borderSide: BorderSide(
                                          color: Color.fromARGB(134, 255, 255, 255),
                                        )
                                      ),
                                    ),
                                    keyboardType: TextInputType.name,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Veuillez saisir un numéro de téléphone';
                                      }
                                      return null;
                                    },
                                  ),
                                  paddingTop(15),
                                  TextFormField(
                                    textInputAction: TextInputAction.next,
                                    controller: emailController,
                                    style: TextStyle(color: Colors.black,fontWeight: FontWeight.w300),
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.only(left:15,top: 15,bottom: 20,right: 15),
                                      labelText: 'E-mail',
                                      labelStyle: TextStyle(color: Color.fromARGB(255, 120, 120, 120),fontWeight: FontWeight.w300),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      filled: true,
                                      fillColor: Color.fromARGB(255, 204, 204, 204).withOpacity(0.3),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5),
                                        borderSide: BorderSide(
                                          color: Color.fromARGB(134, 255, 255, 255),
                                        )
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5),
                                        borderSide: BorderSide(
                                          color: Color.fromARGB(134, 255, 255, 255),
                                        )
                                      ),
                                    ),
                                    keyboardType: TextInputType.emailAddress,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Veuillez saisir une adresse email';
                                      }
                                      return null;
                                    },
                                  ),
                                  paddingTop(15),
                                  TextFormField(
                                    textInputAction: TextInputAction.next,
                                    textCapitalization: TextCapitalization.words,
                                    controller: addressController,
                                    style: TextStyle(color: Colors.black,fontWeight: FontWeight.w300),
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.only(left:15,top: 15,bottom: 20,right: 15),
                                      labelText: 'Adresse',
                                      labelStyle: TextStyle(color: Color.fromARGB(255, 120, 120, 120),fontWeight: FontWeight.w300),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      filled: true,
                                      fillColor: Color.fromARGB(255, 204, 204, 204).withOpacity(0.3),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5),
                                        borderSide: BorderSide(
                                          color: Color.fromARGB(134, 255, 255, 255),
                                        )
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5),
                                        borderSide: BorderSide(
                                          color: Color.fromARGB(134, 255, 255, 255),
                                        )
                                      ),
                                    ),
                                    keyboardType: TextInputType.streetAddress,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Veuillez saisir votre adresse';
                                      }
                                      return null;
                                    },
                                  ),
                                  paddingTop(15),
                                  TextFormField(
                                    textInputAction: TextInputAction.next,
                                    textCapitalization: TextCapitalization.words,
                                    controller: passwordController,
                                    style: TextStyle(color: Colors.black,fontWeight: FontWeight.w300),
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.only(left:15,top: 15,bottom: 20,right: 15),
                                      labelText: 'Nouveau mot de passe',
                                      labelStyle: TextStyle(color: Color.fromARGB(255, 120, 120, 120),fontWeight: FontWeight.w300),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      filled: true,
                                      fillColor: Color.fromARGB(255, 204, 204, 204).withOpacity(0.3),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5),
                                        borderSide: BorderSide(
                                          color: Color.fromARGB(134, 255, 255, 255),
                                        )
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5),
                                        borderSide: BorderSide(
                                          color: Color.fromARGB(134, 255, 255, 255),
                                        )
                                      ),
                                    ),
                                    keyboardType: TextInputType.text,
                                  ),
                                  paddingTop(15),
                                  ElevatedButton(
                                    onPressed: spinner==true ? null : () {
                                      if (_formKey.currentState?.validate() ?? false) {
                                        _saveData();
                                      } 
                                    },
                                    child: spinner==true ? CircularProgressIndicator(color: const Color.fromARGB(135, 255, 255, 255)) : Container(
                                      width: double.infinity,
                                      padding: EdgeInsets.all(15),
                                      child: Center(
                                        child: Text('Enregister',
                                          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w300)
                                        ),
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      elevation: 0,
                                      backgroundColor: Colors.redAccent,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                    ),
                                  ),
                                  paddingTop(20),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ),
                SizedBox(
                  child: SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Form(
                            key: _formCompanyKey,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  GestureDetector(
                                    onTap: (){
                                      _pickLogo();
                                    },
                                    child: Container(
                                      padding: EdgeInsets.only(bottom: 20),
                                      child: Center(
                                        child: Stack(
                                          children: [
                                            // La bannière
                                            Container(
                                              width: double.infinity, // Largeur étendue
                                              height: 150, // Hauteur fixe
                                              decoration: BoxDecoration(
                                                color: Colors.grey[300],
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              child: (_logoFile != null)
                                              ? Image.file(
                                                  _logoFile,
                                                  fit: BoxFit.cover,
                                                )
                                              : (_logo_url != null && _logo_url != '')
                                              ? Image.network(
                                                  api.getbaseUpload() + _logo_url,
                                                  fit: BoxFit.cover,
                                                )
                                              : Container(
                                                color: Colors.grey[300],
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Text('Choisissez votre bannière',style: TextStyle(color: const Color.fromARGB(255, 150, 150, 150))),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              bottom: 10,
                                              right: 10,
                                              child: Container(
                                                padding: EdgeInsets.all(8),
                                                decoration: BoxDecoration(
                                                  color: primaryColor(),
                                                  borderRadius: BorderRadius.circular(20),
                                                ),
                                                child: Icon(
                                                  Icons.camera_alt,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  TextFormField(
                                    textInputAction: TextInputAction.next,
                                    textCapitalization: TextCapitalization.words,
                                    controller: businessNameController,
                                    style: TextStyle(color: Colors.black,fontWeight: FontWeight.w300),
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.only(left:15,top: 15,bottom: 20,right: 15),
                                      labelText: 'Nom de l\'entreprise',
                                      labelStyle: TextStyle(color: Color.fromARGB(255, 120, 120, 120),fontWeight: FontWeight.w300),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      filled: true,
                                      fillColor: Color.fromARGB(255, 204, 204, 204).withOpacity(0.3),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5),
                                        borderSide: BorderSide(
                                          color: Color.fromARGB(134, 255, 255, 255),
                                        )
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5),
                                        borderSide: BorderSide(
                                          color: Color.fromARGB(134, 255, 255, 255),
                                        )
                                      ),
                                    ),
                                    keyboardType: TextInputType.name,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Veuillez saisir le nom de votre entreprise';
                                      }
                                      return null;
                                    },
                                  ),
                                  paddingTop(15),
                                  TextFormField(
                                    textInputAction: TextInputAction.next,
                                    controller: businessPhoneController,
                                    style: TextStyle(color: Colors.black,fontWeight: FontWeight.w300),
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.only(left:15,top: 15,bottom: 20,right: 15),
                                      labelText: "Téléphone de l'entreprise",
                                      labelStyle: TextStyle(color: Color.fromARGB(255, 120, 120, 120),fontWeight: FontWeight.w300),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      filled: true,
                                      fillColor: Color.fromARGB(255, 204, 204, 204).withOpacity(0.3),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5),
                                        borderSide: BorderSide(
                                          color: Color.fromARGB(134, 255, 255, 255),
                                        )
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5),
                                        borderSide: BorderSide(
                                          color: Color.fromARGB(134, 255, 255, 255),
                                        )
                                      ),
                                    ),
                                    keyboardType: TextInputType.emailAddress,
                                  ),
                                  paddingTop(15),
                                  TextFormField(
                                    textInputAction: TextInputAction.next,
                                    controller: businessEmailController,
                                    style: TextStyle(color: Colors.black,fontWeight: FontWeight.w300),
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.only(left:15,top: 15,bottom: 20,right: 15),
                                      labelText: 'E-mail entreprise',
                                      labelStyle: TextStyle(color: Color.fromARGB(255, 120, 120, 120),fontWeight: FontWeight.w300),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      filled: true,
                                      fillColor: Color.fromARGB(255, 204, 204, 204).withOpacity(0.3),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5),
                                        borderSide: BorderSide(
                                          color: Color.fromARGB(134, 255, 255, 255),
                                        )
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5),
                                        borderSide: BorderSide(
                                          color: Color.fromARGB(134, 255, 255, 255),
                                        )
                                      ),
                                    ),
                                    keyboardType: TextInputType.emailAddress,
                                  ),
                                  paddingTop(15),
                                  ElevatedButton(
                                    onPressed: spinner==true ? null : () {
                                      if (_formCompanyKey.currentState?.validate() ?? false) {
                                        _saveDataBusiness();
                                      } 
                                    },
                                    child: spinner==true ? CircularProgressIndicator(color: const Color.fromARGB(135, 255, 255, 255)) : Container(
                                      width: double.infinity,
                                      padding: EdgeInsets.all(15),
                                      child: Center(
                                        child: Text('Enregister',
                                          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w300)
                                        ),
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      elevation: 0,
                                      backgroundColor: Colors.redAccent,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                    ),
                                  ),
                                  paddingTop(20),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}