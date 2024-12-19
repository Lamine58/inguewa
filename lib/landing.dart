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
      body: Stack(
        children: [
          // Arrière-plan avec image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(asset('landing-bg.jpg')),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Dégradé sombre
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withOpacity(0),
                  Colors.black.withOpacity(0.3),
                  Colors.black.withOpacity(0.7),
                  Colors.black.withOpacity(1),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          // Contenu de la page de connexion
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 50),
                  Center(
                    child: Text(
                      "Bienvenu sur Inguewa.",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Spacer(),


                  Center(

                      child: Text(
                        "L’idée de la création du Salon Inguewa est partie d’un constat. Bien souvent, les clients ont des difficultés à trouver des prestataires de qualité pouvant répondre à leurs différents besoins. Pour pallier à cela, Inguewa a trouvé la solution pour opérer « la magie » à vos événements.",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),






            const SizedBox(height: 50,),


                  // Bouton Entrer
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      padding: EdgeInsets.symmetric(vertical: 15),
                    ),
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (context) => Tabs(context,0)),(route)=>false);
                    },
                    child: Text(
                      "Continuer",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),

                  const SizedBox(height: 10,),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
