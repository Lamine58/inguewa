// ignore_for_file: non_constant_identifier_names, unused_field, prefer_const_literals_to_create_immutables, prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:inguewa/function/function.dart';
import 'package:inguewa/tabs/tabs.dart';

class Landing extends StatefulWidget {
  const Landing({Key? key}) : super(key: key);

  @override
  State<Landing> createState() => _LandingState();
}

class _LandingState extends State<Landing> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.black,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(asset('landing-bg.jpg')),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withOpacity(0),
                  Colors.black.withOpacity(0),
                  Colors.black.withOpacity(0.5),
                  Colors.black.withOpacity(0.9),
                  Colors.black.withOpacity(1)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Positioned(
            left: 20,
            right: 20,
            bottom: 50,
            child: Column(
              children: [
                Image.asset(asset('bg-3.png')),
                paddingTop(10),
                Text(
                  'Inguewa',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 35,
                    fontWeight: FontWeight.w100,
                    fontFamily: 'louisewalker',
                  ),
                ),
                paddingTop(10),
                Text(
                  "L’idée de la création du Salon Inguewa est partie d’un constat. Bien souvent, les clients ont des difficultés à trouver des prestataires de qualité pouvant répondre à leurs différents besoins. Pour pallier à cela, Inguewa a trouvé la solution pour opérer « la magie » à vos événements.",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13.5,
                    fontFamily: 'Polyester',
                  ),
                  textAlign: TextAlign.center,
                ),
                paddingTop(25),
                GestureDetector(
                  onTap: () {
                    Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (context) => Tabs(context,0)),(route)=>false);
                  },
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    child: Stack(
                      children: [
                        Container(
                          width: double.infinity,
                          height: double.infinity,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(asset('arriere-plan-vectoriel-motif-pointille-dans-style-aborigene_619130-1631.png')),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          height: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'CONTINUER',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(width: 15),
                              Icon(Icons.arrow_forward, color: Colors.white, size: 20),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}