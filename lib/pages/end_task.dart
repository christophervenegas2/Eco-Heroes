import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecoheroes/pages/detail_end_task.dart';
import 'package:ecoheroes/provider/userprovider.dart';
import 'package:firebase_image/firebase_image.dart';
import 'package:flutter/material.dart';
import 'package:ecoheroes/const/custom_icon_icons.dart';
import 'package:ecoheroes/ui/to_appbar.dart';
import 'package:ecoheroes/ui/to_colorbutton.dart';
import 'package:ecoheroes/ui/to_textinput.dart';
import 'package:badges/badges.dart';
import 'package:provider/provider.dart';

class EndTask extends StatefulWidget {
  final settabindex, gettask, task, docid;

  const EndTask({Key key, this.settabindex, this.gettask, this.task, this.docid}) : super(key: key);
  @override
  _EndTaskState createState() => _EndTaskState();
}

class _EndTaskState extends State<EndTask> {
  String direction = '';
  bool error = false;
  TextEditingController controller = TextEditingController();
  var indicators = {};
  var loadingbutton = false;
  var check = false;
  Map<String, dynamic> newinfo = {};
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  var indicatorsname = [];
  var badges = {};

  void initBadges() {
    indicatorsname.asMap().forEach((index, element) {
      badges.addAll({element: 0});
    });
  }

  void initState() {
    super.initState();
    indicatorsname = widget.task['countersname'] == null ? [] : widget.task['countersname'];
    initBadges();
    controller.addListener(() {
      setState(() {
        direction = controller.text;
      });
    });
  }

  void dispose() {
    controller.dispose();
    super.dispose();
  }

  List<Widget> indicatorsbuild() {
    List<Widget> indicators = [];
    indicatorsname.forEach((element) {
      indicators.add(Padding(
        padding: const EdgeInsets.all(5),
        child: Badge(
          animationType: BadgeAnimationType.fade,
          badgeContent: Text(
            badges[element.replaceAll('\n', ' ')].toString(),
            style: TextStyle(color: Colors.white),
          ),
          showBadge: badges[element.replaceAll('\n', ' ')] == 0 ? false : true,
          position: BadgePosition.topEnd(end: -5, top: -9),
          padding: EdgeInsets.all(8),
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(15),
              ),
              boxShadow: [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.16),
                  blurRadius: 6,
                  offset: Offset(0, 0),
                )
              ],
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14.0),
                    child: Text(
                      element,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                  Padding(padding: EdgeInsetsDirectional.only(bottom: 10)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          setState(() {
                            badges[element.replaceAll('\n', ' ')] = badges[element.replaceAll('\n', ' ')] == 0
                                ? 0
                                : badges[element.replaceAll('\n', ' ')] - 1;
                          });
                        },
                        child: Icon(
                          Icons.remove,
                          color: Color(0xFFDF2126),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 15),
                      ),
                      InkWell(
                          onTap: () {
                            setState(() {
                              badges[element.replaceAll('\n', ' ')] = badges[element.replaceAll('\n', ' ')] + 1;
                            });
                          },
                          child: Icon(Icons.add, color: Color(0xFF163B4D)))
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ));
    });
    return indicators;
  }

  @override
  Widget build(BuildContext context) {
    final userprovider = Provider.of<UserProvider>(context);
    return Scaffold(
      body: Container(
        child: Column(
          children: <Widget>[
            TOAppBar(
              back: true,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
                  child: Column(
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(
                            Radius.circular(15),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromRGBO(0, 0, 0, 0.16),
                              blurRadius: 6,
                              offset: Offset(0, 0),
                            )
                          ],
                        ),
                        height: 110,
                        child: Stack(
                          children: <Widget>[
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  child: Image(
                                    image: FirebaseImage(
                                      'gs://ecoheroes-app.appspot.com/tasks/' + widget.task['cover'],
                                      shouldCache: true, // The image should be cached (default: True)
                                      maxSizeBytes: 3000 * 1000, // 3MB max file size (default: 2.5MB)
                                      cacheRefreshStrategy:
                                          CacheRefreshStrategy.BY_METADATA_DATE, // Switch off update checking
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    child: Padding(
                                      padding: const EdgeInsets.all(13),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Container(
                                                child: Text(
                                                  widget.task['name'],
                                                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                                                  textScaleFactor: 1.0,
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(top: 5),
                                              ),
                                              Container(
                                                child: Row(
                                                  children: <Widget>[
                                                    Icon(
                                                      Icons.location_on,
                                                      color: Color(0xFFDF2126),
                                                      size: 15,
                                                    ),
                                                    Text(
                                                      widget.task['location'],
                                                      style: TextStyle(fontSize: 10),
                                                      textScaleFactor: 1.0,
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      check || widget.task['status'] == 'revision'
                          ? Column(
                              children: <Widget>[
                                Padding(padding: EdgeInsets.only(bottom: 40)),
                                Icon(CustomIcon.check_outline_circle, size: 120, color: Color(0xFF163B4D)),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
                                  child: Text(
                                      'Muy bien!, has terminado el desafío, pasará al estado "Revisión".\n\nDentro de 24 horas nuestro equipo comprobará que reportaste el desafío y se te cargará tu recompensa en la sección "Mis Cupones" de tu Perfil en la App.',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontWeight: FontWeight.w700)),
                                )
                              ],
                            )
                          : Column(
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(bottom: 13),
                                ),
                                Container(
                                    width: double.infinity,
                                    padding: EdgeInsets.only(left: 13),
                                    child: Text('Donde realizaste el desafío:',
                                        style: TextStyle(fontWeight: FontWeight.w700))),
                                Padding(
                                  padding: EdgeInsets.only(bottom: 13),
                                ),
                                Container(
                                  child: TOTextInput(
                                    hinttext: 'Comuna...',
                                    borderRadius: BorderRadius.circular(15),
                                    offset: Offset(0, 0),
                                    icon: Icon(Icons.location_on, color: Color(0xFFDF2126)),
                                    error: error,
                                    value: controller,
                                    texterror: 'Debes ingresar la comuna',
                                  ),
                                ),
                                Container(
                                    width: double.infinity,
                                    padding: EdgeInsets.only(left: 13),
                                    child: Text('Reporta tu desafío', style: TextStyle(fontWeight: FontWeight.w700))),
                                Padding(padding: EdgeInsets.only(bottom: 13)),
                                widget.task['report'] == null
                                    ? SizedBox.shrink()
                                    : Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(15),
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Color.fromRGBO(0, 0, 0, 0.16),
                                              blurRadius: 6,
                                              offset: Offset(0, 0),
                                            )
                                          ],
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(20.0),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(widget.task['report'].toString().replaceAll('\\n', '\n'))
                                            ],
                                          ),
                                        ),
                                      ),
                                Padding(
                                  padding: EdgeInsets.only(bottom: 20),
                                ),
                                ((widget.task['counters'] == false) || (widget.task['counters'] == null))
                                    ? SizedBox.shrink()
                                    : Container(
                                        child: GridView.count(
                                          padding: EdgeInsets.zero,
                                          crossAxisCount: 3,
                                          shrinkWrap: true,
                                          crossAxisSpacing: 0,
                                          mainAxisSpacing: 0,
                                          physics: NeverScrollableScrollPhysics(),
                                          children: indicatorsbuild(),
                                        ),
                                      ),
                                Padding(
                                  padding: EdgeInsets.only(bottom: 20),
                                ),
                                TOColorButton(
                                  color: Color(0xFF46DAA4),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (BuildContext context) => DetailEndTask(
                                                  task: widget.task,
                                                )));
                                  },
                                  radius: Radius.circular(100),
                                  text: Text(
                                    'Ver Desafio',
                                    style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(bottom: 20),
                                ),
                                TOColorButton(
                                  color: Color(0xFF163B4D),
                                  onPressed: loadingbutton
                                      ? () {}
                                      : () async => {
                                            if (direction == '')
                                              {
                                                setState(() {
                                                  error = true;
                                                })
                                              }
                                            else
                                              {
                                                setState(() {
                                                  loadingbutton = true;
                                                  error = false;
                                                }),
                                                await firestore
                                                    .collection('users')
                                                    .doc(userprovider.userinfo['id'])
                                                    .collection('tasks')
                                                    .where('id', isEqualTo: widget.task['id'])
                                                    .get()
                                                    .then(
                                                      (value) async => {
                                                        if (value.docs.length == 1)
                                                          {
                                                            newinfo.addAll({
                                                              'status': 'revision',
                                                              'direction': direction,
                                                              'fechatermino': Timestamp.now(),
                                                            }),
                                                            if (widget.task['counters'] == true)
                                                              {
                                                                newinfo.addAll({'counters': badges})
                                                              },
                                                            await firestore
                                                                .collection('users')
                                                                .doc(userprovider.userinfo['id'])
                                                                .collection('tasks')
                                                                .doc(value.docs.single.id)
                                                                .update(newinfo)
                                                                .then((value) => {
                                                                      widget.gettask(2),
                                                                      Timer(Duration(seconds: 1), () {
                                                                        if (mounted) {
                                                                          setState(() {
                                                                            loadingbutton = false;
                                                                            check = true;
                                                                          });
                                                                        }
                                                                      }),
                                                                      Timer(Duration(seconds: 20), () {
                                                                        Navigator.pop(context);
                                                                      }),
                                                                    }),
                                                          }
                                                      },
                                                    ),
                                              }
                                          },
                                  radius: Radius.circular(50),
                                  text: loadingbutton
                                      ? Container(
                                          height: 18,
                                          width: 18,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 3,
                                            valueColor: AlwaysStoppedAnimation(Colors.white),
                                          ))
                                      : Text(
                                          'Terminar desafío',
                                          style: TextStyle(fontWeight: FontWeight.w700),
                                        ),
                                )
                              ],
                            ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
