import 'dart:io';
import 'package:ecoheroes/provider/userprovider.dart';
import 'package:ecoheroes/ui/to_socialbutton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ecoheroes/pages/home.dart';
import 'package:ecoheroes/pages/new_user.dart';
import 'package:ecoheroes/pages/recoverpassword.dart';
import 'package:provider/provider.dart';
import 'package:vector_math/vector_math.dart' as vectormath;
import '../ui/to_textinput.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  var errores = {}, controllerform = {};
  var loading = false;
  var loginform = {'email': '', 'password': ''};
  var validator = {
    'email': RegExp(r'\b[\w\.-]+@[\w\.-]+\.\w{2,4}\b'),
    'password': RegExp(r'.*\S.*'),
  };

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

  void enviarform(context) {
    if (validateform(loginform, validator, errores)) {
      loginuser(context);
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

  Future<void> loginuser(context) async {
    final userprovider = Provider.of<UserProvider>(context, listen: false);
    setState(() {
      loading = true;
    });
    var errorMessage;
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: loginform['email'], password: loginform['password']);
      userprovider.user = result.user;
    } catch (error) {
      switch (error.code) {
        case "invalid-email":
          errorMessage = "Email no valido!";
          break;
        case "wrong-password":
          errorMessage = "La contraseña es incorrecta!";
          break;
        case "user-not-found":
          errorMessage = "Email no registrado!";
          break;
        case "user-disabled":
          errorMessage = "Email deshabilitado!";
          break;
        default:
          errorMessage = "Error de conexión o desconocido";
      }
    }
    setState(() {
      loading = false;
    });
    if (errorMessage != null) {
      Scaffold.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        content: Text(errorMessage),
      ));
      return;
    }
    if (userprovider.user.uid != null) {
      Navigator.of(context).push(PageRouteBuilder(
        transitionDuration: Duration(seconds: 1),
        pageBuilder: (_, __, ___) => Home(user: userprovider.user),
      ));
    }
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

  @override
  Widget build(BuildContext context) {
    final userprovider = Provider.of<UserProvider>(context, listen: false);
    return Scaffold(
      body: Builder(builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF4AD6A7), Color(0xFF4AD6CC)],
              transform: GradientRotation(
                vectormath.radians(45),
              ),
            ),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                child: Stack(
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(bottom: 30.0),
                          child: Hero(
                            tag: 'logo',
                            child: Image.asset(
                              'assets/logo_splash.png',
                              width: 180,
                              height: 180,
                            ),
                          ),
                        ),
                        Column(
                          children: <Widget>[
                            TOTextInput(
                              key: Key('login-mail'),
                              hinttext: 'Email',
                              password: false,
                              texterror: 'Por favor verificar email',
                              value: controllerform['email'],
                              error: errores['email'],
                              teclado: TextInputType.emailAddress,
                            ),
                            TOTextInput(
                              key: Key('login-password'),
                              hinttext: 'Contraseña',
                              password: true,
                              value: controllerform['password'],
                              texterror: 'Por favor verificar contraseña',
                              error: errores['password'],
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            TOSocialButton(
                              color: Color(0xFFEB4335),
                              texto: 'Google',
                              imagen: 'assets/google.png',
                              onTap: () async {
                                setState(() {
                                  loading = true;
                                });
                                Map<String, dynamic> response = await userprovider.loginGoogle();
                                setState(() {
                                  loading = false;
                                });
                                if (response['fail']) {
                                  Scaffold.of(context).showSnackBar(SnackBar(
                                    backgroundColor: Colors.red,
                                    content: Text(response['message']),
                                  ));
                                } else {
                                  Navigator.of(context).push(PageRouteBuilder(
                                    transitionDuration: Duration(seconds: 1),
                                    pageBuilder: (_, __, ___) => Home(user: userprovider.user),
                                  ));
                                }
                              },
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            TOSocialButton(
                              color: Color(0xFF1977F3),
                              texto: 'Facebook',
                              imagen: 'assets/facebook.png',
                              onTap: () async {
                                setState(() {
                                  loading = true;
                                });
                                Map<String, dynamic> response = await userprovider.loginfacebook();
                                setState(() {
                                  loading = false;
                                });
                                if (response['fail']) {
                                  Scaffold.of(context).showSnackBar(SnackBar(
                                    backgroundColor: Colors.red,
                                    content: Text(response['message']),
                                  ));
                                } else {
                                  Navigator.of(context).push(PageRouteBuilder(
                                    transitionDuration: Duration(seconds: 1),
                                    pageBuilder: (_, __, ___) => Home(user: userprovider.user),
                                  ));
                                }
                              },
                            ),
                          ],
                        ),
                        Padding(padding: EdgeInsets.only(top: 10)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 85.0),
                          child: Row(
                            children: <Widget>[
                              Platform.isAndroid == true
                                  ? SizedBox.shrink()
                                  : TOSocialButton(
                                      color: Color(0xFF000000),
                                      texto: 'Apple',
                                      imagen: 'assets/apple.png',
                                      onTap: () async {
                                        setState(() {
                                          loading = true;
                                        });
                                        Map<String, dynamic> response = await userprovider.loginApple();
                                        setState(() {
                                          loading = false;
                                        });
                                        if (response['fail']) {
                                          Scaffold.of(context).showSnackBar(SnackBar(
                                            backgroundColor: Colors.red,
                                            content: Text(response['message']),
                                          ));
                                        } else {
                                          Navigator.of(context).push(PageRouteBuilder(
                                            transitionDuration: Duration(seconds: 1),
                                            pageBuilder: (_, __, ___) => Home(user: userprovider.user),
                                          ));
                                        }
                                      },
                                    ),
                            ],
                          ),
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
                                      onPressed: () => {enviarform(context)},
                                      child: Row(
                                        children: <Widget>[
                                          Expanded(
                                            key: Key('login-button'),
                                            child: Center(
                                              child: !loading
                                                  ? Text(
                                                      'Iniciar Sesión',
                                                      style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white),
                                                    )
                                                  : SizedBox(
                                                      width: 20,
                                                      height: 20,
                                                      child: CircularProgressIndicator(
                                                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                                        strokeWidth: 3,
                                                      )),
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
                        Padding(padding: EdgeInsets.only(top: 20)),
                        InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => RecoverPassword()),
                              );
                            },
                            child: Text(
                              'Olvidaste la contraseña?',
                              style: TextStyle(color: Colors.white),
                            ))
                      ],
                    ),
                    Positioned(
                      child: Align(
                        alignment: FractionalOffset.bottomCenter,
                        child: FlatButton(
                          padding: EdgeInsets.all(0),
                          splashColor: Colors.transparent,
                          onPressed: () => {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => NewUser()),
                            )
                          },
                          child: Text.rich(
                            TextSpan(
                              text: 'No tienes usuario? ',
                              style: TextStyle(color: Colors.white),
                              children: <TextSpan>[
                                TextSpan(
                                    text: 'Registrate aquí',
                                    style: TextStyle(
                                      decoration: TextDecoration.underline,
                                    )),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
