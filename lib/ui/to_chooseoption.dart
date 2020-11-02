import 'dart:io';

import 'package:ecoheroes/provider/publicationsprovider.dart';
import 'package:ecoheroes/ui/to_addpublication.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class TOChooseoption extends StatefulWidget {
  BuildContext newContext;
  TOChooseoption({Key key}) : super(key: key);

  @override
  _TOChooseoptionState createState() => _TOChooseoptionState();
}

class _TOChooseoptionState extends State<TOChooseoption> {
  File photo;
  final picker = ImagePicker();

  _processImage(ImageSource imageSource, BuildContext context) async {
    final pickedFile = await picker.getImage(source: imageSource);

    if (pickedFile != null) {
      photo = File(pickedFile.path);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => TOAddPublication(photo: photo)));
    }    

  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: (Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(15)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: () async {
                      await _processImage(ImageSource.gallery, context);
                    },
                    child: Column(
                      children: [
                        Text(
                          'Abrir galeria',
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Proxima Nova',
                            decoration: TextDecoration.none,
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(height: 10),
                        Icon(Icons.filter, color: Color(0xFF4AD6B0))
                      ],
                    ),
                  ),
                  Container(
                      width: 10,
                      height: 100,
                      child: VerticalDivider(color: Colors.black, width: 2)),
                  GestureDetector(
                    onTap: () async {
                      await _processImage(ImageSource.camera, context);
                    },
                    child: Column(
                      children: [
                        Text(
                          'Tomar foto',
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Proxima Nova',
                            decoration: TextDecoration.none,
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(height: 10),
                        Icon(CupertinoIcons.photo_camera_solid,
                            color: Color(0xFF4AD6B0))
                      ],
                    ),
                  )
                ],
              )),
        ],
      )),
    );
  }
  
}
