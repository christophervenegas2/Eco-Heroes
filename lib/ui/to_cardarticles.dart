import 'package:ecoheroes/provider/articlesprovider.dart';
import 'package:ecoheroes/provider/userprovider.dart';
import 'package:firebase_image/firebase_image.dart';
import 'package:flutter/material.dart';
import 'package:ecoheroes/const/custom_icon_icons.dart';
import 'package:provider/provider.dart';

class TOCardArticles extends StatefulWidget {
  final article;
  final int index;
  final Function onTap;
  final String section, articleid;

  const TOCardArticles({Key key, this.article, this.index, this.onTap, this.section, this.articleid}) : super(key: key);

  @override
  _TOCardArticlesState createState() => _TOCardArticlesState();
}

class _TOCardArticlesState extends State<TOCardArticles> {
  bool like = false;
  int likes;

  @override
  void initState() {
    final userprovider = Provider.of<UserProvider>(context, listen: false);
    likes = widget.article['likes'];
    if (userprovider.userinfo['articles_likes'] != null) {
      if (userprovider.userinfo['articles_likes'].contains(widget.articleid)) {
        like = true;
      }
    }
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void likepress() {
    final userprovider = Provider.of<UserProvider>(context, listen: false);
    userprovider.togglearticlelike(widget.articleid, like, widget.section, widget.article['likes']);
    setState(() {
      if (!like) {
        likes++;
      } else {
        likes--;
      }
      like = !like;
    });
  }

  void updatelike(like, likes) {
    setState(() {
      this.like = like;
      this.likes = likes;
    });
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final articlesprovider = Provider.of<ArticlesProvider>(context);
    return GestureDetector(
      onTap: () => {widget.onTap(updatelike)},
      onDoubleTap: () {
        likepress();
      },
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
        height: widget.index == 0 ? 160 : 120,
        child: Stack(
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 110,
                  height: widget.index == 0 ? 160 : 120,
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(15), bottomLeft: Radius.circular(15)),
                    child: Image(
                      fit: BoxFit.fitHeight,
                      alignment: Alignment.topLeft,
                      image: FirebaseImage(
                        'gs://ecoheroes-app.appspot.com/' + widget.article['cover'],
                        shouldCache: true, // The image should be cached (default: True)
                        maxSizeBytes: 3000 * 1000, // 3MB max file size (default: 2.5MB)
                        cacheRefreshStrategy: CacheRefreshStrategy.BY_METADATA_DATE, // Switch off update checking
                      ),
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
                          Container(
                            child: Text(
                              widget.article['title'],
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                              ),
                              textScaleFactor: 1.0,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 5),
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Icon(
                                      like ? CustomIcon.heart : CustomIcon.heart_empty,
                                      color: like ? Color(0xFFDF2126) : Colors.black,
                                      size: 14,
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
                                    SizedBox(
                                      height: 20,
                                      child: VerticalDivider(
                                        color: Colors.black26,
                                        thickness: 1,
                                        width: 15,
                                      ),
                                    ),
                                    Text(
                                      widget.article['date'],
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
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
    );
  }
}
