import 'package:ecoheroes/const/custom_icon_icons.dart';
import 'package:ecoheroes/pages/faq.dart';
import 'package:ecoheroes/pages/infouser.dart';
import 'package:ecoheroes/pages/login_page.dart';
import 'package:ecoheroes/pages/support.dart';
import 'package:ecoheroes/ui/to_colorbutton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileSettings extends StatelessWidget {
  const ProfileSettings({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                      child: AspectRatio(
                    aspectRatio: 1 / 1,
                    child: TOColorButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => InfoUser()));
                        },
                        fixedheight: false,
                        color: Color(0xFF163B4D),
                        text: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(CustomIcon.profile, size: 40),
                            Padding(padding: EdgeInsets.only(bottom: 10)),
                            Text(
                              'Información \nUsuario',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                          ],
                        )),
                  )),
                  Padding(padding: EdgeInsets.only(right: 20)),
                  Expanded(
                      child: AspectRatio(
                    aspectRatio: 1 / 1,
                    child: TOColorButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => FAQ()));
                        },
                        fixedheight: false,
                        color: Color(0xFF163B4D),
                        text: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(CustomIcon.faq, size: 40),
                            Padding(padding: EdgeInsets.only(bottom: 10)),
                            Text(
                              'FAQ',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                          ],
                        )),
                  )),
                ],
              ),
              Padding(padding: EdgeInsets.only(bottom: 20)),
              Row(
                children: <Widget>[
                  Expanded(
                      child: AspectRatio(
                    aspectRatio: 2 / 1,
                    child: TOColorButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Support()));
                        },
                        fixedheight: false,
                        color: Color(0xFF163B4D),
                        text: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(CustomIcon.support, size: 40),
                            Padding(padding: EdgeInsets.only(bottom: 10)),
                            Text(
                              'Soporte',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                          ],
                        )),
                  )),
                ],
              ),
            ],
          ),
        ),
        GestureDetector(
            onTap: () {
              _auth.signOut().then(
                    (value) => {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      )
                    },
                  );
            },
            child: Text('Cerrar Sesión', style: TextStyle(color: Colors.grey))),
        Padding(padding: EdgeInsets.only(bottom: 20)),
      ],
    );
  }
}
