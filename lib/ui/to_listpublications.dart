import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecoheroes/models/publication.dart';
import 'package:ecoheroes/pages/detail_publication.dart';
import 'package:ecoheroes/provider/publicationsprovider.dart';
import 'package:ecoheroes/ui/to_addpublication.dart';
import 'package:ecoheroes/ui/to_chooseoption.dart';
import 'package:firebase_image/firebase_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class TOListPublications extends StatefulWidget {
  final List<Publication> publication;
  final bool dismissible;
  final Function refresh;
  final String section;

  const TOListPublications({
    Key key,
    this.publication,
    this.dismissible = false,
    this.refresh,
    this.section,
  }) : super(key: key);

  @override
  _TOListPublicationsState createState() => _TOListPublicationsState();
}

class _TOListPublicationsState extends State<TOListPublications> {
  int publicationsloaded = 15;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  StorageReference storageReference = FirebaseStorage.instance.ref();
  List<Publication> publication = [];
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  File photo;
  final picker = ImagePicker();

  void _onRefresh(Function refresh) async {
    await refresh();
    Future.delayed(Duration(milliseconds: 1000));
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    await Future.delayed(Duration(milliseconds: 1500));
    setState(() {
      publicationsloaded += 6;
    });
    if (publicationsloaded > widget.publication.length) {
      _refreshController.loadNoData();
    } else {
      _refreshController.loadComplete();
    }
  }

  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
        controller: _refreshController,
        onRefresh: () {
          _onRefresh(widget.refresh);
        },
        onLoading: () {
          _onLoading();
        },
        header: ClassicHeader(
          completeDuration: Duration(seconds: 2),
          completeText: 'Publicaciones actualizadas!',
          refreshingText: 'Actualizando publicaciones...',
          idleText: 'Desliza para actualizar!',
          releaseText: 'Soltar para actualizar!',
          failedText: 'Internet no es para mí :(, hubo un error',
        ),
        footer: ClassicFooter(
          completeDuration: Duration(seconds: 2),
          idleText: 'Desliza para cargar más!',
          loadingText: 'Cargando más publicaciones...',
          noDataText: 'No hay más publicaciones...',
          failedText: 'Internet no es para mí :(, hubo un error',
          canLoadingText: 'Soltar para cargar más',
        ),
        enablePullUp: true,
        child: (widget.publication).length == 0
            ? Center(child: Text('No hay publicaciones disponibles...'))
            : Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: GridView.builder(
                  itemCount: publicationsloaded > widget.publication.length
                      ? widget.publication.length
                      : publicationsloaded,
                  padding: EdgeInsets.all(10),
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 8.0,
                      childAspectRatio: 1.0,
                      maxCrossAxisExtent: 150),
                  itemBuilder: (context, index) => GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    DetailPublication(
                                      publication: widget.publication[index],
                                    )));
                      },
                      child: Container(
                        height: 150,
                        width: 150,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image(
                            fit: BoxFit.cover,
                            image: FirebaseImage(
                              'gs://ecoheroes-app.appspot.com' +
                                  widget.publication[index].image,
                              shouldCache:
                                  true, // The image should be cached (default: True)
                              maxSizeBytes: 5000 *
                                  1000, // 3MB max file size (default: 2.5MB)
                              cacheRefreshStrategy: CacheRefreshStrategy
                                  .BY_METADATA_DATE, // Switch off update checking
                            ),
                          ),
                        ),
                      )),
                ),
              ));
  }
}
