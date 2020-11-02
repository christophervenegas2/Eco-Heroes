import 'dart:io';
import 'dart:typed_data';

import 'package:ecoheroes/models/publication.dart';
import 'package:ecoheroes/provider/publicationsprovider.dart';
import 'package:ecoheroes/provider/userprovider.dart';
import 'package:ecoheroes/ui/to_appbar.dart';
import 'package:ecoheroes/ui/to_card.dart';
import 'package:ecoheroes/ui/to_colorbutton.dart';
import 'package:ecoheroes/ui/to_successpublication.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:provider/provider.dart';

class TOAddPublication extends StatefulWidget {
  final File photo;
  TOAddPublication({Key key, @required this.photo}) : super(key: key);

  @override
  _TOAddPublicationState createState() => _TOAddPublicationState();
}

class _TOAddPublicationState extends State<TOAddPublication> {
  Publication publication = Publication();
  List<String> categories = [
    'EcoInventos',
    'Alimentos',
    'Plantas & Árboles',
    'Compostaje',
    'Reutilización',
    'Desafíos voluntarios',
    'Otros'
  ];
  String category;
  bool loading = false;
  Uint8List file;

  @override
  void initState() {
    super.initState();
    testCompressFile(widget.photo);
  }

  Future<void> testCompressFile(File file) async {
    this.file = await FlutterImageCompress.compressWithFile(
      file.absolute.path,
      minWidth: 2300,
      minHeight: 1500,
      quality: 94,
    );
  }

  @override
  Widget build(BuildContext context) {
    final userprovider = Provider.of<UserProvider>(context, listen: false);
    final publicationProvider = Provider.of<PublicationsProvider>(context, listen: false);

    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        body: Column(
          children: [
            TOAppBar(back: true),
            Expanded(
              child: SingleChildScrollView(
                  child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
                child: Column(
                  children: [
                    TOCard(
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.file(
                            widget.photo,
                            height: 340,
                            fit: BoxFit.fitWidth,
                          )),
                    ),
                    SizedBox(height: 20),
                    TOCard(
                        child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextField(
                        onChanged: (_) => publication.description = _,
                        decoration: InputDecoration(
                            border: InputBorder.none, hintText: 'Escribe un mensaje para tu publicación...'),
                        keyboardType: TextInputType.multiline,
                        minLines: 4,
                        maxLines: 8,
                        maxLength: 2000,
                      ),
                    )),
                    SizedBox(height: 20),
                    TOCard(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            hint: Text('Elige la categoría de tu publicación...'),
                            isExpanded: true,
                            value: category,
                            items: categories.map((String value) {
                              return new DropdownMenuItem<String>(
                                child: Text(value),
                                value: value,
                              );
                            }).toList(),
                            onChanged: (selected) {
                              setState(() {
                                category = selected;
                                publication.category = category;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    loading
                        ? CircularProgressIndicator()
                        : TOColorButton(
                            onPressed: () async {
                              setState(() => loading = true);

                              if (publication.description == null || publication.category == null)
                                return setState(() => loading = false);

                              publication.userId = userprovider.userinfo['id'];

                              await publicationProvider.addPublication(
                                  publication, widget.photo, this.file);

                              if (publicationProvider.success) {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => TOSuccessPublication(),
                                    ));
                              } else {
                                setState(() => loading = false);
                              }
                            },
                            color: Color(0xFF163B4D),
                            radius: Radius.circular(50),
                            text: Text(
                              'Enviar publicación',
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                          )
                  ],
                ),
              )),
            )
          ],
        ),
      ),
    );
  }
}
