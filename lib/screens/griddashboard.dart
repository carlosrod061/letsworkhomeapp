import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:letsworkhomeapp/screens/acercade_screen.dart';
import 'package:letsworkhomeapp/screens/notificaciones_screen.dart';
import 'package:letsworkhomeapp/screens/roles_screen.dart';
import 'package:letsworkhomeapp/screens/tareas_screen.dart';

import 'family_screen.dart';

// ignore: must_be_immutable
class GridDashboard extends StatelessWidget {
  String userNameG;
  String familyCode;

  GridDashboard(String username) {
    this.userNameG = username;
    try {
      FirebaseFirestore.instance
          .collection('users')
          .where('userName', isEqualTo: username.toString())
          .limit(1)
          .get()
          .then((QuerySnapshot querySnapshot) {
        if (querySnapshot.size > 0) {
          //Verificacion de familia
          querySnapshot.docs.forEach((doc) {
            this.familyCode = doc["familyCode"];
          });
        }
      });
    } on FirebaseException catch (e) {
      print("ERROR" + e.toString());
    }
  }

  DateTime currentDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    showDatePicker(
        context: context,
        initialDate: currentDate,
        firstDate: DateTime(2015),
        lastDate: DateTime(2050));
  }

  Items item1 =
      new Items(title: "Notificaciones", img: "assets/notification.png");

  Items item2 = new Items(
    title: "Tareas",
    img: "assets/todo.png",
  );
  Items item3 = new Items(
    title: "Familia",
    img: "assets/familycard.png",
  );
  Items item4 = new Items(
    title: "Roles",
    img: "assets/rol.png",
  );
  Items item5 = new Items(
    title: "Calendario",
    img: "assets/calendar.png",
  );
  Items item6 = new Items(
    title: "Acerca de",
    img: "assets/acercade.png",
  );
  @override
  Widget build(BuildContext context) {
    List<Items> myList = [item1, item2, item3, item4, item5, item6];
    var color = 0xFF0097A7;
    return Flexible(
      child: GridView.count(
          childAspectRatio: 1.0,
          padding: EdgeInsets.only(left: 16, right: 16),
          crossAxisCount: 2,
          crossAxisSpacing: 18,
          mainAxisSpacing: 18,
          children: myList.map((data) {
            return Container(
              decoration: BoxDecoration(
                  color: Color(color), borderRadius: BorderRadius.circular(10)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    data.img,
                    width: 30,
                  ),
                  SizedBox(
                    height: 14,
                  ),
                  Text(
                    data.title,
                    style: GoogleFonts.openSans(
                        textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600)),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        switch (data.title) {
                          case "Calendario":
                            {
                              _selectDate(context);
                            }
                            break;

                          case "Familia":
                            {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          Family(this.userNameG)));
                            }
                            break;
                          case "Notificaciones":
                            {
                              if (this.familyCode == "vacio") {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text(
                                        "No cuentas con una familia asignada aún"),
                                    backgroundColor: Colors.red));
                              } else {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Notificaciones(
                                            this.userNameG, this.familyCode)));
                              }
                            }
                            break;
                          case "Tareas":
                            {
                              if (this.familyCode == "vacio") {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text(
                                        "No cuentas con una familia asignada aún"),
                                    backgroundColor: Colors.red));
                              } else {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Tareas(
                                            this.userNameG, this.familyCode)));
                              }
                            }
                            break;
                          case "Roles":
                            {
                              if (this.familyCode == "vacio") {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text(
                                        "No cuentas con una familia asignada aún"),
                                    backgroundColor: Colors.red));
                              } else {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Roles(
                                            this.userNameG, this.familyCode)));
                              }
                            }
                            break;
                          case "Acerca de":
                            {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          Acercade(this.userNameG)));
                            }
                            break;

                          default:
                            {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text("Estas intentando ir a " +
                                          data.title),
                                      backgroundColor: Colors.green));
                            }
                            break;
                        }
                      },
                      child: Text(
                        "Ir a " + data.title,
                        style: GoogleFonts.openSans(
                            textStyle: TextStyle(
                                color: Color(0xFFFFFFFF),
                                fontSize: 14,
                                fontWeight: FontWeight.w600)),
                      ),
                      style: ElevatedButton.styleFrom(primary: Colors.green))
                ],
              ),
            );
          }).toList()),
    );
  }
}

class Items {
  String title;
  String subtitle;
  String event;
  String img;
  Items({this.title, this.subtitle, this.event, this.img});
}
