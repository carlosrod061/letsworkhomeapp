import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:letsworkhomeapp/Models/tarea_model.dart';

import 'home_screen.dart';
import 'login_screen.dart';

class Tareas extends StatefulWidget {
  String userNameG;
  String familyCodeG;
  Tareas(String username, String familyCode) {
    this.userNameG = username;
    this.familyCodeG = familyCode;
  }

  @override
  _TareasState createState() => _TareasState();
}

class _TareasState extends State<Tareas> {
  var _tareaName = TextEditingController();
  List<Tarea> _tareasList = [];
  var _editNombreCompleto = TextEditingController();
  String _editRol;

  List<DropdownMenuItem> _categoriasItems =
      List<DropdownMenuItem>.empty(growable: true);

  List<String> _categoriasList = [
    "Limpieza",
    "Compras",
    "Diversión",
    "Cocina",
    "Baño",
    "Sala",
    "Mascotas",
    "Vecinos"
  ];

  loadcategorias() {
    _categoriasList.forEach((categoria) {
      _categoriasItems
          .add(DropdownMenuItem(child: Text(categoria), value: categoria));
    });
  }

  _showSnackBarExito(message) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.green));
    _tareasList = [];
    Navigator.pop(context);
    loadTareas();
  }

  _showSnackBarFallo(message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
    ));
  }

  void anadirTarea(Tarea tarea) {
    _tareasList.add(tarea);
  }

  loadTareas() {
    try {
      FirebaseFirestore.instance
          .collection('tareas')
          .where('familyCode', isEqualTo: this.widget.familyCodeG.toString())
          .get()
          .then((QuerySnapshot querySnapshot) {
        if (querySnapshot.size > 0) {
          //Verificacion de familia
          querySnapshot.docs.forEach((doc) {
            Tarea tareaL = new Tarea();
            tareaL.tituloTarea = doc["tituloTarea"];
            tareaL.descripcionTarea = doc["descripcionTarea"];
            tareaL.fechaVencimiento = doc["fechaVencimiento"];
            tareaL.categoriaTarea = doc["categoriaTarea"];
            tareaL.creadorTarea = doc["creadorTarea"];
            tareaL.familyCode = doc["familyCode"];
            tareaL.finalizadaTarea = doc["finalizadaTarea"];
            if (tareaL.finalizadaTarea == "Si") {
            } else {
              anadirTarea(tareaL);
            }
          });
          setState(() {});
        }
      });
    } on FirebaseException catch (e) {
      print("ERROR" + e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    loadcategorias();
    loadTareas();
  }

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
            ListView.builder(
                shrinkWrap: true,
                itemCount: _tareasList.length,
                itemBuilder: (context, int index) {
                  return Card(
                    child: ListTile(
                        leading: IconButton(
                            icon: Icon(Icons.edit), // Cada elemento
                            onPressed: () {
                              _editIntegranteDialog(
                                  context,
                                  _tareasList[index].tituloTarea,
                                 _tareasList[index].tituloTarea,
                                 _tareasList[index].tituloTarea);

                              //tiene un botón de editar y borrar al igual que el nombre de la categoría
                            }),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("° Titulo: " +
                                _tareasList[index].tituloTarea +
                                "\n ° Categoria: " +
                                _tareasList[index].categoriaTarea +
                                "\n ° Vencimiento: " +
                                _tareasList[index].fechaVencimiento),
                            IconButton(
                                // Tanto el botón de editar y borrar mostrarán un cuadro de dialogo
                                icon: Icon(Icons
                                    .delete), //Que contienen los botones para cancelar o realizar la operación
                                onPressed: () {
                                  try {
                                    FirebaseFirestore.instance
                                        .collection('users')
                                        .where('userName',
                                            isEqualTo: _tareasList[index]
                                                .tituloTarea
                                                .toString())
                                        .limit(1)
                                        .get()
                                        .then((QuerySnapshot querySnapshot) {
                                      if (querySnapshot.size > 0) {
                                        //Verificacion de familia
                                        querySnapshot.docs.forEach((doc) {
                                          _deleteIntegranteDialog(
                                              context, doc.id);
                                        });
                                      }
                                    });
                                  } on FirebaseException catch (e) {
                                    print("ERROR" + e.toString());
                                  }
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
        floatingActionButton: FloatingActionButton(
          //El botón flotante servirá para mostrar el dialogo de registro nuevo
          onPressed: () {
            _showFormInDialog(context);
          },
          child: Icon(Icons.add),
        ));
  }

  _editIntegranteDialog(BuildContext context, String userName,
      String userFullName, String userRol) {
    _editNombreCompleto = TextEditingController(text: userFullName);
    _editRol = userRol;
    return showDialog(
        // Muestra un cuadro de dialogo generado
        context: context,
        barrierDismissible: true,
        builder: (param) {
          return AlertDialog(
            // Dialogo tipo alerta
            actions: [
              // Con botones
              TextButton(
                //Boton de actualizar.
                onPressed: () async {
                  //Al presionar asignará datos para actualizar del form.
                  try {
                    FirebaseFirestore.instance
                        .collection('users')
                        .where('userName', isEqualTo: userName.toString())
                        .limit(1)
                        .get()
                        .then((QuerySnapshot querySnapshot) {
                      if (querySnapshot.size > 0) {
                        //Verificacion de familia
                        querySnapshot.docs.forEach((doc) {
                          actualizarUsuario(
                              doc.id,
                              doc["familyCode"],
                              _editNombreCompleto.text,
                              doc["userName"],
                              doc["userPassword"],
                              _editRol);
                        });
                      }
                    });
                  } on FirebaseException catch (e) {
                    print("ERROR" + e.toString());
                  }
                },
                child: Text("Actualizar"),
              ),
              TextButton(
                onPressed: () {
                  // en caso de cancelar solo mostará la pantalla con la lista
                  Navigator.pop(context, "Cancelar");
                },
                child: Text("Cancelar"),
              ),
            ],
            title: Text("Formulario de edición"),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    decoration: InputDecoration(
                        //Cajas de texto
                        labelText: "Nombre Completo:",
                        hintText: "Nombre Completo del usuario"),
                    controller: _editNombreCompleto,
                  ),
                  DropdownButtonFormField(
                    value: _editRol,
                    items: _categoriasItems,
                    hint: Text("Seleccione una categoria"),
                    onChanged: (value) {
                      setState(() {
                        _editRol = value;
                      });
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  _deleteIntegranteDialog(BuildContext context, userID) {
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
                        FirebaseFirestore.instance.collection('users');
                    users.doc(userID).delete().then((value) =>
                        _showSnackBarExito("Eliminado satisfactoriamente"));
                  } on FirebaseException catch (e) {
                    _showSnackBarFallo("Error verifiquelo");
                  }
                },
                child: Text('Eliminar'),
              ),
            ],
            title: Text(
                "¿Estas seguro que deseas eliminar este miembro de la familia?"),
          );
        });
  }

  actualizarUsuario(String userID, String familyCode, String userFullname,
      String userName, String userPassword, String userRol) {
    try {
      //FALTAN LAS PRUEBAS PARA LAS VALIDACIONES DE QUE EL CODIGO DE LA FAMILIA SEA CORRECTO
      CollectionReference users =
          FirebaseFirestore.instance.collection('users');
      users.doc(userID).set({
        'familyCode': familyCode,
        'userFullName': userFullname,
        'userName': userName,
        'userPassword': userPassword,
        'userRol': userRol
      }).then((value) =>
          _showSnackBarExito("Datos modificados Satisfactoriamente"));
    } on FirebaseException catch (e) {
      _showSnackBarFallo("Error verifiquelo");
    }
  }

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
                        labelText: "Tarea name:", hintText: "Write tarea name"),
                    controller: _tareaName,
                  ),
                ],
              ),
            ),
          );
        });
  }
}
