import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecoheroes/lib/to_stories.dart';
import 'package:ecoheroes/pages/verifiedinstagram.dart';
import 'package:ecoheroes/provider/userprovider.dart';
import 'package:firebase_image/firebase_image.dart';
import 'package:flutter/material.dart';
import 'package:ecoheroes/ui/to_appbar.dart';
import 'package:ecoheroes/ui/to_colorbutton.dart';
import 'package:ecoheroes/ui/to_dialog.dart';
import 'package:ecoheroes/const/custom_icon_icons.dart';
import 'package:provider/provider.dart';

class DetailTask extends StatefulWidget {
  final String docid;
  final settabindex, gettask, names;

  const DetailTask({Key key, this.docid, this.settabindex, this.gettask, this.names}) : super(key: key);
  @override
  _DetailTaskState createState() => _DetailTaskState();
}

class _DetailTaskState extends State<DetailTask> {
  var loading = true;
  var task = {};
  var loadingbutton = false;
  bool go = false;
  List<Widget> images = [];
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  List storiescover = [];
  var batch;
  var temp = [];

  Future<void> getTask() async {
    await firestore.collection('tasks').doc(widget.docid).get().then((value) => {
          if (value.data()['status'] != 'active')
            {
              widget.gettask(0),
              Navigator.pop(context),
            }
          else
            {
              task.addAll({'id': value.id}),
              setState(
                () {
                  task = value.data();
                  loading = false;
                },
              ),
            }
        });
    if (task['stories_cover'] != null) {
      storiescover = task['stories_cover'];
    } else {
      task['stories'].forEach((t) => {storiescover.add(t['assets'])});
    }
  }

  List<Widget> geticonvalue() {
    List<Widget> widgets = [];
    if (task['icon'] == null) {
    } else if (task['icon'] == 'discount') {
      widgets.add(Icon(
        CustomIcon.discount,
        size: 13,
        color: Colors.white,
      ));
      widgets.add(Padding(
        padding: EdgeInsets.only(right: 2),
      ));
    } else if (task['icon'] == 'leaf') {
      widgets.add(Icon(
        CustomIcon.leaf,
        size: 13,
        color: Colors.white,
      ));
      widgets.add(Padding(
        padding: EdgeInsets.only(right: 2),
      ));
    } else if (task['icon'] == 'tree') {
      widgets.add(Icon(
        CustomIcon.tree_filled,
        size: 13,
        color: Colors.white,
      ));
      widgets.add(Padding(
        padding: EdgeInsets.only(right: 2),
      ));
    }
    if (task['text'] != null) {
      widgets.add(Text(task['text'], textScaleFactor: 1.0, style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white)));
    }
    return widgets;
  }

  void initState() {
    super.initState();
    getTask();
  }

  void dispose() {
    super.dispose();
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
            loading
                ? Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Color(0xFF4AD6A7)),
                      strokeWidth: 3,
                    ),
                  )
                : Expanded(
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
                                            'gs://ecoheroes-app.appspot.com/tasks/' + task['cover'],
                                            shouldCache: true, // The image should be cached (default: True)
                                            maxSizeBytes: 3000 * 1000, // 3MB max file size (default: 2.5MB)
                                            cacheRefreshStrategy: CacheRefreshStrategy.BY_METADATA_DATE, // Switch off update checking
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
                                                        task['name'],
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
                                                            task['location'],
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
                            Padding(
                              padding: EdgeInsets.only(bottom: 13),
                            ),
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
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[Text('Descripción del desafío', style: TextStyle(fontWeight: FontWeight.w700)), Padding(padding: EdgeInsets.only(bottom: 13)), Text(task['description'].toString().replaceAll('\\n', '\n'))],
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 13),
                            ),
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
                              child: InkWell(
                                onTap: () => {
                                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => ToStories(contenido: List<Map<String, dynamic>>.from(task['stories'])))),
                                },
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.only(topLeft: Radius.circular(15), bottomLeft: Radius.circular(15)),
                                        child: Image(
                                          alignment: Alignment.topCenter,
                                          fit: BoxFit.fitWidth,
                                          height: 80,
                                          image: FirebaseImage(
                                            'gs://ecoheroes-app.appspot.com/tasks/' + storiescover[0],
                                            shouldCache: true, // The image should be cached (default: True)
                                            maxSizeBytes: 3000 * 1000, // 3MB max file size (default: 2.5MB)
                                            cacheRefreshStrategy: CacheRefreshStrategy.BY_METADATA_DATE, // Switch off update checking
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Image(
                                        alignment: Alignment.topCenter,
                                        fit: BoxFit.fitWidth,
                                        height: 80,
                                        image: FirebaseImage(
                                          'gs://ecoheroes-app.appspot.com/tasks/' + storiescover[1],
                                          shouldCache: true, // The image should be cached (default: True)
                                          maxSizeBytes: 3000 * 1000, // 3MB max file size (default: 2.5MB)
                                          cacheRefreshStrategy: CacheRefreshStrategy.BY_METADATA_DATE, // Switch off update checking
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Image(
                                        alignment: Alignment.topCenter,
                                        fit: BoxFit.fitWidth,
                                        height: 80,
                                        image: FirebaseImage(
                                          'gs://ecoheroes-app.appspot.com/tasks/' + storiescover[2],
                                          shouldCache: true, // The image should be cached (default: True)
                                          maxSizeBytes: 3000 * 1000, // 3MB max file size (default: 2.5MB)
                                          cacheRefreshStrategy: CacheRefreshStrategy.BY_METADATA_DATE, // Switch off update checking
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.only(topRight: Radius.circular(15), bottomRight: Radius.circular(15)),
                                        child: Image(
                                          alignment: Alignment.topCenter,
                                          fit: BoxFit.fitWidth,
                                          height: 80,
                                          image: FirebaseImage(
                                            'gs://ecoheroes-app.appspot.com/tasks/' + storiescover[3],
                                            shouldCache: true, // The image should be cached (default: True)
                                            maxSizeBytes: 3000 * 1000, // 3MB max file size (default: 2.5MB)
                                            cacheRefreshStrategy: CacheRefreshStrategy.BY_METADATA_DATE, // Switch off update checking
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 13),
                            ),
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
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text('Auspiciador', style: TextStyle(fontWeight: FontWeight.w700)),
                                    Padding(padding: EdgeInsets.only(bottom: 13)),
                                    Center(
                                      child: Image(
                                        alignment: Alignment.topCenter,
                                        fit: BoxFit.fitWidth,
                                        width: 140,
                                        image: FirebaseImage(
                                          'gs://ecoheroes-app.appspot.com/tasks/' + task['sponsor'],
                                          shouldCache: true, // The image should be cached (default: True)
                                          maxSizeBytes: 3000 * 1000, // 3MB max file size (default: 2.5MB)
                                          cacheRefreshStrategy: CacheRefreshStrategy.BY_METADATA_DATE, // Switch off update checking
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 13),
                            ),
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(Radius.circular(15)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color.fromRGBO(0, 0, 0, 0.16),
                                    blurRadius: 6,
                                    offset: Offset(0, 0),
                                  )
                                ],
                              ),
                              child: IntrinsicHeight(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(20.0, 20, 10, 20),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text('Recompensa', style: TextStyle(fontWeight: FontWeight.w700)),
                                            InkWell(
                                              onTap: () {
                                                var text = task['aboutget'];
                                                var widget = Row(
                                                  children: <Widget>[
                                                    Icon(
                                                      Icons.help_outline,
                                                      color: Color(0xFFDF2126),
                                                      size: 35,
                                                    ),
                                                    Padding(padding: EdgeInsets.only(right: 10)),
                                                    Expanded(
                                                      child: Text(
                                                        text,
                                                        textAlign: TextAlign.center,
                                                        textScaleFactor: 1.0,
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontFamily: 'Proxima Nova',
                                                          decoration: TextDecoration.none,
                                                          fontWeight: FontWeight.w500,
                                                          fontSize: 15,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                );
                                                showDialogTO(context, widget);
                                              },
                                              child: Icon(
                                                Icons.help_outline,
                                                color: Color(0xFFDF2126),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: double.infinity,
                                      decoration: BoxDecoration(
                                        color: Color(0xFFDF2126),
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(15),
                                          bottomRight: Radius.circular(15),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(20),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: geticonvalue(),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 13),
                            ),
                            TOColorButton(
                              color: Color(0xFF163B4D),
                              onPressed: loadingbutton
                                  ? () {}
                                  : () async => {
                                        if (!userprovider.userinfo['instagram_v'])
                                          {
                                            await firestore.collection('users').doc(userprovider.userinfo['id']).get().then((value) => {
                                                  userprovider.userinfo.addAll(value.data()),
                                                })
                                          },
                                        if (!userprovider.userinfo['instagram_v'])
                                          {
                                            showDialogTO(
                                              context,
                                              Column(
                                                children: <Widget>[
                                                  Row(
                                                    children: <Widget>[
                                                      Icon(
                                                        Icons.error_outline,
                                                        color: Color(0xFFDF2126),
                                                        size: 35,
                                                      ),
                                                      Padding(padding: EdgeInsets.only(right: 10)),
                                                      Expanded(
                                                        child: Text(
                                                          'Para participar en un desafio debes verificar tu cuenta de instagram!',
                                                          textAlign: TextAlign.center,
                                                          textScaleFactor: 1.0,
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontFamily: 'Proxima Nova',
                                                            decoration: TextDecoration.none,
                                                            fontWeight: FontWeight.w500,
                                                            fontSize: 15,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Padding(padding: EdgeInsets.only(bottom: 20)),
                                                  Row(
                                                    children: <Widget>[
                                                      Expanded(
                                                        child: TOColorButton(
                                                          onPressed: () {
                                                            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => VIntragram()));
                                                          },
                                                          color: Color(0xFFDF2126),
                                                          text: Text('Ir a verificar', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                                                        ),
                                                      )
                                                    ],
                                                  )
                                                ],
                                              ),
                                            )
                                          }
                                        else
                                          {
                                            go = false,
                                            setState(() {
                                              loadingbutton = true;
                                            }),
                                            if (task['maxstart'] != null)
                                              {
                                                if ((task['counterstart'] == null ? 0 : task['counterstart']) < task['maxstart'])
                                                  {
                                                    go = true,
                                                  }
                                                else
                                                  {
                                                    showDialogTO(
                                                      context,
                                                      Column(
                                                        children: <Widget>[
                                                          Row(
                                                            children: <Widget>[
                                                              Icon(
                                                                Icons.error_outline,
                                                                color: Color(0xFFDF2126),
                                                                size: 35,
                                                              ),
                                                              Padding(padding: EdgeInsets.only(right: 10)),
                                                              Expanded(
                                                                child: Text(
                                                                  'Ya no quedan cupones para este desafio!',
                                                                  textAlign: TextAlign.center,
                                                                  textScaleFactor: 1.0,
                                                                  style: TextStyle(
                                                                    color: Colors.black,
                                                                    fontFamily: 'Proxima Nova',
                                                                    decoration: TextDecoration.none,
                                                                    fontWeight: FontWeight.w500,
                                                                    fontSize: 15,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    temp = [],
                                                    await firestore.collection('task-active').doc('active').get().then((value) => {
                                                          temp = value.data()['task'],
                                                          temp.asMap().forEach((index, t) {
                                                            if (t['id'] == widget.docid) {
                                                              temp[index]['status'] = 'disabled';
                                                            }
                                                          }),
                                                          if (temp.length == value.data()['task'].length)
                                                            {
                                                              firestore.collection('task-active').doc('active').update({'task': temp})
                                                            }
                                                        }),
                                                    go = false,
                                                    widget.gettask(0),
                                                    Timer(Duration(seconds: 1), () {
                                                      if (mounted) {
                                                        setState(() {
                                                          loadingbutton = false;
                                                        });
                                                      }
                                                    }),
                                                  }
                                              }
                                            else
                                              {
                                                go = true,
                                              },
                                            if (widget.names.contains(task['name']))
                                              {
                                                showDialogTO(
                                                  context,
                                                  Column(
                                                    children: <Widget>[
                                                      Row(
                                                        children: <Widget>[
                                                          Icon(
                                                            Icons.error_outline,
                                                            color: Color(0xFFDF2126),
                                                            size: 35,
                                                          ),
                                                          Padding(padding: EdgeInsets.only(right: 10)),
                                                          Expanded(
                                                            child: Text(
                                                              'No puedes participar en 2 desafios del mismo tipo en el mismo momento!',
                                                              textAlign: TextAlign.center,
                                                              textScaleFactor: 1.0,
                                                              style: TextStyle(
                                                                color: Colors.black,
                                                                fontFamily: 'Proxima Nova',
                                                                decoration: TextDecoration.none,
                                                                fontWeight: FontWeight.w500,
                                                                fontSize: 15,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                go = false,
                                                widget.gettask(0),
                                                Timer(Duration(seconds: 1), () {
                                                  if (mounted) {
                                                    setState(() {
                                                      loadingbutton = false;
                                                    });
                                                  }
                                                }),
                                              },
                                            if (go)
                                              {
                                                await firestore.collection('users').doc(userprovider.userinfo['id']).collection('tasks').where('id', isEqualTo: widget.docid).get().then((value) async => {
                                                      if (value.docs.isEmpty)
                                                        {
                                                          task['id'] = widget.docid,
                                                          task['status'] = 'wip',
                                                          task['fechainicio'] = Timestamp.now(),
                                                          batch = firestore.batch(),
                                                          batch.setData(firestore.collection('users').doc(userprovider.userinfo['id']).collection('tasks').doc(), task),
                                                          batch.update(firestore.collection('tasks').doc(task['id']), {'counterstart': FieldValue.increment(1)}),
                                                          batch.commit(),
                                                          widget.gettask(1),
                                                          Timer(Duration(seconds: 1), () {
                                                            if (mounted) {
                                                              setState(() {
                                                                loadingbutton = false;
                                                              });
                                                            }
                                                          }),
                                                          Navigator.pop(context),
                                                        }
                                                      else
                                                        {
                                                          widget.settabindex(1),
                                                          Timer(Duration(seconds: 1), () {
                                                            if (mounted) {
                                                              setState(() {
                                                                loadingbutton = false;
                                                              });
                                                            }
                                                          }),
                                                          Navigator.pop(context),
                                                        }
                                                    })
                                              }
                                          },
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
                                      'Comenzar Desafio',
                                      style: TextStyle(fontWeight: FontWeight.w700),
                                    ),
                            )
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
