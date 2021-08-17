import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:letsworkhomeapp/Models/notificaciones_model.dart';

import 'home_screen.dart';
import 'login_screen.dart';

class Notificaciones extends StatefulWidget {
  String userNameG;
  String familyCodeG;
  Notificaciones(String username, String familyCode) {
    this.userNameG = username;
    this.familyCodeG = familyCode;
  }

  @override
  _NotificacionesState createState() => _NotificacionesState();
}

class _NotificacionesState extends State<Notificaciones> {
  List<Notificacion> _notificacionesList = [];

  _showSnackBarExito(message) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.green));
    _notificacionesList = [];
    Navigator.pop(context);
    loadNotificaciones();
  }

  _showSnackBarFallo(message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
    ));
  }

  @override
  void initState() {
    super.initState();
    loadNotificaciones();
  }

  void anadirNotificacion(Notificacion notificacion) {
    _notificacionesList.add(notificacion);
  }

  loadNotificaciones() {
    try {
      FirebaseFirestore.instance
          .collection('notificaciones')
          .where('familyCode', isEqualTo: this.widget.familyCodeG.toString())
          .get()
          .then((QuerySnapshot querySnapshot) {
        if (querySnapshot.size > 0) {
          //Verificacion de familia
          querySnapshot.docs.forEach((doc) {
            Notificacion notificacionL = new Notificacion();
            notificacionL.notificacionID = doc.id;
            notificacionL.categoriaNotificacion = doc["categoriaNotificacion"];
            notificacionL.contenidoNotificacion = doc["contenidoNotificacion"];
            notificacionL.familyCode = doc["familyCode"];
            anadirNotificacion(notificacionL);
          });
          setState(() {});
        }
      });
    } on FirebaseException catch (e) {
      print("ERROR" + e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFF006064),
        body: SingleChildScrollView(
          physics: ScrollPhysics(),
          child: Column(
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
                          "Notificaciones",
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
              ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: _notificacionesList.length,
                  itemBuilder: (context, int index) {
                    return Card(
                      color: Colors.blue,
                      child: ListTile(
                          title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "°Categoria:" +
                                _notificacionesList[index]
                                    .categoriaNotificacion +
                                "\n \n Descripción: \n°" +
                                _notificacionesList[index]
                                    .contenidoNotificacion,
                            overflow: TextOverflow.clip,
                            style: GoogleFonts.openSans(
                                textStyle: TextStyle(
                                    color: Color(0xFFFFFFFF),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600)),
                          ),
                          IconButton(
                              // Tanto el botón de editar y borrar mostrarán un cuadro de dialogo
                              icon: Icon(
                                Icons.delete,
                                color: Colors.red,
                              ), //Que contienen los botones para cancelar o realizar la operación
                              onPressed: () {
                                _deleteNotificacionDialog(context,
                                    _notificacionesList[index].notificacionID);
                              }),
                        ],
                      )),
                    );
                  }),
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
                          style:
                              ElevatedButton.styleFrom(primary: Colors.white)),
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }

  _deleteNotificacionDialog(BuildContext context, notificacionID) {
    //Dialogo para borrar un elemento
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (param) {
          return AlertDialog(
            // Se genera a partir de sus partes
            actions: <Widget>[
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  // Se coloca estilo para mejorar la experiencia
                  primary: Colors.green, // background
                  onPrimary: Colors.white, // foreground
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Cancelar'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.red, // background
                  onPrimary: Colors.white, // foreground
                ),
                onPressed: () async {
                  try {
                    //FALTAN LAS PRUEBAS PARA LAS VALIDACIONES DE QUE EL CODIGO DE LA FAMILIA SEA CORRECTO
                    CollectionReference users =
                        FirebaseFirestore.instance.collection('notificaciones');
                    users.doc(notificacionID).delete().then((value) =>
                        _showSnackBarExito(
                            "Notificacion eliminada para todos."));
                  } on FirebaseException catch (e) {
                    _showSnackBarFallo("Error verifiquelo");
                  }
                },
                child: Text('Eliminar'),
              ),
            ],
            title: Text(
                "¿Estas seguro que deseas eliminar esta notificacion para todos?"),
          );
        });
  }
}
