import 'dart:async';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecoheroes/pages/coupon.dart';
import 'package:ecoheroes/pages/footprint.dart';
import 'package:ecoheroes/pages/profile_settings.dart';
import 'package:ecoheroes/provider/userprovider.dart';
import 'package:firebase_image/firebase_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ecoheroes/const/custom_icon_icons.dart';
import 'package:ecoheroes/ui/to_colorbutton.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  final double height;
  final ScrollController scrollController;
  final Function setanimspeed;
  final complete, gettask;
  const Profile(
      {Key key,
      this.height,
      this.scrollController,
      this.setanimspeed,
      this.complete,
      this.gettask})
      : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  double opacity = 0;
  double offset = 0;
  bool loadingimage = false;

  //Jose
  int content = 1;
  bool _isPawActivated = true;
  bool _isConfigActivated = false;
  bool _isCuponActivated = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void setContent(int index) {
    setState(() {
      this.content = index;
      switch (index) {
        case 1:
          _isPawActivated = true;
          _isConfigActivated = false;
          _isCuponActivated = false;
          break;
        case 2:
          _isPawActivated = false;
          _isConfigActivated = true;
          _isCuponActivated = false;
          break;
        case 3:
          _isPawActivated = false;
          _isConfigActivated = false;
          _isCuponActivated = true;
          break;
        default:
          _isPawActivated = true;
          _isConfigActivated = false;
          _isCuponActivated = false;
          break;
      }
    });
  }

  Widget _buttons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _newButton("Mi Huella", 1, _isPawActivated),
        SizedBox(width: 10.0),
        _newButton("Configuración", 2, _isConfigActivated),
        SizedBox(width: 10.0),
        _newButton("Mis cupones", 3, _isCuponActivated),
      ],
    );
  }

  Widget _newButton(name, int index, bool activated) {
    final userprovider = Provider.of<UserProvider>(context, listen: false);
    return new GestureDetector(
        onTap: () {
          if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Coupon(
                  userid: userprovider.userinfo['id'],
                ),
              ),
            );
          } else {
            setContent(index);
          }
        },
        child: new Container(
          padding: EdgeInsets.only(left: 10, top: 3, right: 10, bottom: 3),
          decoration: BoxDecoration(
            border: Border.all(
                color: activated
                    ? Color.fromRGBO(0, 218, 170, 1.0)
                    : Colors.transparent),
            borderRadius: BorderRadius.circular(10),
            shape: BoxShape.rectangle,
          ),
          child: Text(
            name,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12.0,
              color: activated ? Color.fromRGBO(0, 218, 170, 1.0) : Colors.grey,
            ),
          ),
        ));
  }

  Widget _content() {
    switch (this.content) {
      case 1:
        return FootPrint();
      case 2:
        return ProfileSettings();
      default:
        return FootPrint();
    }
  }

  @override
  Widget build(BuildContext context) {
    final userprovider = Provider.of<UserProvider>(context, listen: false);

    if (opacity == 0) {
      Timer(Duration(milliseconds: 100), () {
        if (this.mounted) {
          widget.setanimspeed(0);
          setState(() {
            opacity = 1;
          });
        }
      });
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 60),
      child: SingleChildScrollView(
        controller: widget.scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            (Container(
              padding: EdgeInsets.only(
                  top: AppBar().preferredSize.height +
                      MediaQuery.of(context).padding.top +
                      widget.height -
                      65),
              child: AnimatedOpacity(
                  opacity: opacity,
                  duration: Duration(milliseconds: 200),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 130,
                        width: 130,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: InkWell(
                            onTap: () async {
                              StorageReference sreference;
                              PickedFile file = await ImagePicker().getImage(
                                  source: ImageSource.gallery,
                                  maxHeight: 600,
                                  maxWidth: 600);
                              if (file != null) {
                                Uint8List image = await file.readAsBytes();
                                sreference = FirebaseStorage().ref().child(
                                    '/profile/${userprovider.userinfo["id"]}/${file.path.split('/').last}');
                                StorageUploadTask uploadtask =
                                    sreference.putData(image);
                                setState(() {
                                  loadingimage = true;
                                });
                                uploadtask.onComplete.then(
                                  (value) => {
                                    FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(userprovider.userinfo['id'])
                                        .update({
                                      'profile_picture':
                                          '/profile/${userprovider.userinfo["id"]}/${file.path.split('/').last}'
                                    }),
                                    userprovider.userinfo.addAll({
                                      "profile_picture":
                                          "/profile/${userprovider.userinfo["id"]}/${file.path.split('/').last}"
                                    }),
                                    setState(() {
                                      loadingimage = false;
                                    }),
                                  },
                                );
                              }
                            },
                            child: Stack(
                              fit: StackFit.expand,
                              children: <Widget>[
                                Image(
                                  fit: BoxFit.cover,
                                  alignment: Alignment.center,
                                  image: userprovider
                                          .userinfo['profile_picture']
                                          .contains('://')
                                      ? NetworkImage(userprovider
                                          .userinfo['profile_picture'])
                                      : FirebaseImage(
                                          'gs://ecoheroes-app.appspot.com' +
                                              userprovider
                                                  .userinfo['profile_picture'],
                                          shouldCache:
                                              true, // The image should be cached (default: True)
                                          maxSizeBytes: 3000 *
                                              1000, // 3MB max file size (default: 2.5MB)
                                          scale: 3
                                          // Switch off update checking
                                          ),
                                ),
                                loadingimage
                                    ? Container(
                                        color: Color.fromRGBO(0, 0, 0, 0.3))
                                    : SizedBox.shrink(),
                                loadingimage
                                    ? Center(
                                        child: CircularProgressIndicator(
                                        valueColor: AlwaysStoppedAnimation(
                                            Color(0xFF4AD6A7)),
                                        strokeWidth: 3,
                                      ))
                                    : SizedBox.shrink(),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(bottom: 20)),
                      Text(
                          '${userprovider.userinfo['firstname']} ${userprovider.userinfo['lastname']}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 25)),
                      Padding(padding: EdgeInsets.only(bottom: 5)),
                      Text('@${userprovider.userinfo['username']}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.w300, fontSize: 17)),
                      Padding(padding: EdgeInsets.only(bottom: 20)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          TOColorButton(
                            text: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 26.0),
                              child: Row(
                                children: <Widget>[
                                  Text('${userprovider.ecopoints} Puntos',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 17)),
                                ],
                              ),
                            ),
                            color: Color(0xFF4AD6A7),
                            onPressed: () => {
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (BuildContext context) => CompleteTask(
                              //               complete: widget.complete,
                              //               gettask: widget.gettask,
                              //             )))
                            },
                            radius: Radius.circular(15),
                          ),
                          Padding(padding: EdgeInsets.only(left: 10)),
                          TOColorButton(
                            text: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 26.0),
                              child: Row(
                                children: <Widget>[
                                  Icon(
                                    CustomIcon.leaf,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(right: 2),
                                  ),
                                  Text('${userprovider.leafpoints}',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 17)),
                                ],
                              ),
                            ),
                            color: Color(0xFF4AD6A7),
                            onPressed: () => {
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (BuildContext context) => CompleteTask(
                              //               complete: widget.complete,
                              //               gettask: widget.gettask,
                              //             )))
                            },
                            radius: Radius.circular(15),
                          ),
                        ],
                      ),
                      Padding(padding: EdgeInsets.only(top: 21)),
                      _buttons(),
                      Padding(padding: EdgeInsets.only(top: 21)),
                      _content(),
                      //ProfileSettings(),
                    ],
                  )),
            )),
          ],
        ),
      ),
    );
  }
}
