import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:letsworkhomeapp/screens/home_screen.dart';

import 'login_screen.dart';

class Roles extends StatefulWidget {
  String userNameG;
  String familyCodeG;
  Roles(String username,String familyCode) {
    this.userNameG = username;
    this.familyCodeG = familyCode;
  }

  @override
  _RolesState createState() => _RolesState();
}

class _RolesState extends State<Roles> {
  List<String> _integrantesList = ["Carlos", "El que sigue"];

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
          ListView.builder(
              shrinkWrap: true,
              itemCount: _integrantesList.length,
              itemBuilder: (context, int index) {
                return Card(
                  child: ListTile(
                      leading: IconButton(
                          icon: Icon(Icons.edit), // Cada elemento
                          onPressed: () {
                            //tiene un botón de editar y borrar al igual que el nombre de la categoría
                            _editIntegranteRol(
                                context,
                                _integrantesList[
                                    index]); //llamada al metodo que busca en la bd
                          }),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(_integrantesList[index].toString()),
                          IconButton(
                              // Tanto el botón de editar y borrar mostrarán un cuadro de dialogo
                              icon: Icon(Icons
                                  .delete), //Que contienen los botones para cancelar o realizar la operación
                              onPressed: () {
                                _deleteIntegranteDialog(
                                    context, _integrantesList[index]);
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
                      style: ElevatedButton.styleFrom(primary: Colors.white)),
                ],
              ),
            ),
          )
        ],
      ),
    );
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

  _editIntegranteRol(BuildContext context, tareaId) async {}

  _deleteIntegranteDialog(BuildContext context, tareaId) {
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
                child: Text('Cancel'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.red, // background
                  onPrimary: Colors.white, // foreground
                ),
                onPressed: () async {
                  // Al presionar borrar se eliminara el registro
                },
                child: Text('Delete'),
              ),
            ],
            title: Text("Are you sure you want to delete?"),
          );
        });
  }

  Row tareaView() {
    print(_integrantesList[0]);
    return Row(
      children: <Widget>[
        Expanded(
          child: SizedBox(
            height: 200.0,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _integrantesList.length,
                itemBuilder: (context, int index) {
                  return Card(
                    child: ListTile(
                        leading: IconButton(
                            icon: Icon(Icons.edit), // Cada elemento
                            onPressed: () {
                              //tiene un botón de editar y borrar al igual que el nombre de la categoría
                              _editIntegranteRol(
                                  context,
                                  _integrantesList[
                                      index]); //llamada al metodo que busca en la bd
                            }),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(_integrantesList[index].toString()),
                            IconButton(
                                // Tanto el botón de editar y borrar mostrarán un cuadro de dialogo
                                icon: Icon(Icons
                                    .delete), //Que contienen los botones para cancelar o realizar la operación
                                onPressed: () {
                                  _deleteIntegranteDialog(
                                      context, _integrantesList[index]);
                                }),
                          ],
                        )),
                  );
                }),
          ),
        ),
      ],
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
    );
  }
}
