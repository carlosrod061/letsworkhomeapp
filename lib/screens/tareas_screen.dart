import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
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
  var _tareaTitulo = TextEditingController();
  var _tareaDescripcion = TextEditingController();
  List<Tarea> _tareasList = [];
  var _editTituloTarea = TextEditingController();
  var _editDescripcionTarea = TextEditingController();
  String _editCategoriaTarea;
  var _editFechaTarea = TextEditingController();
  String _insertCategoria;
  var _todoDate = TextEditingController();
  DateTime _date = DateTime.now();
  List<DropdownMenuItem> _categoriasItems =
      List<DropdownMenuItem>.empty(growable: true);

  _selectTodoDate() async {
    var _pickedDate = await showDatePicker(
        context: context,
        initialDate: _date,
        firstDate: DateTime(2000),
        lastDate: DateTime(2099));
    if (_pickedDate != null) {
      setState(() {
        _date = _pickedDate;
        _todoDate.text = DateFormat("yyyy-MM-dd").format(_pickedDate);
      });
    }
  }

  _editTodoDate() async {
    var _pickedDate = await showDatePicker(
        context: context,
        initialDate: _date,
        firstDate: DateTime(2000),
        lastDate: DateTime(2099));
    if (_pickedDate != null) {
      setState(() {
        _date = _pickedDate;
        _editFechaTarea.text = DateFormat("yyyy-MM-dd").format(_pickedDate);
      });
    }
  }

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

  _showSnackBarExito(message, String tituloTarea, String accion) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.green));
    _tareasList = [];
    Navigator.pop(context);
    loadTareas();
    _insertarNotificacion(
        this.widget.userNameG, tituloTarea, this.widget.familyCodeG, accion);
  }

  _insertarNotificacion(
      String userName, String tituloTarea, String familyCode, String accion) {
    String mensaje = "";
    switch (accion) {
      case 'Modificacion':
        mensaje = tituloTarea + " fue modificada por " + userName;
        break;
      case 'Creacion':
        mensaje = tituloTarea + " fue creada por " + userName;
        break;
      case 'Completada':
        mensaje = tituloTarea + " fue completada por " + userName;
        break;
      default:
        mensaje = "";
        break;
    }

    try {
      CollectionReference notificaciones =
          FirebaseFirestore.instance.collection('notificaciones');
      notificaciones.add({
        'categoriaNotificacion': 'Tareas',
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
            if (tareaL.finalizadaTarea == "No") {
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
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: _tareasList.length,
                  itemBuilder: (context, int index) {
                    return Card(
                      color: Colors.blue,
                      child: ListTile(
                          leading: IconButton(
                              icon: Icon(Icons.edit,
                                  color: Colors.orange), // Cada elemento
                              onPressed: () {
                                _editTareaDialog(
                                    context,
                                    _tareasList[index].tituloTarea,
                                    _tareasList[index].descripcionTarea,
                                    _tareasList[index].categoriaTarea,
                                    _tareasList[index].fechaVencimiento);

                                //tiene un botón de editar y borrar al igual que el nombre de la categoría
                              }),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "° Titulo: " +
                                    _tareasList[index].tituloTarea +
                                    "\n ° Creador: " +
                                    _tareasList[index].creadorTarea +
                                    "\n ° Vencimiento: " +
                                    _tareasList[index].fechaVencimiento,
                                style: GoogleFonts.openSans(
                                    textStyle: TextStyle(
                                        color: Color(0xFFFFFFFF),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600)),
                              ),
                              IconButton(
                                  // Tanto el botón de editar y borrar mostrarán un cuadro de dialogo
                                  icon: Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                  ), //Que contienen los botones para cancelar o realizar la operación
                                  onPressed: () {
                                    try {
                                      FirebaseFirestore.instance
                                          .collection('tareas')
                                          .where('tituloTarea',
                                              isEqualTo: _tareasList[index]
                                                  .tituloTarea)
                                          .limit(1)
                                          .get()
                                          .then((QuerySnapshot querySnapshot) {
                                        if (querySnapshot.size > 0) {
                                          //Verificacion de familia
                                          querySnapshot.docs.forEach((doc) {
                                            actualizarTarea(
                                                doc.id,
                                                _tareasList[index].tituloTarea,
                                                _tareasList[index]
                                                    .descripcionTarea,
                                                _tareasList[index]
                                                    .categoriaTarea,
                                                _tareasList[index]
                                                    .fechaVencimiento,
                                                "Si",
                                                doc["familyCode"],
                                                doc["creadorTarea"],
                                                "Tarea Finalizada");
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
                          style:
                              ElevatedButton.styleFrom(primary: Colors.white)),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          //El botón flotante servirá para mostrar el dialogo de registro nuevo
          onPressed: () {
            _showFormInDialog(context);
          },
          child: Icon(Icons.add),
        ));
  }

  _editTareaDialog(BuildContext context, String tituloTarea,
      String descripcionTarea, String categoriaTarea, String fechaTarea) {
    _editTituloTarea = TextEditingController(text: tituloTarea);
    _editCategoriaTarea = categoriaTarea;
    _editDescripcionTarea = TextEditingController(text: descripcionTarea);
    _editFechaTarea = TextEditingController(text: fechaTarea);

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
                        .collection('tareas')
                        .where('tituloTarea', isEqualTo: tituloTarea.toString())
                        .limit(1)
                        .get()
                        .then((QuerySnapshot querySnapshot) {
                      if (querySnapshot.size > 0) {
                        //Verificacion de familia
                        querySnapshot.docs.forEach((doc) {
                          actualizarTarea(
                              doc.id,
                              _editTituloTarea.text,
                              _editDescripcionTarea.text,
                              _editCategoriaTarea,
                              _editFechaTarea.text,
                              "No",
                              doc["familyCode"],
                              doc["creadorTarea"],
                              "Tarea Modificada");
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
                        labelText: "Titulo de la tarea:",
                        hintText: "Escribe el titulo."),
                    controller: _editTituloTarea,
                  ),
                  TextField(
                    decoration: InputDecoration(
                        labelText: "Descripcion de la tarea:",
                        hintText: "Escribe la descripcion."),
                    controller: _editDescripcionTarea,
                  ),
                  DropdownButtonFormField(
                    value: _editCategoriaTarea,
                    items: _categoriasItems,
                    hint: Text("Seleccione una categoria"),
                    onChanged: (value) {
                      setState(() {
                        _editCategoriaTarea = value;
                      });
                    },
                  ),
                  TextField(
                    controller: _editFechaTarea,
                    decoration: InputDecoration(
                      hintText: "YY-MM-DD",
                      labelText: "YY-MM-DD",
                      prefixIcon: InkWell(
                        child: Icon(Icons.calendar_today),
                        onTap: () {
                          _editTodoDate();
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  actualizarTarea(
      String tareaID,
      String tituloTarea,
      String descripcionTarea,
      String categoriaTarea,
      String fechaTarea,
      String tareaFinalizada,
      String familyCode,
      String creadorTarea,
      String mensaje) {
    String accion = "";
    if (tareaFinalizada == "Si") {
      accion = "Completada";
    } else {
      accion = "Modificacion";
    }

    try {
      //FALTAN LAS PRUEBAS PARA LAS VALIDACIONES DE QUE EL CODIGO DE LA FAMILIA SEA CORRECTO
      CollectionReference tareas =
          FirebaseFirestore.instance.collection('tareas');
      tareas.doc(tareaID).set({
        'categoriaTarea': categoriaTarea,
        'creadorTarea': creadorTarea,
        'descripcionTarea': descripcionTarea,
        'familyCode': familyCode,
        'fechaVencimiento': fechaTarea,
        'finalizadaTarea': tareaFinalizada,
        'tituloTarea': tituloTarea,
      }).then((value) => _showSnackBarExito(mensaje, tituloTarea, accion));
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
                onPressed: () async {
                  try {
                    FirebaseFirestore.instance
                        .collection('tareas')
                        .where('tituloTarea', isEqualTo: _tareaTitulo.text)
                        .limit(1)
                        .get()
                        .then((QuerySnapshot querySnapshot) {
                      if (querySnapshot.size > 0) {
                        _showSnackBarFallo(
                            "Error al insertar, el nombre de tarea ya existe pruebe con otro");
                      } else {
                        insertarTarea(_tareaTitulo.text, _tareaDescripcion.text,
                            _insertCategoria, _todoDate.text);
                      }
                    });
                  } on FirebaseException catch (e) {
                    print("ERROR" + e.toString());
                  }
                }, //Actualiza el listado de categorias
                child: Text("Guardar"), //Texto que se despliega para el botón
              ),
              TextButton(
                onPressed: () {
                  //Al cancelar cierra solo el cuadro de dialogo.
                  Navigator.pop(context);
                },
                child: Text("Cancelar"),
              ),
            ],
            title: Text("Formulario de Tareas"), // Título del cuadro de dialogo
            content: SingleChildScrollView(
              child: Column(
                // Muestra en una columna cajas de texto para registrar una tarea
                children: [
                  TextField(
                    decoration: InputDecoration(
                        labelText: "Titulo de la tarea:",
                        hintText: "Escribe el titulo."),
                    controller: _tareaTitulo,
                  ),
                  TextField(
                    decoration: InputDecoration(
                        labelText: "Descripcion de la tarea:",
                        hintText: "Escribe la descripcion."),
                    controller: _tareaDescripcion,
                  ),
                  DropdownButtonFormField(
                    items: _categoriasItems,
                    hint: Text("Seleccione una categoria"),
                    onChanged: (value) {
                      setState(() {
                        _insertCategoria = value;
                      });
                    },
                  ),
                  TextField(
                    controller: _todoDate,
                    decoration: InputDecoration(
                      hintText: "YY-MM-DD",
                      labelText: "YY-MM-DD",
                      prefixIcon: InkWell(
                        child: Icon(Icons.calendar_today),
                        onTap: () {
                          _selectTodoDate();
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  insertarTarea(String tituloTarea, String descripcionTarea,
      String categoriaTarea, String fechaTarea) {
    try {
      CollectionReference tareas =
          FirebaseFirestore.instance.collection('tareas');
      tareas.add({
        'categoriaTarea': categoriaTarea,
        'creadorTarea': this.widget.userNameG,
        'descripcionTarea': descripcionTarea,
        'familyCode': this.widget.familyCodeG,
        'fechaVencimiento': fechaTarea,
        'finalizadaTarea': 'No',
        'tituloTarea': tituloTarea
      }).then((value) =>
          _showSnackBarExito("Tarea Insertada", tituloTarea, "Creacion"));
    } on FirebaseException catch (e) {
      _showSnackBarFallo("Error al registrar la tarea");
    }
  }
}
