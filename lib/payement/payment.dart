// ignore_for_file: avoid_unnecessary_containers, prefer_const_literals_to_create_immutables, prefer_const_constructors, sort_child_properties_last, non_constant_identifier_names, prefer_typing_uninitialized_variables, use_build_context_synchronously
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:inguewa/api/api.dart';
import 'package:inguewa/function/function.dart';
import 'package:inguewa/tabs/tabs.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class Payment extends StatefulWidget {

  final contribution;
  final customer_id;
  final contribution_id;

  const Payment(this.contribution,this.customer_id,this.contribution_id,{Key? key}) : super(key: key);

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {


  String lang = 'Français';
  late Api api = Api();

  late TextEditingController amountController = TextEditingController();
  
  MaskTextInputFormatter amount = MaskTextInputFormatter(
    mask: '##############', 
    filter: { "#": RegExp(r'[0-9]') },
    type: MaskAutoCompletionType.lazy
  );


  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var data = jsonDecode(prefs.getString('cutomerData')!);

    if(prefs.getString('lang')!=null){
      setState(() {
        lang = prefs.getString('lang')!;
      });
    }
  }

  void _showResultDialog(String result) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(5))),
        title: Text('Réponse',style: TextStyle(fontSize: 20),),
        content: Text(result,style: TextStyle(fontWeight: FontWeight.w300)),
      ),
    );
  }

  pay(channel) async {

    if((amountController.text.trim()=='' || int.parse(amountController.text)<100) && (widget.contribution['amount']==null)){
      _showResultDialog('Veuillez saisir le montant supérieur à 100 XOF');
      return false;
    }
      
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(5))),
        contentPadding: EdgeInsets.all(15),
        content: Row(
          children: [
            CircularProgressIndicator(),
            paddingLeft(20),
            Text('Veuillez patientez...')
          ],
        ),
      ),
    );

    try {

      dynamic response;
      response = await api.post('payment-contribution',{"customer_id":widget.customer_id,"contribution_id":widget.contribution_id,"channel":channel,"amount": widget.contribution['amount'] ?? amountController.text});

      if (response['status'] == 'success') {

        final Uri url = Uri.parse(response['url']);
        await launchUrl(url, mode:LaunchMode.externalApplication);

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => Tabs(context,0)),
          (route)=>false
        );

      } else {
        Navigator.pop(context);
        _showResultDialog(response['message']);
      }
    } catch (error) {
       Navigator.pop(context);
      _showResultDialog('Erreur: $error');
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
          widget.contribution['name'],
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w100,
            fontFamily: 'louisewalker',
          ),
        ),
        toolbarHeight: 40,
      ),
      body: Container(
        decoration: BoxDecoration(
          color: secondaryColor(),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(left:25,right: 25,top: 0,bottom: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Finaliser le paiement',
                    style: TextStyle(fontSize: 23, color: Colors.white, fontWeight: FontWeight.w300),
                    textAlign: TextAlign.start,
                  ),
                  paddingTop(5),
                  Text("Montant : ${widget.contribution['amount'] ?? 'A défini'} ${widget.contribution['amount']!=null ? 'XOF' : ''} ",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w300),textAlign: TextAlign.start),
                  paddingTop(5),
                  Text(
                    'Choisissez une méthode de paiement',
                    style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w200),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(15),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft:Radius.circular(25),topRight:Radius.circular(25))
                ),
               child: Container(
                 padding: EdgeInsets.all(15),
                 child: Center(
                   child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Column(
                          children: [
                            widget.contribution['amount']==null
                            ? Padding(
                              padding: const EdgeInsets.only(bottom: 30),
                              child: TextFormField(
                                inputFormatters: [amount],
                                textInputAction: TextInputAction.next,
                                controller: amountController,
                                style: TextStyle(color: Colors.black,fontWeight: FontWeight.w300),
                                decoration: InputDecoration(
                                  hintText: "Montant",
                                  contentPadding: EdgeInsets.only(left:15,top: 15,bottom: 20,right: 15),
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
                                keyboardType: TextInputType.phone,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Veuillez saisir votre numéro de téléphone';
                                  }
                                  return null;
                                },
                              ),
                            ) : SizedBox(),
                            Row(
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: ()=>{
                                      pay('WAVECI')
                                    },
                                    child: Container(
                                      padding: EdgeInsets.only(top:30,bottom:30,left: 30,right: 30),
                                      child: Column(
                                        children: [
                                          Image.asset('assets/images/wave.png',height: 100),
                                        ],
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color.fromARGB(255, 255, 255, 255),
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 2,
                                            blurRadius: 7, 
                                            offset: Offset(0, 1),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                paddingLeft(15),
                                Expanded(child:
                                  GestureDetector(
                                    onTap: ()=>{
                                      pay('OMCIV2')
                                    },
                                    child: Container(
                                      padding: EdgeInsets.only(top:30,bottom:30,left: 30,right: 30),
                                      child: Column(
                                        children: [
                                          Image.asset('assets/images/om.png',height: 100),
                                        ],
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color.fromARGB(255, 255, 255, 255),
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 2,
                                            blurRadius: 7, 
                                            offset: Offset(0, 1),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ),
                              ],
                            )
                          ],
                        ),
                        paddingTop(15),
                        Column(
                          children: [
                            Row(
                              children: [
                                Expanded(child:
                                  GestureDetector(
                                    onTap: ()=>{
                                      pay('MOMOCI')
                                    },
                                    child: Container(
                                      padding: EdgeInsets.only(top:30,bottom:30,left: 30,right: 30),
                                      child: Column(
                                        children: [
                                          Image.asset('assets/images/momo.png',height: 100),
                                        ],
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color.fromARGB(255, 255, 255, 255),
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 2,
                                            blurRadius: 7, 
                                            offset: Offset(0, 1),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ),
                                paddingLeft(15),
                                Expanded(child:
                                  GestureDetector(
                                    onTap: ()=>{
                                      pay('FLOOZ')
                                    },
                                    child: Container(
                                      padding: EdgeInsets.only(top:30,bottom:30,left: 30,right: 30),
                                      child: Column(
                                        children: [
                                          Image.asset('assets/images/moov.png',height: 100),
                                        ],
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color.fromARGB(255, 255, 255, 255),
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 2,
                                            blurRadius: 7, 
                                            offset: Offset(0, 1),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ),
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                   ),
                 ),
               ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
