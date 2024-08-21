
// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:inguewa/function/function.dart';

input(label,error_message,controller,keyboard_type,{readyonly=false}){
    
    return Container(
      decoration: BoxDecoration(
        color: Color(0xffe4e9f1),
        borderRadius: BorderRadius.circular(5)
      ),
      child: TextFormField(
        readOnly: readyonly,
        controller: controller,
        keyboardType: keyboard_type,
        style :TextStyle(
          fontSize: 14
        ),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(top: 15,bottom: 15,left: 15,right: 5),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.transparent,
            ),
            borderRadius: BorderRadius.circular(50.0), 
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.transparent,
            ),
            borderRadius: BorderRadius.circular(50.0), 
          ),
          labelText: label,
          labelStyle: TextStyle(
            color: Color(0xffbbbbbb),
            fontSize: 14,
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return error_message;
          }
          if(keyboard_type==TextInputType.emailAddress && !isValidEmail(value)){
            return error_message;
          }
          return null;
        },
      ),
    );
  }


  input_area(label,error_message,controller,keyboard_type,{readyonly=false}){
    
    return Container(
      decoration: BoxDecoration(
        color: Color(0xffe4e9f1),
        borderRadius: BorderRadius.circular(5)
      ),
      child: TextFormField(
        readOnly: readyonly,
        maxLines: 5,
        controller: controller,
        textInputAction: TextInputAction.next,
        keyboardType: keyboard_type,
        style :TextStyle(
          fontSize: 14
        ),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(top: 15,bottom: 15,left: 15,right: 5),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.transparent,
            ),
            borderRadius: BorderRadius.circular(50.0), 
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.transparent,
            ),
            borderRadius: BorderRadius.circular(50.0), 
          ),
          labelText: label,
          labelStyle: TextStyle(
            color: Color(0xffbbbbbb),
            fontSize: 14,
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return error_message;
          }
          return null;
        },
      ),
    );
  }
