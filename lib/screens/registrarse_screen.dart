import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:letsworkhomeapp/screens/login_screen.dart';

class Registrarse extends StatefulWidget {
  @override
  _RegistrarseState createState() => _RegistrarseState();
}

class _RegistrarseState extends State<Registrarse> {
  List<String> userData = [];
  var _userFullName = TextEditingController();
  var _userName = TextEditingController();
  var _userPassword = TextEditingController();
  String data = "";

  void initState() {
    super.initState();
  }

  _showSnackBarExito(message) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.green));
    Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
  }

  _showSnackBarFallo(message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF006064),
      body: new Container(
          child: Padding(
        padding: EdgeInsets.fromLTRB(10, 50, 10, 30),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            CircleAvatar(
              radius: 80,
              backgroundImage: AssetImage(
                "assets/user.png",
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Nombre Completo:",
                style: GoogleFonts.openSans(
                    textStyle: TextStyle(
                        color: Color(0xFFFFFFFF),
                        fontSize: 14,
                        fontWeight: FontWeight.w600)),
              ),
            ),
            TextField(
              controller: _userFullName,
              decoration: InputDecoration(
                  fillColor: Colors.white,
                  hintText: "Ingrese el nombre completo",
                  hintStyle: TextStyle(color: Colors.lightBlue)),
              style: GoogleFonts.openSans(
                  textStyle: TextStyle(
                      color: Color(0xFF03A9F4),
                      fontSize: 14,
                      fontWeight: FontWeight.w600)),
              // onSubmitted: (String value){addData(value);},
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Usuario:",
                style: GoogleFonts.openSans(
                    textStyle: TextStyle(
                        color: Color(0xFFFFFFFF),
                        fontSize: 14,
                        fontWeight: FontWeight.w600)),
              ),
            ),
            TextField(
              controller: _userName,
              decoration: InputDecoration(
                  fillColor: Colors.white,
                  hintText: "Ingrese el usuario",
                  hintStyle: TextStyle(color: Colors.lightBlue)),
              style: GoogleFonts.openSans(
                  textStyle: TextStyle(
                      color: Color(0xFF03A9F4),
                      fontSize: 14,
                      fontWeight: FontWeight.w600)),
              // onSubmitted: (String value){addData(value);},
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Contraseña:",
                style: GoogleFonts.openSans(
                    textStyle: TextStyle(
                        color: Color(0xFFFFFFFF),
                        fontSize: 14,
                        fontWeight: FontWeight.w600)),
              ),
            ),
            TextField(
                controller: _userPassword,
                decoration: InputDecoration(
                    fillColor: Colors.white,
                    hintText: "Ingrese la Contraseña",
                    hintStyle: TextStyle(color: Colors.lightBlue)),
                style: GoogleFonts.openSans(
                    textStyle: TextStyle(
                        color: Color(0xFF03A9F4),
                        fontSize: 14,
                        fontWeight: FontWeight.w600)),
                obscureText: true
                // onSubmitted: (String value){addData(value);},
                ),
            ElevatedButton(
                onPressed: () async {
                  if (_userFullName.text.isNotEmpty &&
                      _userName.text.isNotEmpty &&
                      _userPassword.text.isNotEmpty) {
                    try {
                      FirebaseFirestore.instance
                          .collection('users')
                          .where('userName', isEqualTo: _userName.text)
                          .limit(1)
                          .get()
                          .then((QuerySnapshot querySnapshot) {
                        if (querySnapshot.size > 0) {
                          _showSnackBarFallo(
                              "Error al registrarse, el nombre de usuario ya existe pruebe con otro");
                        } else {
                          registrarUsuario(_userFullName.text, _userName.text,
                              _userPassword.text);
                        }
                      });
                    } on FirebaseException catch (e) {
                      print("ERROR" + e.toString());
                    }
                  }else{
                     _showSnackBarFallo(
                              "Uno o mas campos estan vacios.");
                  }
                },
                child: Text(
                  "Guardar",
                  style: GoogleFonts.openSans(
                      textStyle: TextStyle(
                          color: Color(0xFFFFFFFF),
                          fontSize: 14,
                          fontWeight: FontWeight.w600)),
                ),
                style: ElevatedButton.styleFrom(primary: Colors.blue)),
            ElevatedButton(
                onPressed: () async {
                  Navigator.of(context).pushAndRemoveUntil(
                             MaterialPageRoute(builder: (context){
                              return Login();
                             }), 
                          (Route<dynamic> route) => false);
                },
                child: Text(
                  "Cancelar",
                  style: GoogleFonts.openSans(
                      textStyle: TextStyle(
                          color: Color(0xFFFFFFFF),
                          fontSize: 14,
                          fontWeight: FontWeight.w600)),
                ),
                style: ElevatedButton.styleFrom(primary: Colors.red)),
          ],
        ),
      )),
    );
  }

  registrarUsuario(String fullname, String username, String password) {
    try {
      CollectionReference users =
          FirebaseFirestore.instance.collection('users');
      users.add({
        'familyCode': 'vacio',
        'userFullName': fullname,
        'userName': username,
        'userPassword': password,
        'userRol': 'Vacio'
      }).then((value) => _showSnackBarExito("Registrado Satisfactoriamente"));
    } on FirebaseException catch (e) {
      _showSnackBarFallo("Error al registrarse");
    }
  }
}
