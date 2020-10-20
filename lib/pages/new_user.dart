import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ecoheroes/pages/termcond.dart';
import 'package:ecoheroes/ui/to_textinput.dart';
import 'package:vector_math/vector_math.dart' as vectormath;
import '../ui/to_textinput.dart';
import 'home.dart';

class NewUser extends StatefulWidget {
  @override
  _NewUserState createState() => _NewUserState();
}

class _NewUserState extends State<NewUser> {
  var loading = false;
  var terms = false;
  var errores = {}, controllerform = {};

  User user;
  var loginform = {
    'nombres': '',
    'apellidos': '',
    'correo': '',
    'username': '',
    'password': '',
    'password_2': '',
  };

  var validator = {
    'nombres': RegExp(r'.*\S.*'),
    'apellidos': RegExp(r'.*\S.*'),
    'correo': RegExp(r'.*\S.*'),
    'username': RegExp(r'.*\S.*'),
    'password': RegExp(r'.*\S.*'),
    'password_2': RegExp(r'.*\S.*'),
  };

  void setterm(value) {
    setState(() {
      terms = value;
    });
  }

  bool validateform(form, validator, errores) {
    bool errors;
    for (var i in form.keys) {
      if (!validator[i].hasMatch(form[i])) {
        setState(() {
          errores[i] = true;
        });
        continue;
      }
      setState(() {
        errores[i] = false;
      });
    }
    for (var i in errores.values) {
      if (i) {
        errors = true;
        break;
      } else {
        errors = false;
      }
    }
    return !errors;
  }

  bool especialvalidation(form, errores) {
    if (form['password'] != form['password_2']) {
      setState(
        () {
          errores['password'] = true;
          errores['password_2'] = true;
        },
      );
      return false;
    }
    return true;
  }

  void enviarform() {
    if (validateform(loginform, validator, errores)) {
      if (especialvalidation(loginform, errores)) {
        setState(() {
          terms = true;
        });
      }
    }
  }

  Future<void> createuser(context) async {
    setState(() {
      terms = false;
      loading = true;
    });
    var errorMessage;
    try {
      UserCredential result;
      await FirebaseAuth.instance.createUserWithEmailAndPassword(email: loginform['correo'], password: loginform['password']).then(
            (value) async => {
              result = value,
              await FirebaseFirestore.instance.collection('users').add(
                {
                  'email': loginform['correo'].toLowerCase(),
                  'firstname': loginform['nombres'],
                  'lastname': loginform['apellidos'],
                  'username': loginform['username'],
                  'profile_picture': '/default/default.png',
                  'instagram_v': false,
                  'email_v': false,
                },
              ).then((value) => user = result.user)
            },
          );
    } catch (e) {
      switch (e.code) {
        case "ERROR_WEAK_PASSWORD":
          errorMessage = "Contraseña debe tener minimo 6 caracteres!";
          break;
        case "ERROR_INVALID_EMAIL":
          errorMessage = "Mail invalido!";
          break;
        case "ERROR_EMAIL_ALREADY_IN_USE":
          errorMessage = "Ya existe un usuario con ese correo!";
          break;
        default:
          errorMessage = "Error de conexión o desconocido";
      }
    }
    if (errorMessage != null) {
      Scaffold.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        content: Text(errorMessage),
      ));
      setState(() {
        loading = false;
      });
      return;
    }
    if (user.uid != null) {
      Navigator.of(context).push(PageRouteBuilder(
        transitionDuration: Duration(seconds: 1),
        pageBuilder: (_, __, ___) => Home(user: user),
      ));
    }
  }

  void initializateform(form, [dispose = false]) {
    form.forEach(
      (k, v) => {
        if (dispose)
          {
            controllerform[k].dispose(),
          }
        else
          {
            errores[k] = false,
            controllerform[k] = TextEditingController(),
            controllerform[k].addListener(
              () => {
                setState(
                  () {
                    loginform[k] = controllerform[k].text;
                  },
                ),
              },
            ),
          }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    initializateform(loginform);
  }

  void dispose() {
    initializateform(loginform, true);
    super.dispose();
  }

  AppBar appbar = AppBar(
    centerTitle: true,
    backgroundColor: Colors.transparent,
    elevation: 0.0,
    title: SizedBox(
      height: 20,
      child: Hero(
        tag: 'splash',
        child: Image.asset('assets/logo_appbar.png'),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: appbar,
      body: Builder(builder: (BuildContext context) {
        return (InkWell(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF4AD6A7), Color(0xFF4AD6CC)],
                transform: GradientRotation(
                  vectormath.radians(45),
                ),
              ),
            ),
            child: terms
                ? TermCond(
                    setterm: setterm,
                    contexto: context,
                    createuser: createuser,
                  )
                : SafeArea(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 20),
                        child: Stack(
                          children: <Widget>[
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                TOTextInput(
                                  hinttext: 'Nombres',
                                  value: controllerform['nombres'],
                                  error: errores['nombres'],
                                  texterror: 'Revisar los nombres',
                                ),
                                TOTextInput(
                                  hinttext: 'Apellidos',
                                  value: controllerform['apellidos'],
                                  error: errores['apellidos'],
                                  texterror: 'Revisar los apellidos',
                                ),
                                TOTextInput(hinttext: 'Correo Electrónico', value: controllerform['correo'], error: errores['correo'], texterror: 'Revisar el correo electronico', teclado: TextInputType.emailAddress),
                                TOTextInput(
                                  hinttext: 'Nombre de usuario',
                                  value: controllerform['username'],
                                  error: errores['username'],
                                  texterror: 'Revisar el nombre de usuario',
                                ),
                                TOTextInput(
                                  hinttext: 'Contraseña',
                                  value: controllerform['password'],
                                  password: true,
                                  error: errores['password'],
                                  texterror: 'Revisar las contraseñas',
                                ),
                                TOTextInput(
                                  hinttext: 'Repite Contraseña',
                                  value: controllerform['password_2'],
                                  password: true,
                                  error: errores['password_2'],
                                  texterror: 'Revisar las contraseñas',
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 13.0),
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(Radius.circular(100)),
                                            border: Border.all(width: 4, color: Colors.white),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Color.fromRGBO(0, 0, 0, 0.16),
                                                blurRadius: 6,
                                                offset: Offset(0, 6),
                                              )
                                            ],
                                          ),
                                          child: SizedBox(
                                            height: 38,
                                            child: FlatButton(
                                              color: Color(0xFF4AD6C0),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(100),
                                              ),
                                              padding: EdgeInsets.all(0),
                                              onPressed: loading
                                                  ? null
                                                  : () => {
                                                        enviarform(),
                                                      },
                                              child: Row(
                                                children: <Widget>[
                                                  Expanded(
                                                    child: Center(
                                                      child: loading
                                                          ? Container(
                                                              height: 18,
                                                              width: 18,
                                                              child: CircularProgressIndicator(
                                                                strokeWidth: 3,
                                                                valueColor: AlwaysStoppedAnimation(Colors.white),
                                                              ))
                                                          : Text(
                                                              'Registrarse',
                                                              style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white),
                                                            ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
          ),
        ));
      }),
    );
  }
}
