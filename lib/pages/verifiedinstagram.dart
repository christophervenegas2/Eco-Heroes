import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecoheroes/provider/userprovider.dart';
import 'package:flutter/material.dart';
import 'package:ecoheroes/ui/to_appbar.dart';
import 'package:ecoheroes/ui/to_colorbutton.dart';
import 'package:ecoheroes/ui/to_textinput.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class VIntragram extends StatefulWidget {
  VIntragram({Key key}) : super(key: key);

  @override
  _VIntragramState createState() => _VIntragramState();
}

class _VIntragramState extends State<VIntragram> {
  var error = false;
  var controller = TextEditingController();
  var instagram = '';
  var loading = false;
  var verificado = '';

  void initState() {
    final userprovider = Provider.of<UserProvider>(context, listen: false);
    controller.addListener(() {
      setState(() {
        instagram = controller.text;
      });
    });
    if (userprovider.userinfo['instagram'] != null) {
      setState(() {
        controller.text = userprovider.userinfo['instagram'];
      });
    }
    super.initState();
  }

  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<http.Response> fetchPost(String user) {
    user = user.replaceAll('@', '');
    return http.get('https://instagram.com/$user');
  }

  @override
  Widget build(BuildContext context) {
    final userprovider = Provider.of<UserProvider>(context);
    return (Scaffold(
      body: Container(
        child: Stack(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                TOAppBar(
                  back: true,
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: <Widget>[
                      TOTextInput(
                        error: error,
                        hinttext: 'Cuenta de Instagram',
                        texterror: 'Ingrese cuenta de instagram',
                        value: controller,
                      ),
                      TOColorButton(
                        color: Color(0xFF4AD6A7),
                        text: loading
                            ? Container(
                                height: 18,
                                width: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 3,
                                  valueColor: AlwaysStoppedAnimation(Colors.white),
                                ))
                            : Text('Verificar Instagram', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                        onPressed: loading
                            ? () {}
                            : () async {
                                if (instagram == '') {
                                  setState(() {
                                    error = true;
                                  });
                                } else {
                                  setState(() {
                                    loading = true;
                                  });
                                  await fetchPost(instagram).then((value) => {
                                        if (value.statusCode == 200)
                                          {
                                            FirebaseFirestore.instance.collection('users').doc(userprovider.userinfo['id']).update({'instagram': instagram.replaceAll('@', ''), 'instagram_v': true}).then((value) => {
                                                  setState(() {
                                                    verificado = 'Instagram verificado correctamente';
                                                    loading = false;
                                                  }),
                                                  userprovider.userinfo.addAll({'instagram': instagram.replaceAll('@', ''), 'instagram_v': true}),
                                                }),
                                          }
                                        else
                                          {
                                            setState(() {
                                              verificado = 'No se pudo verificar tu instagram, por favor verifique el texto e intente nuevamente';
                                              loading = false;
                                            }),
                                          }
                                      });
                                }
                              },
                      ),
                      Padding(padding: EdgeInsets.only(bottom: 20)),
                      Text(
                        verificado,
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ));
  }
}
