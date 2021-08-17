import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:letsworkhomeapp/screens/home_screen.dart';

import 'login_screen.dart';

class Family extends StatefulWidget {
  String userNameG;
  Family(String username) {
    this.userNameG = username;
  }

  @override
  _FamilyState createState() => _FamilyState();
}

class _FamilyState extends State<Family> {
  bool existsFamily;
  String sfamilyCode;
  String integrantes = "";
  var _apellidosFamilia = TextEditingController();
  var _familiaCode = TextEditingController();
  var _familiaCodeJoin = TextEditingController();
  List<DropdownMenuItem> _members =
      List<DropdownMenuItem>.empty(growable: true);

  _showSnackBarExito(message, String userName, String familyCode) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.green));
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => Family(this.widget.userNameG)));

    if (familyCode != "vacio") {
      _insertarNotificacion(userName, familyCode);
    }
  }

  _insertarNotificacion(String userName, String familyCode) {
    try {
      CollectionReference notificaciones =
          FirebaseFirestore.instance.collection('notificaciones');
      notificaciones.add({
        'categoriaNotificacion': 'Familia',
        'contenidoNotificacion': 'El usuario:' + userName + 'se ha unido.',
        'familyCode': familyCode,
      });
    } on FirebaseException catch (e) {
      _showSnackBarFallo("Error al registrarse");
    }
  }

  _showSnackBarFallo(message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
    ));
  }

  //Metodo inicial para la pantalla
  @override
  void initState() {
    super.initState();
    try {
      FirebaseFirestore.instance
          .collection('users')
          .where('userName', isEqualTo: this.widget.userNameG)
          .limit(1)
          .get()
          .then((QuerySnapshot querySnapshot) {
        if (querySnapshot.size > 0) {
          //Verificacion de familia
          querySnapshot.docs.forEach((doc) {
            if (doc["familyCode"] == "vacio") {
              setState(() {
                existsFamily = false;
                sfamilyCode = doc["familyCode"];
              });
            } else {
              setState(() {
                existsFamily = true;
                sfamilyCode = doc["familyCode"];
              });
            }
          });
        }
      });
    } on FirebaseException catch (e) {
      print("ERROR" + e.toString());
    }
  }

  //Devuelve vista para usuario sin familia.
  Column noFamilyView() {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(5),
          height: 300,
          child: miCard(
              "Informacion",
              "\nUsted aun no pertenece a algun grupo familiar\n\nNotas:\n\n°Si crea una familia automaticamente se unira a ella. \n\n°Si decide unirse a una ingrese el codigo.\n",
              0),
        ),
        // Usamos una fila para ordenar los botones del card
        Container(
          padding: EdgeInsets.all(5),
          height: 80,
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            color: Color(0xFF0097A7),
            elevation: 10,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ElevatedButton(
                    onPressed: () async {
                      _createFamilyDialog(context);
                    },
                    child: Text(
                      "Crear Familia",
                      style: GoogleFonts.openSans(
                          textStyle: TextStyle(
                              color: Color(0xFFFFFFFF),
                              fontSize: 14,
                              fontWeight: FontWeight.w600)),
                    ),
                    style: ElevatedButton.styleFrom(primary: Colors.green)),
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
                ElevatedButton(
                    onPressed: () async {
                      _joinFamilyDialog(context);
                    },
                    child: Text(
                      "Unirse a Familia",
                      style: GoogleFonts.openSans(
                          textStyle: TextStyle(
                              color: Color(0xFFFFFFFF),
                              fontSize: 14,
                              fontWeight: FontWeight.w600)),
                    ),
                    style: ElevatedButton.styleFrom(primary: Colors.orange)),
              ],
            ),
          ),
        )
      ],
    );
  }

//Vista para un usuario con familia
  Column familyView(String integrantes) {
    //FALTA RETORNAR LA LISTA CON LOS INTEGRANTES DE LA FAMILIA
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(5),
          height: 300,
          child: miCard("Informacion",
              "Intregantes de su grupo actual:\n" + integrantes, 0),
        ),
        // Usamos una fila para ordenar los botones del card
        Container(
          padding: EdgeInsets.all(5),
          height: 80,
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            color: Color(0xFF0097A7),
            elevation: 10,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ElevatedButton(
                    onPressed: () async {
                      getUserId("vacio");
                    },
                    child: Text(
                      "Abandonar Familia",
                      style: GoogleFonts.openSans(
                          textStyle: TextStyle(
                              color: Color(0xFFFFFFFF),
                              fontSize: 14,
                              fontWeight: FontWeight.w600)),
                    ),
                    style: ElevatedButton.styleFrom(primary: Colors.red)),
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
    );
  }

  //Registra una familia
  registrarFamilia(String apellidoFam, String familyCode) {
    try {
      //FALTA VALIDAR QUE EL CODIGO DE FAMILIA SEA UNICO.
      FirebaseFirestore.instance
          .collection('family')
          .where('familyCode', isEqualTo: familyCode)
          .limit(1)
          .get()
          .then((QuerySnapshot querySnapshot) {
        if (querySnapshot.size > 0) {
          _showSnackBarFallo(
              "El codigo ingresado ya esta asignado a otra familia, verifiquelo.");
        } else {
          CollectionReference users =
              FirebaseFirestore.instance.collection('family');
          users.add({
            'apellidoFam': apellidoFam,
            'familyCode': familyCode,
          }).then((value) => getUserId(familyCode));
        }
      });
    } on FirebaseException catch (e) {
      _showSnackBarFallo("Error al registrarse");
    }
  }

  //Registra una familia
  getUserId(String familyCode) {
    try {
      FirebaseFirestore.instance
          .collection('users')
          .where('userName', isEqualTo: this.widget.userNameG)
          .limit(1)
          .get()
          .then((QuerySnapshot querySnapshot) {
        if (querySnapshot.size > 0) {
          //Verificacion de familia
          querySnapshot.docs.forEach((doc) {
            actualizarUsuario(doc.id, familyCode, doc["userFullName"],
                doc["userName"], doc["userPassword"], doc["userRol"]);
          });
        }
      });
    } on FirebaseException catch (e) {
      print("ERROR" + e.toString());
    }
  }

  //Actualiza la familia del usuario
  actualizarUsuario(String userID, String familyCode, String userFullname,
      String userName, String userPassword, String userRol) {
    try {
      //FALTAN LAS PRUEBAS PARA LAS VALIDACIONES DE QUE EL CODIGO DE LA FAMILIA SEA CORRECTO
      FirebaseFirestore.instance
          .collection('family')
          .where('familyCode', isEqualTo: familyCode)
          .limit(1)
          .get()
          .then((QuerySnapshot querySnapshot) {
        if (querySnapshot.size > 0) {
          CollectionReference users =
              FirebaseFirestore.instance.collection('users');
          users.doc(userID).set({
            'familyCode': familyCode,
            'userFullName': userFullname,
            'userName': userName,
            'userPassword': userPassword,
            'userRol': userRol
          }).then((value) => _showSnackBarExito(
              "Familia Asignada Satisfactoriamente", userName, familyCode));
        } else {
          _showSnackBarFallo("El codigo ingresado no es valido, verifiquelo.");
        }
      });
    } on FirebaseException catch (e) {
      _showSnackBarFallo("Error al asignarFamilia");
    }
  }

  //Dialogo para crear una familia
  _createFamilyDialog(BuildContext context) {
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
                onPressed: () async {
                  registrarFamilia(_apellidosFamilia.text, _familiaCode.text);
                }, //Crea la familia
                child: Text("Crear"), //Texto que se despliega para el botón
              ),
              TextButton(
                onPressed: () {
                  //Al cancelar cierra solo el cuadro de dialogo.
                  Navigator.pop(context);
                },
                child: Text("Cancelar"),
              ),
            ],
            title: Text("Nueva Familia"), // Título del cuadro de dialogo
            content: SingleChildScrollView(
              child: Column(
                // Muestra en una columna cajas de texto para registrar una categoria
                children: [
                  TextField(
                    decoration: InputDecoration(
                        labelText: "Apellidos de la Familia:",
                        hintText: "Apellidos."),
                    controller: _apellidosFamilia,
                  ),
                  TextField(
                    decoration: InputDecoration(
                        labelText: "Codigo de acceso:",
                        hintText: "Codigo de union"),
                    controller: _familiaCode,
                  )
                ],
              ),
            ),
          );
        });
  }

  //Dialogo para crear o unirse a familia
  _joinFamilyDialog(BuildContext context) {
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
                onPressed: () async {
                  getUserId(_familiaCodeJoin.text);
                }, //Crea la familia
                child: Text("Unirse"), //Texto que se despliega para el botón
              ),
              TextButton(
                onPressed: () {
                  //Al cancelar cierra solo el cuadro de dialogo.
                  Navigator.pop(context);
                },
                child: Text("Cancelar"),
              ),
            ],
            title: Text("Unirse a Familia"), // Título del cuadro de dialogo
            content: SingleChildScrollView(
              child: Column(
                // Muestra en una columna cajas de texto para registrar una categoria
                children: [
                  TextField(
                    decoration: InputDecoration(
                        labelText: "Ingrese el codigo:",
                        hintText: "Codigo para unirse"),
                    controller: _familiaCodeJoin,
                  )
                ],
              ),
            ),
          );
        });
  }

//Permite decidir que vista desplegar
  Column chooseView(bool existsFamily) {
    try {
      FirebaseFirestore.instance
          .collection('users')
          .where('familyCode', isEqualTo: sfamilyCode.toString())
          .get()
          .then((QuerySnapshot querySnapshot) {
        if (querySnapshot.size > 0) {
          //Verificacion de familia
          querySnapshot.docs.forEach((doc) {
            if (!integrantes.contains(doc["userFullName"])) {
              setState(() {
                integrantes += "\n° " + doc["userFullName"];
              });
            }
          });
        }
      });
    } on FirebaseException catch (e) {
      print("ERROR" + e.toString());
    }

    switch (existsFamily) {
      case true:
        {
          return familyView(integrantes);
        }
        break;
      case false:
        {
          return noFamilyView();
        }
        break;
      default:
        {
          return Column(children: <Widget>[CircularProgressIndicator()]);
        }
        break;
    }
  }

//Permite crear una card personalizada
  Card miCard(String titulo, String subtitulo, int botones) {
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

  //Contenedor principal
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
                          "Familia",
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
              chooseView(existsFamily)
            ],
          ),
        ));
  }
}
