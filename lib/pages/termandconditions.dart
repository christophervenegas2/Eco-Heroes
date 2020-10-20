import 'package:flutter/material.dart';
import 'package:ecoheroes/const/termandcond.dart';
import 'package:ecoheroes/ui/to_appbar.dart';

class TermsConditions extends StatelessWidget {
  const TermsConditions({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (BuildContext context) {
      return (Scaffold(
        body: Container(
          height: double.infinity,
          child: Column(
            children: <Widget>[
              TOAppBar(
                back: true,
              ),
              Expanded(
                child: SingleChildScrollView(child: html),
              ),
            ],
          ),
        ),
      ));
    });
  }
}
