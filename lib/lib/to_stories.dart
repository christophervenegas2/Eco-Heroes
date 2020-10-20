import 'package:cached_video_player/cached_video_player.dart';
import 'package:firebase_image/firebase_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ToStories extends StatefulWidget {
  final contenido;

  const ToStories({Key key, this.contenido}) : super(key: key);
  @override
  _ToStoriesState createState() => _ToStoriesState();
}

class _ToStoriesState extends State<ToStories> with TickerProviderStateMixin {
  var loading = [];
  var first = [];
  var current;

  List<Map<String, dynamic>> content;

  List<Widget> widgets = [];
  List<CachedVideoPlayerController> controllers = [];
  List<AnimationController> animationcontrollers = [];
  var bars = [];
  List<int> duration;
  var stories = [];

  void initVideos() {
    content.asMap().forEach((index, element) {
      loading.add(true);
      first.add(false);
      animationcontrollers.add(AnimationController(
        vsync: this,
        lowerBound: 0,
        upperBound: 1,
        duration: Duration(milliseconds: int.parse(element['duration'])),
      )
        ..addListener(() {
          this.setState(() {});
        })
        ..addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            if (content[current]['type'] == 'video') {
              controllers[current].pause();
            }
            if (current == content.length - 1) {
              controllers[current].pause();
              Navigator.pop(context);
            } else {
              setState(() {
                current++;
              });
            }
          }
        }));
      if (element['type'] == 'image') {
        controllers.add(null);
        stories.add(Container(
          width: double.infinity,
          height: double.infinity,
          child: FittedBox(
              fit: BoxFit.contain,
              child: Image(
                image: FirebaseImage(
                  'gs://ecoheroes-app.appspot.com/tasks/'+element['assets'],
                  shouldCache: true, // The image should be cached (default: True)
                  maxSizeBytes: 3000 * 1000, // 3MB max file size (default: 2.5MB)
                  cacheRefreshStrategy: CacheRefreshStrategy.BY_METADATA_DATE, // Switch off update checking
                )..getBytes().then((value) => setState(() {
                      loading[index] = false;
                    })),
              )),
        ));
      } else if (element['type'] == 'video') {
        controllers.add(CachedVideoPlayerController.network(element['assets'])
          ..initialize().then((value) => {
                setState(() {
                  loading[index] = false;
                })
              })..addListener(() {if(controllers[index].value.position > Duration(seconds:0)){
                if(!first[index]){
                  animationcontrollers[index].forward();
                  first[index] = true;
                }
              }}));
        stories.add(AspectRatio(
          aspectRatio: controllers[index].value.aspectRatio,
          child: CachedVideoPlayer(controllers[index]),
        ));
      }
    });
  }

  List<Widget> indicatorsbar() {
    List<Widget> temp = [];
    content.asMap().forEach((index, element) {
      temp.add(
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 10.0, left: 5, right: 5),
            child: Stack(
              children: <Widget>[
                Container(
                  height: 5,
                  color: Colors.white30,
                ),
                Container(
                  height: 5,
                  color: Colors.white,
                  child: FractionallySizedBox(
                    widthFactor: animationcontrollers[index].value,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
    return temp;
  }

  void initState() {
    super.initState();
    content = widget.contenido;
    current = 0;
    duration = [];
    initVideos();
    SystemChrome.setEnabledSystemUIOverlays([]);
  }

  void dispose() {
    for (var i = 0; i < content.length; i++) {
      //ignore: unnecessary_statements
      controllers[i] == null ? null : controllers[i].dispose();
      animationcontrollers[i].dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (content[current]['type'] == 'image') {
      if (!loading[current]) {
        animationcontrollers[current].forward();
      }
    } else if (content[current]['type'] == 'video') {
      if (!loading[current]) {
        controllers[current].play();
      }
    }
    return GestureDetector(
      onPanUpdate: (details) {
        if (details.delta.dy > 0)
          Navigator.pop(context);
      },
      onTapDown: (TapDownDetails details) => {
        content[current]['type'] == 'video' ? controllers[current].pause() : null,
        animationcontrollers[current].stop(),
      },
      onLongPress: () {
        //ignore: unnecessary_statements
        content[current]['type'] == 'video' ? controllers[current].pause() : null;
        animationcontrollers[current].stop();
      },
      onLongPressEnd: (LongPressEndDetails details) => {
        content[current]['type'] == 'video' ? controllers[current].play() : null,
        animationcontrollers[current].forward(),
      },
      onTapUp: (TapUpDetails details) {
        final width = MediaQuery.of(context).size.width;
        if (details.localPosition.dx < width * 0.5) {
          if (current == 0) {
            Navigator.pop(context);
          } else {
            animationcontrollers[current - 1].reset();
            animationcontrollers[current].reset();
            if (content[current]['type'] == 'video') {
              controllers[current].pause();
              controllers[current].seekTo(Duration(seconds: 0));
            }
            if (content[current - 1]['type'] == 'video') {
              controllers[current - 1].seekTo(Duration(seconds: 0));
            }
            setState(() {
              current--;
            });
          }
        } else {
          animationcontrollers[current].animateTo(1, duration: Duration(seconds: 0));
        }
      },
      child: Stack(
        children: <Widget>[
          Center(child: AspectRatio(aspectRatio: 9 / 16, child: Container(width: double.infinity, height: double.infinity, child: stories[current]))),
          Container(
            width: double.infinity,
            child: Row(
              children: indicatorsbar(),
            ),
          ),
        ],
      ),
    );
  }
}
