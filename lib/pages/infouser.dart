import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecoheroes/provider/userprovider.dart';
import 'package:flutter/material.dart';
import 'package:ecoheroes/ui/to_appbar.dart';
import 'package:ecoheroes/ui/to_colorbutton.dart';
import 'package:ecoheroes/ui/to_textinput.dart';
import 'package:provider/provider.dart';

class InfoUser extends StatefulWidget {
  const InfoUser({Key key}) : super(key: key);
  @override
  _InfoUserState createState() => _InfoUserState();
}

class _InfoUserState extends State<InfoUser> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  var loadingall = true;
  var loading = false;
  var terms = false;
  var errores = {}, controllerform = {};

  var loginform = {
    'firstname': '',
    'lastname': '',
    'username': '',
    'instagram': '',
    'email': '',
  };

  var validator = {
    'firstname': RegExp(r'.*\S.*'),
    'lastname': RegExp(r'.*\S.*'),
    'username': RegExp(r'.*\S.*'),
    'instagram': RegExp(r''),
    'email': RegExp(r'.*\S.*'),
  };

  Future<void> getUser() async {
    final userprovider = Provider.of<UserProvider>(context, listen: false);
    await firestore.collection('users').doc(userprovider.userinfo['id']).get().then((value) => {
          userprovider.userinfo.addAll(value.data()),
        });
    initializateform(loginform);
    setState(() {
      loadingall = false;
    });
  }

  void initializateform(form, [dispose = false]) {
    final userprovider = Provider.of<UserProvider>(context, listen: false);
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
            controllerform[k].text = userprovider.userinfo[k] == null ? '' : userprovider.userinfo[k],
          }
      },
    );
  }

  void initState() {
    getUser();
    super.initState();
  }

  void dispose() {
    super.dispose();
    //initializateform(loginform, true);
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

  Map<String, dynamic> ischanged(form) {
    final userprovider = Provider.of<UserProvider>(context, listen: false);
    Map<String, dynamic> info = {};
    for (var i in form.keys) {
      if (form[i] != (userprovider.userinfo[i] == null ? '' : userprovider.userinfo[i])) {
        if (i == 'instagram') {
          info.addAll({'instagram_v': false});
        }
        info.addAll({i: form[i]});
      }
    }
    return (info);
  }

  void enviarform(context) {
    setState(() {
      loading = true;
    });
    if (validateform(loginform, validator, errores)) {
      var info = ischanged(loginform);
      if (info.keys.length > 0) {
        sendtodb(info, context);
      }
    }
  }

  Future<void> sendtodb(updatedata, context) async {
    final userprovider = Provider.of<UserProvider>(context, listen: false);
    try {
      await firestore.collection('users').doc(userprovider.userinfo['id']).update(updatedata);
      userprovider.userinfo.addAll(updatedata);
      Scaffold.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.blue,
        content: Text('Datos actualizados con exito'),
      ));
    } catch (e) {
      Scaffold.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        content: Text('Error, intenta más tarde'),
      ));
    }
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final userprovider = Provider.of<UserProvider>(context);
    return Scaffold(body: Builder(
      builder: (BuildContext context) {
        return (Container(
          height: double.infinity,
          child: Column(
            children: <Widget>[
              TOAppBar(
                back: true,
              ),
              loadingall
                  ? SizedBox(
                      height: 50,
                      width: 50,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Color(0xFF4AD6A7)),
                        strokeWidth: 3,
                      ))
                  : Expanded(
                      child: SingleChildScrollView(
                          child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20.0, 0, 0, 5),
                              child: Text('Nombres:'),
                            ),
                            TOTextInput(
                              error: errores['firstname'],
                              hinttext: 'Nombres...',
                              texterror: 'Ingrese nombres!',
                              value: controllerform['firstname'],
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20.0, 0, 0, 5),
                              child: Text('Apellidos:'),
                            ),
                            TOTextInput(
                              error: errores['lastname'],
                              hinttext: 'Apellidos...',
                              texterror: 'Ingrese apellidos!',
                              value: controllerform['lastname'],
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20.0, 0, 0, 5),
                              child: Text('Nombre de usuario:'),
                            ),
                            TOTextInput(
                              error: errores['username'],
                              hinttext: 'Nombre de usuario...',
                              texterror: 'Ingrese nombre de usuario!',
                              value: controllerform['username'],
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20.0, 0, 0, 5),
                              child: Text('Email:'),
                            ),
                            TOTextInput(
                              error: errores['email'],
                              hinttext: 'Email...',
                              enabled: false,
                              texterror: 'Ingrese email!',
                              value: controllerform['email'],
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20.0, 0, 0, 5),
                              child: Text('Instagram:'),
                            ),
                            TOTextInput(
                              error: errores['instagram'],
                              hinttext: '@Instagram...',
                              texterror: 'Ingrese su instagram!',
                              value: controllerform['instagram'],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(left: 20.0),
                                  child: Text('Instagram verificado'),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 20.0),
                                  child: userprovider.userinfo['instagram_v'] ? Icon(Icons.check) : Icon(Icons.close),
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 20),
                            ),
                            TOColorButton(
                              color: Color(0xFF4AD6A7),
                              onPressed: () {
                                enviarform(context);
                              },
                              text: loading
                                  ? Container(
                                      height: 18,
                                      width: 18,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 3,
                                        valueColor: AlwaysStoppedAnimation(Colors.white),
                                      ))
                                  : Text(
                                      'Actualizar Datos',
                                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                                    ),
                            )
                          ],
                        ),
                      )),
                    ),
            ],
          ),
        ));
      },
    ));
  }
}
