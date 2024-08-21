// ignore_for_file: prefer_const_constructors

import 'dart:io';
// ignore: depend_on_referenced_packages
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

primaryColor() {
  return const Color(0xff8b6724);
}

secondaryColor() {
  return const Color(0xff000000);
}

redColor() {
  return Color.fromARGB(255, 240, 77, 77);
}

grayColor() {
  return Color.fromARGB(255, 141, 141, 141);
}

whiteColor() {
  return Color.fromARGB(255, 255, 255, 255);
}

paddingTop(height){
  return SizedBox(height: height.toDouble());
}

paddingLeft(width){
  return SizedBox(width: width.toDouble());
}

logo(width){
  return Image.asset('assets/images/logo.png',width: width.toDouble());
}

shortDate(dateString){
  
  DateTime parsedDate = DateFormat('dd/MM/yyyy', 'fr_FR').parse(dateString);
  String formattedDate = DateFormat('dd\nMMM', 'fr_FR').format(parsedDate);

  return Text(
    formattedDate,
    textAlign: TextAlign.center,
    style: TextStyle(
      fontSize: 10,
      fontFamily: 'louisewalker',
    ),
  );
}

asset(file){
  return 'assets/images/$file';
}

statusBar(color){
  return AppBar(
    toolbarHeight: 0,
    elevation: 0,
    backgroundColor: color,
  );
}

toast(context,message){
  var snackBar = SnackBar(
    content: Text(message),
    backgroundColor: secondaryColor(),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

Future<File> compressImage(String imagePath, {int targetSize = 0}) async {
  File compressedImage;
  int quality = 100;

  do {
    var compressedData = await FlutterNativeImage.compressImage(
      imagePath,
      quality: quality,
    );

    compressedImage = File(compressedData.path);

    if (targetSize > 0 && compressedImage.lengthSync() > targetSize) {
      quality -= 10; // Decrease quality by 10 units if the size is still too large
    }
  } while (targetSize > 0 && compressedImage.lengthSync() > targetSize && quality > 0);

  return compressedImage;
}


String formatDate(DateTime dateTime, String locale) {
  initializeDateFormatting();
  return  DateFormat.yMMMMEEEEd(locale).format(dateTime);
}

String formatDateTime(DateTime dateTime, String locale) {
  initializeDateFormatting();
  return  DateFormat.yMMMMEEEEd(locale).add_Hms().format(dateTime);
}

bool isValidEmail(String email) {
  final RegExp emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );
  return emailRegex.hasMatch(email);
}

amount(numberString){
  double number = double.parse(numberString);
  return NumberFormat('#,###', 'fr_FR').format(number);
}

String dateLang(String dateString) {
  DateTime dateTime = DateTime.parse(dateString);
  return formatDate(dateTime, 'fr_FR');
}

ImageChannel(channel){

  if(channel=="WAVECI"){
    return Image.asset('assets/images/wave.png',height:70);
  }else if(channel=="OMCIV2"){
    return Image.asset('assets/images/om.png',height:70);
  }else if(channel=="MOMOCI"){
    return Image.asset('assets/images/momo.png',height:70);
  }else if(channel=="FLOOZ"){
    return Image.asset('assets/images/moov.png',height:70);
  }
}