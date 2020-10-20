import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecoheroes/lib/to_stories.dart';
import 'package:firebase_image/firebase_image.dart';
import 'package:flutter/material.dart';
import 'package:ecoheroes/ui/to_appbar.dart';
import 'package:ecoheroes/ui/to_dialog.dart';
import 'package:ecoheroes/const/custom_icon_icons.dart';

class DetailEndTask extends StatefulWidget {
  final task;

  const DetailEndTask({Key key, this.task}) : super(key: key);
  @override
  _DetailEndTaskState createState() => _DetailEndTaskState();
}

class _DetailEndTaskState extends State<DetailEndTask> {
  var loading = true;
  var loadingbutton = false;
  List<Widget> images = [];
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  var storiescover;

  List<Widget> geticonvalue() {
    List<Widget> widgets = [];
    if (widget.task['icon'] == null) {
    } else if (widget.task['icon'] == 'discount') {
      widgets.add(Icon(
        CustomIcon.discount,
        size: 13,
        color: Colors.white,
      ));
      widgets.add(Padding(
        padding: EdgeInsets.only(right: 2),
      ));
    } else if (widget.task['icon'] == 'leaf') {
      widgets.add(Icon(
        CustomIcon.leaf,
        size: 13,
        color: Colors.white,
      ));
      widgets.add(Padding(
        padding: EdgeInsets.only(right: 2),
      ));
    } else if (widget.task['icon'] == 'tree') {
      widgets.add(Icon(
        CustomIcon.tree_filled,
        size: 13,
        color: Colors.white,
      ));
      widgets.add(Padding(
        padding: EdgeInsets.only(right: 2),
      ));
    }
    if (widget.task['text'] != null) {
      widgets.add(Text(widget.task['text'], textScaleFactor: 1.0, style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white)));
    }
    return widgets;
  }

  void initState() {
    super.initState();
  }

  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.task['stories_cover'] != null) {
      storiescover = widget.task['stories_cover'];
    } else {
      widget.task['stories'].forEach((t) => {storiescover.add(t['assets'])});
    }

    var text = widget.task['aboutget'];
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
                            children: <Widget>[Text('Descripción del desafío', style: TextStyle(fontWeight: FontWeight.w700)), Padding(padding: EdgeInsets.only(bottom: 13)), Text(widget.task['description'].toString().replaceAll('\\n', '\n'))],
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
                            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => ToStories(contenido: List<Map<String, dynamic>>.from(widget.task['stories'])))),
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
                                    'gs://ecoheroes-app.appspot.com/tasks/' + widget.task['sponsor'],
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
