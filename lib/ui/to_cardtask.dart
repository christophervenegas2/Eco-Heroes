import 'package:firebase_image/firebase_image.dart';
import 'package:flutter/material.dart';
import 'package:ecoheroes/const/custom_icon_icons.dart';

class TOCardTask extends StatefulWidget {
  final task;
  final index;
  final onTap;

  const TOCardTask({Key key, this.task, this.index, this.onTap}) : super(key: key);

  @override
  _TOCardTaskState createState() => _TOCardTaskState();
}

class _TOCardTaskState extends State<TOCardTask> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  List<Widget> geticonvalue() {
    List<Widget> widgets = [];
    if (widget.task[widget.index]['icon'] == null) {
    } else if (widget.task[widget.index]['icon'] == 'discount') {
      widgets.add(Icon(
        CustomIcon.discount,
        size: 13,
        color: Colors.white,
      ));
      widgets.add(Padding(
        padding: EdgeInsets.only(right: 2),
      ));
    } else if (widget.task[widget.index]['icon'] == 'leaf') {
      widgets.add(Icon(
        CustomIcon.leaf,
        size: 13,
        color: Colors.white,
      ));
      widgets.add(Padding(
        padding: EdgeInsets.only(right: 2),
      ));
    } else if (widget.task[widget.index]['icon'] == 'tree') {
      widgets.add(Icon(
        CustomIcon.tree_filled,
        size: 13,
        color: Colors.white,
      ));
      widgets.add(Padding(
        padding: EdgeInsets.only(right: 2),
      ));
    }
    if (widget.task[widget.index]['text'] != null) {
      widgets.add(Text(widget.task[widget.index]['text'], textScaleFactor: 1.0, style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white)));
    }
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Container(
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
        height: 110,
        child: Stack(
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: Image(
                    image: FirebaseImage(
                      'gs://ecoheroes-app.appspot.com/tasks/' + widget.task[widget.index]['cover'],
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                child: Text(
                                  widget.task[widget.index]['name'],
                                  style: TextStyle(fontWeight: FontWeight.w700),
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
                                      widget.task[widget.index]['location'],
                                      style: TextStyle(fontSize: 12),
                                      textScaleFactor: 1.0,
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Container(
                            constraints: BoxConstraints(maxHeight: 30, maxWidth: 75),
                            child: Image(
                              fit: BoxFit.contain,
                              image: FirebaseImage(
                                'gs://ecoheroes-app.appspot.com/tasks/' + widget.task[widget.index]['sponsor'],
                                shouldCache: true, // The image should be cached (default: True)
                                maxSizeBytes: 3000 * 1000, // 3MB max file size (default: 2.5MB)
                                cacheRefreshStrategy: CacheRefreshStrategy.BY_METADATA_DATE, // Switch off update checking
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
            Positioned(
              child: Container(
                height: 40,
                width: 100,
                decoration: BoxDecoration(color: Color(0xFFDF2126), borderRadius: BorderRadius.only(bottomRight: Radius.circular(15), topLeft: Radius.circular(15))),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: geticonvalue(),
                  ),
                ),
              ),
              bottom: 0,
              right: 0,
            )
          ],
        ),
      ),
    );
  }
}
