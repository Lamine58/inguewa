// ignore_for_file: non_constant_identifier_names, unused_field, prefer_const_literals_to_create_immutables
import 'dart:async';
import 'package:flutter/material.dart';
// import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:inguewa/function/function.dart';
import 'package:inguewa/landing.dart';
import 'package:inguewa/tabs/tabs.dart';
import 'package:shared_preferences/shared_preferences.dart';


void main() {
  runApp(const App());
}

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App>{

  final _navigatorKey = GlobalKey<NavigatorState>();
  late AnimationController _controller;
  late Animation<double> _animation;

  // late AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;

  _start() async {

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    
    if(prefs.getString('customerData')!=null){
      _navigatorKey.currentState?.pushReplacement(MaterialPageRoute(builder: (context) => Tabs(context,0)));
    }else{
      _navigatorKey.currentState?.pushReplacement(MaterialPageRoute(builder: (context) => const Landing())); 
    }
  }

  @override
  void initState() {
    super.initState();
    initOneSignal();
    initDeepLinks();
    Timer(const Duration(seconds: 2), () {
      _start();
    });

  }

  @override
  void dispose() {
    super.dispose();
  }


  initOneSignal() async {
    // try{

    //   await OneSignal.shared.setAppId("d7afcb21-61fb-4210-8045-9ae22cf9da33");
    //   OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {});

    //   OneSignal.shared.setNotificationWillShowInForegroundHandler((OSNotificationReceivedEvent event) async {

    //     final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    //     final SharedPreferences prefs = await _prefs;

    //     var notifications = prefs.getStringList('notifications') ?? [];
    //     var notification = event.notification.body;
    //     notifications.add(notification!);

    //     await prefs.setStringList('notifications', notifications);

    //   });

    // }catch(e){
    //   print(e);
    // }
  }


  initDeepLinks() async {

    // _appLinks = AppLinks();

    // final appLink = await _appLinks.getInitialLink();
    // if (appLink != null) {
    // }

    // _linkSubscription = _appLinks.uriLinkStream.listen((uri) async {
    //   _navigatorKey.currentState?.pushNamed('/transactions');
    // });

  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navigatorKey,
      title: 'Inguewa',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: primaryColor()),
        useMaterial3: true,
        fontFamily: 'Toboggan',
        primaryColor: primaryColor(),
      ),
      routes: {
        // '/services': (context) => const Services(),
      },
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      home:Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              logo(150),
              paddingTop(20),
            ],
          )
        ),
      )
    );

  }
}

