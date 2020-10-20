import 'package:ecoheroes/const/contributions.dart';
import 'package:ecoheroes/const/custom_icon_icons.dart';
import 'package:ecoheroes/provider/userprovider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FootPrint extends StatelessWidget {
  const FootPrint({Key key}) : super(key: key);

  Widget _smallBox({String title, String subTitle, IconData icon, Color color, String value, double sizeicon}) {
    return Container(
        padding: EdgeInsets.only(left: 5, right: 5, bottom: 5),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(15),
            ),
            boxShadow: [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.16),
                blurRadius: 6,
                offset: Offset(0, 6),
              )
            ],
          ),
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
                  textScaleFactor: 1.0,
                ),
                Text(
                  subTitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.normal, color: Colors.grey[600], fontSize: 12),
                  textScaleFactor: 1.0,
                ),
                SizedBox(height: 10.0),
                ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: 40),
                  child: Icon(
                    icon,
                    color: color,
                    size: sizeicon,
                  ),
                ),
                SizedBox(height: 8.0),
                Text(
                  value,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
                  textScaleFactor: 1.0,
                ),
              ],
            ),
          ),
        ));
  }

  Widget _bigBox(String content) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(15),
        ),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.16),
            blurRadius: 6,
            offset: Offset(0, 6),
          )
        ],
      ),
      height: 75,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            CustomIcon.recycle,
            color: Color.fromRGBO(166, 229, 95, 1),
            size: 30,
          ),
          SizedBox(width: 20.0),
          Text(
            content,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            textScaleFactor: 1.0,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userprovider = Provider.of<UserProvider>(context);
    return Padding(
      padding: EdgeInsets.only(left: 15, right: 15),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: _bigBox('Total Residuos Reciclados\n${userprovider.contribution['recycledwaste'].toStringAsFixed(2)} Kg'),
          ),
          GridView.builder(
            padding: EdgeInsets.only(bottom: 15, top: 15),
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: footprint.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: 0.8,
              crossAxisCount: 3,
              mainAxisSpacing: 10,
              crossAxisSpacing: 8,
            ),
            itemBuilder: (BuildContext context, int index) {
              String indicator = userprovider.contribution[footprint[index]['db']].toStringAsFixed(1);
              return _smallBox(
                title: footprint[index]['title'],
                subTitle: footprint[index]['subtitle'],
                color: footprint[index]['color'],
                icon: footprint[index]['icon'],
                sizeicon: footprint[index]['sizeicon'],
                value: '${indicator[indicator.length - 1] != '0' ? indicator : indicator.substring(0, indicator.length - 2)} ${footprint[index]['unit']}',
              );
            },
          )
        ],
      ),
    );
  }
}
