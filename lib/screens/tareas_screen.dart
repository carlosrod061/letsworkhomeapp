import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'login_screen.dart';

class Tareas extends StatefulWidget {
  String userNameG;
  Tareas(String username) {
    this.userNameG = username;
  }

  @override
  _TareasState createState() => _TareasState();
}

class _TareasState extends State<Tareas> {
var _tareaName = TextEditingController();
  List<String> _tareaList = ["Carlos","El que sigue"];
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  var _editTareaName = TextEditingController();
  var Tarea;

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
                      "Tareas",
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
          tareaView()
        ],
      ),
      floatingActionButton: FloatingActionButton(
        //El botón flotante servirá para mostrar el dialogo de registro nuevo
        onPressed: () {
          _showFormInDialog(context);
        },
        child: Icon(Icons.add),
      )
    );
  }

  _editTarea(BuildContext context, tareaId) async {}

  _showFormInDialog(BuildContext context) {
    //Muestra el formulario para guardar
    return showDialog(
        //retorna un dialog
        context: context, //El elemento actual
        barrierDismissible:
            true, //Que se pueda salir al dar tap fuera de su area
        builder: (param) {
          // método que lo genera
          return AlertDialog(
            // Estilo tipo alerta
            actions: [
              TextButton(
                // Botones
                onPressed: () async {}, //Actualiza el listado de categorias
                child: Text("Save"), //Texto que se despliega para el botón
              ),
              TextButton(
                onPressed: () {
                  //Al cancelar cierra solo el cuadro de dialogo.
                  Navigator.pop(context);
                },
                child: Text("Cancel"),
              ),
            ],
            title: Text("Tarea Form"), // Título del cuadro de dialogo
            content: SingleChildScrollView(
              child: Column(
                // Muestra en una columna cajas de texto para registrar una categoria
                children: [
                  TextField(
                    decoration: InputDecoration(
                        labelText: "Tarea name:",
                        hintText: "Write tarea name"),
                    controller: _tareaName,
                  ),
                ],
              ),
            ),
          );
        });
  }

  _deleteTareaDialog(BuildContext context, tareaId) {
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
    return Row(
      children: <Widget>[
        Expanded(
          child: SizedBox(
            height: 200.0,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _tareaList.length,
                itemBuilder: (context, int index) {
                  return Card(
                    child: ListTile(
                        leading: IconButton(
                            icon: Icon(Icons.edit), // Cada elemento
                            onPressed: () {
                              //tiene un botón de editar y borrar al igual que el nombre de la categoría
                              _editTarea(
                                  context,
                                  _tareaList[
                                      index]); //llamada al metodo que busca en la bd
                            }),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(_tareaList[index].toString()),
                            IconButton(
                                // Tanto el botón de editar y borrar mostrarán un cuadro de dialogo
                                icon: Icon(Icons
                                    .delete), //Que contienen los botones para cancelar o realizar la operación
                                onPressed: () {
                                  _deleteTareaDialog(
                                      context, _tareaList[index]);
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
