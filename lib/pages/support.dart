import 'package:flutter/material.dart';
import 'package:ecoheroes/ui/to_appbar.dart';

class Support extends StatelessWidget {
  const Support({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            TOAppBar(back: true),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: <Widget>[
                    Icon(Icons.help_outline, size: 100,color: Color(0xFF163B4D)),
                    Padding(padding: EdgeInsets.only(bottom: 40)),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: TextStyle(fontFamily: 'Proxima Nova', color: Colors.black, fontSize: 17),
                        children: <TextSpan>[
                          TextSpan(text: 'Si tienes cualquier otra duda o comentario, favor escríbenos a '),
                          TextSpan(text: 'contacto@ecoheroes.cl', style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(text: '\n\nPuedes escribirnos también directamente a los fundadores de EcoHeroes quienes responderán personalmente:\n\n'),
                          TextSpan(text: 'tomas.alonso@ecoheroes.cl\njorge.alonso@ecoheroes.cl', style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
