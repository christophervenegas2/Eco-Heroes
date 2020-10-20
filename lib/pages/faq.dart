import 'package:ecoheroes/pages/termandconditions.dart';
import 'package:flutter/material.dart';
import 'package:ecoheroes/const/faq.dart';
import 'package:ecoheroes/ui/to_appbar.dart';
import 'package:ecoheroes/ui/to_colorbutton.dart';

class FAQ extends StatelessWidget {
  const FAQ({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        child: Column(
          children: <Widget>[
            TOAppBar(
              back: true,
            ),
            Expanded(
              child: SingleChildScrollView(
                  child: Column(
                children: <Widget>[
                  html,
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20.0,20,20,0),
                    child: TOColorButton(
                      color: Color(0xFF163B4D),
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext build) => TermsConditions()));
                      },
                      text: Text('Terminos y Condiciones', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: TOColorButton(
                      color: Color(0xFF163B4D),
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext build) => LicensePage()));
                      },
                      text: Text('Licencias', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                    ),
                  ),
                ],
              )),
            ),
          ],
        ),
      ),
    );
  }
}
