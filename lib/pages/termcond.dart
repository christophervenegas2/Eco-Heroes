import 'package:flutter/material.dart';
import 'package:ecoheroes/pages/termandconditions.dart';
import 'package:ecoheroes/ui/to_colorbutton.dart';
import 'package:ecoheroes/ui/to_strokebutton.dart';

class TermCond extends StatelessWidget {
  final setterm;
  final Function createuser;
  final BuildContext contexto;

  const TermCond({Key key, this.setterm, this.createuser, this.contexto}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.16),
                  blurRadius: 6,
                  offset: Offset(0, 6),
                )
              ],
            ),
            child: Text.rich(
                TextSpan(
                  style: TextStyle(color: Colors.black),
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Para continuar debes aceptar los \n',
                    ),
                    TextSpan(
                      text: 'Terminos y Condiciones \n',
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    TextSpan(
                      text: 'de la aplicación',
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
                child: TOStrokeButton(
                  color: Color(0xFF4AD6C0),
                  text: Text(
                    'Leer Terminos y Condiciones',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => TermsConditions()));},
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 16),
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: TOColorButton(
                  text: Text('Aceptar', style: TextStyle(fontWeight: FontWeight.w700)),
                  onPressed: () {createuser(contexto);},
                  color: Color(0xFF163B4D),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 8),
              ),
              Expanded(
                child: TOStrokeButton(
                  text: Text('Rechazar', style:TextStyle(color:Colors.white)),
                  onPressed: () {
                    setterm(false);
                  },
                  color: Color(0xFF4AD6C0),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
