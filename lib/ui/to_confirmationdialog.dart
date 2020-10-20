import 'package:flutter/material.dart';
import 'package:ecoheroes/ui/to_colorbutton.dart';
import 'package:ecoheroes/ui/to_strokebutton.dart';

Future<bool> showConfirmationDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return Padding(
        padding: const EdgeInsets.all(20.0),
        child: (Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
              child: Text.rich(
                  TextSpan(
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Proxima Nova',
                      decoration: TextDecoration.none,
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: '¿Estas seguro que deseas',
                      ),
                      TextSpan(
                        text: ' eliminar ',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      TextSpan(
                        text: 'este desafío?',
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 16),
            ),
            Row(
              children: <Widget>[
                Expanded(
                    child: TOColorButton(
                  color: Color(0xFFDF2126),
                  text: Text(
                    'No',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  onPressed: () => {
                    Navigator.pop(context, false)
                  },
                )),
                Padding(
                  padding: EdgeInsets.only(right: 8),
                ),
                Expanded(
                  child: TOStrokeButton(
                    color: Colors.transparent,
                    text: Text('Sí', style: TextStyle(fontWeight: FontWeight.w700)),
                    onPressed: () => {
                      Navigator.pop(context, true)
                    },
                  ),
                )
              ],
            )
          ],
        )),
      );
    },
  );
}
