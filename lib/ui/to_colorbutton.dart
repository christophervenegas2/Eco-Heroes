import 'package:flutter/material.dart';

class TOColorButton extends StatelessWidget {
  final Color color;
  final Widget text;
  final Function onPressed;
  final Radius radius;
  final bool fixedheight;

  const TOColorButton({Key key, this.color, this.text, this.onPressed, this.radius = const Radius.circular(20), this.fixedheight = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(radius),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.16),
            blurRadius: 6,
            offset: Offset(0, 6),
          )
        ],
      ),
      child: SizedBox(
        height: fixedheight ? 46 : null,
        child: FlatButton(
          color: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(radius),
          ),
          padding: EdgeInsets.all(0),
          onPressed: onPressed,
          child: Center(child: text),
        ),
      ),
    );
  }
}
