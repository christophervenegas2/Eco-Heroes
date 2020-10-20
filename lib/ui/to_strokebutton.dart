import 'package:flutter/material.dart';

class TOStrokeButton extends StatelessWidget {
  final Text text;
  final Color color;
  final Function onPressed;

  const TOStrokeButton({Key key, this.text, this.color = Colors.blueAccent, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      decoration: BoxDecoration(
        border: Border.all(width: 4, color: Colors.white),
        borderRadius: BorderRadius.all(Radius.circular(100)),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.16),
            blurRadius: 6,
            offset: Offset(0, 6),
          )
        ],
      ),
      child: SizedBox(
        height: 45,
        child: FlatButton(
          color: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
          padding: EdgeInsets.all(0),
          onPressed: onPressed,
          child: Center(
            child: text
          ),
        ),
      ),
    );
  }
}
