import 'package:flutter/material.dart';

class TOSocialButton extends StatelessWidget {
  final String imagen;
  final String texto;
  final Color color;
  final Function onTap;

  TOSocialButton({this.imagen, this.texto, this.color, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.16),
              blurRadius: 6,
              offset: Offset(0, 6),
            )
          ],
        ),
        child: SizedBox(
          height: 46,
          child: FlatButton(
            color: color,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100),
            ),
            padding: EdgeInsets.all(0),
            onPressed: onTap,
            child: Row(
              children: <Widget>[
                Image.asset(imagen),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Center(
                      child: Text(
                        texto,
                        style: TextStyle(
                            fontWeight: FontWeight.w400, color: Colors.white),
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
  }
}