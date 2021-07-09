import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'login_screen.dart';

class Roles extends StatefulWidget {
  String userNameG;
  Roles(String username) {
    this.userNameG = username;
  }

  @override
  _RolesState createState() => _RolesState();
}

class _RolesState extends State<Roles> {
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
                      "Roles",
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
          //chooseView(existsFamily),
          //AQUI SE COLOCA LA VISTA
        
        ],
      ),
    );
  }

}