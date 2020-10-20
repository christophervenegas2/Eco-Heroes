import 'package:flutter/material.dart';
import 'package:ecoheroes/ui/to_appbar.dart';
import 'package:ecoheroes/ui/to_listcard.dart';

class CompleteTask extends StatelessWidget {
  final complete, gettask;
  const CompleteTask({Key key, this.complete, this.gettask}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                TOAppBar(back: true),
                Expanded(
                  child: TOListCard(
                    task: complete,
                    gettask: gettask,
                    disablebutton: true,
                    tab: 0,
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
