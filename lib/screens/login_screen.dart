import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:letsworkhomeapp/screens/registrarse_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home_screen.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  List<String> userData = [];
  var _userName = TextEditingController();
  var _userPassword = TextEditingController();
  String data = "";

  void initState() {
    super.initState();
  }

  _showSnackBarExito(message) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.blue));
  }

  _showSnackBarFallo(message) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.red));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*appBar: AppBar(
        title: Text("Login"),
      ),*/
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
                  hintText: "Ingrese el Usuario",
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
              obscureText: true,
              style: GoogleFonts.openSans(
                  textStyle: TextStyle(
                      color: Color(0xFF03A9F4),
                      fontSize: 14,
                      fontWeight: FontWeight.w600)),
              // onSubmitted: (String value){addData(value);},
            ),
            ElevatedButton(
                onPressed: () async {
                  try {
                    FirebaseFirestore.instance
                        .collection('users')
                        .where('userName', isEqualTo: _userName.text)
                        .limit(1)
                        .get()
                        .then((QuerySnapshot querySnapshot) {
                      if (querySnapshot.size > 0) {
                        querySnapshot.docs.forEach((doc) {
                          if (_userName.text == doc["userName"] &&
                              _userPassword.text == doc["userPassword"]) {
                            _showSnackBarExito(
                                "Ha iniciado sesion exitosamente");
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(builder: (context) {
                              return Home(_userName.text);
                            }), (Route<dynamic> route) => false);
                          } else {
                            _showSnackBarFallo(
                                "El usuario y/o contraseña son incorrectos");
                          }
                        });
                      } else {
                        _showSnackBarFallo(
                            "El usuario y/o contraseña son incorrectos");
                      }
                    });
                  } on FirebaseException catch (e) {
                    print("ERROR" + e.toString());
                  }
                },
                child: Text(
                  "Iniciar sesión",
                  style: GoogleFonts.openSans(
                      textStyle: TextStyle(
                          color: Color(0xFFFFFFFF),
                          fontSize: 14,
                          fontWeight: FontWeight.w600)),
                ),
                style: ElevatedButton.styleFrom(primary: Colors.blue)),
            ElevatedButton(
                onPressed: () async {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Registrarse()));
                },
                child: Text(
                  "Registrarse",
                  style: GoogleFonts.openSans(
                      textStyle: TextStyle(
                          color: Color(0xFFFFFFFF),
                          fontSize: 14,
                          fontWeight: FontWeight.w600)),
                ),
                style: ElevatedButton.styleFrom(primary: Colors.green)),
          ],
        ),
      )),
    );
  }
}
