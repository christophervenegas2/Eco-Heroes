import 'package:flutter/material.dart';

class TOTextInput extends StatelessWidget {
  final String texterror, hinttext;
  final bool password, error, enabled;
  final TextEditingController value;
  final BorderRadius borderRadius;
  final TextInputType teclado;
  final Offset offset;
  final Icon icon;

  TOTextInput({Key key, this.offset = const Offset(0, 6), this.hinttext, this.password = false, this.texterror = '', this.error = false, this.teclado, this.borderRadius = const BorderRadius.all(Radius.circular(50)), this.icon, this.value, this.enabled = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: borderRadius,
              color: Colors.white,
              border: Border.all(color: error ? Colors.red[400] : Colors.transparent, width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.16),
                  blurRadius: 6,
                  offset: offset,
                )
              ],
            ),
            child: Row(
              children: <Widget>[
                icon == null
                    ? SizedBox()
                    : Container(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: icon,
                        ),
                      ),
                Expanded(
                  child: Container(
                    child: TextField(
                      enabled: this.enabled,
                      controller: value,
                      keyboardType: this.teclado,
                      obscureText: password,
                      decoration: InputDecoration(
                        hintText: hinttext,
                        fillColor: Colors.transparent,
                        contentPadding: EdgeInsets.only(left: icon == null ? 30.0 : 0),
                        hintStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w300),
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: borderRadius,
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 30, top: 5),
            width: double.infinity,
            child: !error ? null : Text(texterror, textAlign: TextAlign.start, style: TextStyle(color: Color(0xFFDF2126))),
          ),
        ],
      ),
    );
  }
}
