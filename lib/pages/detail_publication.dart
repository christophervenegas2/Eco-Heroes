import 'package:ecoheroes/const/custom_icon_icons.dart';
import 'package:ecoheroes/models/publication.dart';
import 'package:ecoheroes/models/user.dart';
import 'package:ecoheroes/provider/publicationsprovider.dart';
import 'package:ecoheroes/provider/userprovider.dart';
import 'package:ecoheroes/ui/to_appbar.dart';
import 'package:ecoheroes/ui/to_card.dart';
import 'package:firebase_image/firebase_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class DetailPublication extends StatefulWidget {
  final Publication publication;
  DetailPublication({Key key, this.publication}) : super(key: key);

  @override
  _DetailPublicationState createState() => _DetailPublicationState();
}

class _DetailPublicationState extends State<DetailPublication> {
  User user;
  int likes = 0;
  bool like = false;

  getUser() async {
    final userprovider = Provider.of<UserProvider>(context, listen: false);
    final publicationprovider =
        Provider.of<PublicationsProvider>(context, listen: false);

    await publicationprovider.getPublication(widget.publication.id);
    user = await userprovider.getUserById(widget.publication.userId);
    likes = publicationprovider.publication.likes;

    if (user.publicationsLikes.contains(widget.publication.id)) {
      like = true;
    }

    setState(() {});
  }

  void likepress() {
    final userprovider = Provider.of<UserProvider>(context, listen: false);

    userprovider.togglepublactionlike(
        user.id, widget.publication.id, like, likes);
    setState(() {
      if (!like) {
        likes++;
      } else {
        likes--;
      }
      like = !like;
    });
    // widget.updatelike(like, likes);
  }

  @override
  void initState() {
    getUser();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TOAppBar(back: true),
          widget.publication != null && user != null
              ? Expanded(
                  child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30.0, vertical: 20),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.only(right: 20),
                              child: ClipOval(
                                child: Image(
                                  height: 45,
                                  width: 45,
                                  fit: BoxFit.cover,
                                  alignment: Alignment.topLeft,
                                  image: FirebaseImage(
                                    'gs://ecoheroes-app.appspot.com/' +
                                        user.profilePicture,
                                    shouldCache:
                                        true, // The image should be cached (default: True)
                                    maxSizeBytes: 3000 *
                                        1000, // 3MB max file size (default: 2.5MB)
                                    cacheRefreshStrategy: CacheRefreshStrategy
                                        .BY_METADATA_DATE, // Switch off update checking
                                  ),
                                ),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  user.username,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                SizedBox(height: 2),
                                user.instagram != null
                                    ? Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Icon(CustomIcon.instagram,
                                              color: Colors.redAccent,
                                              size: 18),
                                          SizedBox(width: 5),
                                          Text(
                                            '@ ${user.instagram}',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )
                                        ],
                                      )
                                    : Container()
                              ],
                            )
                          ],
                        ),
                        SizedBox(height: 15),
                        Container(
                          height: 350,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image(
                              fit: BoxFit.fill,
                              alignment: Alignment.topLeft,
                              image: FirebaseImage(
                                'gs://ecoheroes-app.appspot.com/' +
                                    widget.publication.image,
                                shouldCache:
                                    true, // The image should be cached (default: True)
                                maxSizeBytes: 5000 *
                                    1000, // 3MB max file size (default: 2.5MB)
                                cacheRefreshStrategy: CacheRefreshStrategy
                                    .BY_METADATA_DATE, // Switch off update checking
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Flexible(
                              flex: 1,
                              child: GestureDetector(
                                onTap: likepress,
                                child: TOCard(
                                    child: Padding(
                                  padding: const EdgeInsets.all(14.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(
                                        like
                                            ? CustomIcon.heart
                                            : CustomIcon.heart_empty,
                                        size: 14,
                                        color: like
                                            ? Color(0xFFDF2126)
                                            : Colors.black,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(right: 8),
                                      ),
                                      Text(
                                        likes.toString(),
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: 15),
                            ),
                            Flexible(
                              flex: 1,
                              child: TOCard(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 17.0),
                                  child: Text(
                                    traslateCategory(
                                        widget.publication.category),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Container(
                          child: TOCard(
                              child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              widget.publication.description,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                              // maxLines: 6,
                            ),
                          )),
                        ),
                        // SizedBox(height: 20),
                        // GestureDetector(
                        //   onTap: () {},
                        //   child: Container(
                        //       child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.center,
                        //     children: [
                        //       Text('Reportar publicación',
                        //           style: TextStyle(color: Colors.grey)),
                        //       SizedBox(width: 5),
                        //       Icon(
                        //         CustomIcon.attention,
                        //         size: 16,
                        //         color: Colors.redAccent,
                        //       )
                        //     ],
                        //   )),
                        // )
                      ],
                    ),
                  ),
                ))
              : Padding(
                  padding: const EdgeInsets.only(top: 40.0),
                  child: CircularProgressIndicator(),
                ),
        ],
      ),
    );
  }

  String traslateCategory(String category) {
    switch (category) {
      case 'reuse':
        return 'Reutilización';
        break;
      case 'foods':
        return 'Alimentos';
        break;
      case 'others':
        return 'Otros';
        break;
      case 'recycling':
        return 'Reciclaje';
        break;
      case 'composting':
        return 'Compostaje';
        break;
      case 'ecoInvents':
        return 'EcoInventos';
        break;
      case 'plantsAndTrees':
        return 'Plantas & Árboles';
        break;
      case 'voluntaryChallenges':
        return 'Desafíos voluntarios';
        break;
      default:
        return 'No definido';
        break;
    }
  }
}
