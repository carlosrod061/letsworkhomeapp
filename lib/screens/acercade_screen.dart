import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'home_screen.dart';
import 'login_screen.dart';

class Acercade extends StatefulWidget {
  String userNameG;
  Acercade(String username) {
    this.userNameG = username;
  }

  @override
  _AcercadeState createState() => _AcercadeState();
}

//Permite crear una card personalizada
Card miCard(String titulo, String subtitulo) {
  return Card(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    color: Color(0xFF0097A7),
    elevation: 10,
    child: Column(
      children: <Widget>[
        ListTile(
          contentPadding: EdgeInsets.fromLTRB(15, 10, 25, 0),
          title: Text(
            titulo,
            style: GoogleFonts.openSans(
                textStyle: TextStyle(
                    color: Color(0xFFFFFFFF),
                    fontSize: 20,
                    fontWeight: FontWeight.w600)),
          ),
          subtitle: Text(
            subtitulo,
            style: GoogleFonts.openSans(
                textStyle: TextStyle(
                    color: Color(0xFFFFFFFF),
                    fontSize: 14,
                    fontWeight: FontWeight.w600)),
          ),
          leading: Icon(Icons.info),
        ),
      ],
    ),
  );
}

class _AcercadeState extends State<Acercade> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF006064),
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 110,
          ),
          Padding(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "" + this.widget.userNameG + "",
                      style: GoogleFonts.openSans(
                          textStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.bold)),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Text(
                      "Acerca de",
                      style: GoogleFonts.openSans(
                          textStyle: TextStyle(
                              color: Color(0xFF0097A7),
                              fontSize: 20,
                              fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
                ElevatedButton(
                    onPressed: () async {
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) {
                        return Login();
                      }), (Route<dynamic> route) => false);
                    },
                    child: Text(
                      "Cerrar sesión",
                      style: GoogleFonts.openSans(
                          textStyle: TextStyle(
                              color: Color(0xFFFFFFFF),
                              fontSize: 14,
                              fontWeight: FontWeight.w600)),
                    ),
                    style: ElevatedButton.styleFrom(primary: Colors.red))
              ],
            ),
          ),
          SizedBox(
            height: 40,
          ),
          miCard(
              "Lets Work At Home App",
              "\n ° Nombre de la aplicación: \n -Lets Work at Home App- \n \n" +
                  "° Nombre del Autor: \n -Carlos Joel Rodriguez Mares- \n\n ° Grupo: \n -GDGS1091-E- \n\n ° Asignatura: \n -Desarrollo para Dispositivos Inteligentes- \n\n" +
                  "° Institución: \n -Universidad Tecnologica del Norte de Guanajuato-\n"),
          Container(
            padding: EdgeInsets.all(5),
            height: 80,
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              color: Color(0xFF0097A7),
              elevation: 10,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  ElevatedButton(
                      onPressed: () async {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    Home(this.widget.userNameG)));
                      },
                      child: Icon(Icons.home, color: Colors.black),
                      style: ElevatedButton.styleFrom(primary: Colors.white)),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
