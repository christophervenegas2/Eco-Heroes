import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ecoheroes/ui/to_textinput.dart';
import 'package:vector_math/vector_math.dart' as vectormath;
import '../ui/to_textinput.dart';

class RecoverPassword extends StatefulWidget {
  @override
  _RecoverPasswordState createState() => _RecoverPasswordState();
}

class _RecoverPasswordState extends State<RecoverPassword> {
  var loading = false;
  var errores = {}, controllerform = {};

  User user;
  var loginform = {
    'email': '',
  };

  var validator = {
    'email': RegExp(r'.*\S.*'),
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

  Future<void> enviarform(context) async {
    setState(() {
      loading = true;
    });
    var errorMessage;
    if (validateform(loginform, validator, errores)) {
      try {
        await FirebaseAuth.instance.sendPasswordResetEmail(email: loginform['email']);
      } catch (e) {
        switch (e.code) {
          case "ERROR_USER_NOT_FOUND":
            errorMessage = 'Usuario no encontrado';
            break;
          case "ERROR_INVALID_EMAIL":
            errorMessage = 'Email invalido';
            break;
          default:
            errorMessage = 'Hubo un error, intenta más tarde';
        }
        if (errorMessage != null) {
          Scaffold.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.red,
            content: Text(errorMessage),
          ));
        }
        setState(() {
          loading = false;
        });
        return;
      }
      errorMessage = 'Revisa el correo para restablecer la contraseña';
      if (errorMessage != null) {
        Scaffold.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.blue,
          content: Text(errorMessage),
        ));
      }
      setState(() {
        loading = false;
      });
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
            child: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 20),
                  child: Stack(
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          TOTextInput(
                            hinttext: 'Correo Electrónico',
                            value: controllerform['email'],
                            error: errores['email'],
                            texterror: 'Revisar el correo electronico',
                            teclado: TextInputType.emailAddress,
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
                                        color: Color(0xFF4AD6B4),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(100),
                                        ),
                                        padding: EdgeInsets.all(0),
                                        onPressed: loading
                                            ? null
                                            : () => {
                                                  enviarform(context),
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
                                                        'Recuperar Contraseña',
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
