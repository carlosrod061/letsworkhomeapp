import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:letsworkhomeapp/screens/home_screen.dart';

import 'login_screen.dart';

class Roles extends StatefulWidget {
  String userNameG;
  String familyCodeG;
  Roles(String username, String familyCode) {
    this.userNameG = username;
    this.familyCodeG = familyCode;
  }

  @override
  _RolesState createState() => _RolesState();
}

class _RolesState extends State<Roles> {
  List<String> _integrantesList = [];
  var _editNombreCompleto = TextEditingController();
  String _editRol;

  List<DropdownMenuItem> _rolesItems =
      List<DropdownMenuItem>.empty(growable: true);

  List<String> _rolesList = [
    "Hijo(a)",
    "Padre",
    "Madre",
    "Abuelo(a)",
    "Tio(a)",
    "Sobrino(a)",
    "Primo(a)",
    "Vacio"
  ];

  loadroles() {
    _rolesList.forEach((rol) {
      _rolesItems.add(DropdownMenuItem(child: Text(rol), value: rol));
    });
  }

  _showSnackBarExito(
      message, String userName, String familyCode, String accion) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.green));
    _integrantesList = [];
    Navigator.pop(context);
    loadIntegrantes();
    _insertarNotificacion(userName, familyCode, accion);
  }

  _insertarNotificacion(String userName, String familyCode, String accion) {
    String mensaje = "";
    if (accion == "Modificado") {
      mensaje = "El rol de " + userName + " fue modificado";
    } else {
      mensaje = "Un usuario ha sido eliminado";
    }

    try {
      CollectionReference notificaciones =
          FirebaseFirestore.instance.collection('notificaciones');
      notificaciones.add({
        'categoriaNotificacion': 'Roles',
        'contenidoNotificacion': mensaje,
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

  void anadirIntegrante(String userNameIntegrante) {
    _integrantesList.add(userNameIntegrante);
  }

  loadIntegrantes() {
    try {
      FirebaseFirestore.instance
          .collection('users')
          .where('familyCode', isEqualTo: this.widget.familyCodeG.toString())
          .get()
          .then((QuerySnapshot querySnapshot) {
        if (querySnapshot.size > 0) {
          //Verificacion de familia
          querySnapshot.docs.forEach((doc) {
            anadirIntegrante(doc["userName"]);
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
    loadroles();
    loadIntegrantes();
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
                      color: Colors.blue,
                      child: ListTile(
                          leading: IconButton(
                              icon: Icon(Icons.edit,
                                  color: Colors.orange), // Cada elemento
                              onPressed: () {
                                try {
                                  FirebaseFirestore.instance
                                      .collection('users')
                                      .where('userName',
                                          isEqualTo: _integrantesList[index])
                                      .limit(1)
                                      .get()
                                      .then((QuerySnapshot querySnapshot) {
                                    if (querySnapshot.size > 0) {
                                      //Verificacion de familia
                                      querySnapshot.docs.forEach((doc) {
                                        _editIntegranteDialog(
                                            context,
                                            _integrantesList[index],
                                            doc["userFullName"],
                                            doc["userRol"]);
                                      });
                                    }
                                  });
                                } on FirebaseException catch (e) {
                                  print("ERROR" + e.toString());
                                }
                                //tiene un botón de editar y borrar al igual que el nombre de la categoría
                              }),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _integrantesList[index].toString(),
                                style: GoogleFonts.openSans(
                                    textStyle: TextStyle(
                                        color: Color(0xFFFFFFFF),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600)),
                              ),
                              IconButton(
                                  // Tanto el botón de editar y borrar mostrarán un cuadro de dialogo
                                  icon: Icon(Icons.delete,
                                      color: Colors
                                          .red), //Que contienen los botones para cancelar o realizar la operación
                                  onPressed: () {
                                    if (_integrantesList[index].toString() ==
                                        this.widget.userNameG) {
                                      _showSnackBarFallo(
                                          "Esta operacion no se puede realizar");
                                    } else {
                                      try {
                                        FirebaseFirestore.instance
                                            .collection('users')
                                            .where('userName',
                                                isEqualTo:
                                                    _integrantesList[index]
                                                        .toString())
                                            .limit(1)
                                            .get()
                                            .then(
                                                (QuerySnapshot querySnapshot) {
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
                    items: _rolesItems,
                    hint: Text("Seleccione un rol"),
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
                        _showSnackBarExito("Eliminado satisfactoriamente",
                            userID, this.widget.familyCodeG, "Eliminado"));
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
      }).then((value) => _showSnackBarExito(
          "Datos modificados Satisfactoriamente",
          userName,
          familyCode,
          "Modificado"));
    } on FirebaseException catch (e) {
      _showSnackBarFallo("Error verifiquelo");
    }
  }
}
