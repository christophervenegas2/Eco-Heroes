import 'package:ecoheroes/const/custom_icon_icons.dart';
import 'package:ecoheroes/provider/articlesprovider.dart';
import 'package:ecoheroes/provider/userprovider.dart';
import 'package:ecoheroes/ui/to_appbar.dart';
import 'package:ecoheroes/ui/to_card.dart';
import 'package:firebase_image/firebase_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:provider/provider.dart';

class DetailArticle extends StatefulWidget {
  final String id;
  final String section;
  final Function updatelike;
  const DetailArticle({Key key, this.id, this.section, this.updatelike}) : super(key: key);

  @override
  _DetailArticleState createState() => _DetailArticleState();
}

class _DetailArticleState extends State<DetailArticle> {
  var article;
  int likes = 0;
  bool like = false;

  getarticle() async {
    final articlesprovider = Provider.of<ArticlesProvider>(context, listen: false);
    final userprovider = Provider.of<UserProvider>(context, listen: false);
    article = await articlesprovider.getarticle(widget.id, widget.section);
    likes = article['likes'];
    if (userprovider.userinfo['articles_likes'].contains(widget.id)) {
      like = true;
    }
  }

  void likepress() {
    final userprovider = Provider.of<UserProvider>(context, listen: false);
    userprovider.togglearticlelike(widget.id, like, widget.section, article['likes']);
    setState(() {
      if (!like) {
        likes++;
      } else {
        likes--;
      }
      like = !like;
    });
    widget.updatelike(like, likes);
  }

  void initState() {
    getarticle();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final articlesprovider = Provider.of<ArticlesProvider>(context);
    return Scaffold(
      body: Column(
        children: <Widget>[
          TOAppBar(back: true),
          article != null
              ? Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40),
                      child: Column(
                        children: <Widget>[
                          TOCard(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image(
                                fit: BoxFit.fitHeight,
                                alignment: Alignment.topLeft,
                                image: FirebaseImage(
                                  'gs://ecoheroes-app.appspot.com/' + article['cover'],
                                  shouldCache: true, // The image should be cached (default: True)
                                  maxSizeBytes: 3000 * 1000, // 3MB max file size (default: 2.5MB)
                                  cacheRefreshStrategy: CacheRefreshStrategy.BY_METADATA_DATE, // Switch off update checking
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 15),
                          ),
                          TOCard(
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Text(
                                article['title'],
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 15),
                          ),
                          Row(
                            children: <Widget>[
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
                                          like ? CustomIcon.heart : CustomIcon.heart_empty,
                                          size: 16,
                                          color: like ? Color(0xFFDF2126) : Colors.black,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(right: 8),
                                        ),
                                        Text(
                                          likes.toString(),
                                          style: TextStyle(
                                            fontSize: 14,
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
                                    padding: const EdgeInsets.symmetric(vertical: 17.0),
                                    child: Text(
                                      article['date'],
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
                          ListView.builder(
                            padding: EdgeInsets.all(0),
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: article['content'].length,
                            // ignore: missing_return
                            itemBuilder: (BuildContext context, int index) {
                              if (index % 2 == 0) {
                                if (article['content'][index] != '') {
                                  if (article['content'][index].contains('youtube.com/watch')) {
                                    Uri uri = Uri.dataFromString(article['content'][index]);
                                    return Column(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(top: 15),
                                        ),
                                        ClipRRect(
                                          borderRadius: BorderRadius.all(Radius.circular(15)),
                                          child: HtmlWidget(
                                            '''<iframe src="https://youtube.com/embed/${uri.queryParameters['v']}" frameborder="0" allowfullscreen></iframe>''',
                                            webView: true,
                                            bodyPadding: EdgeInsets.zero,
                                          ),
                                        ),
                                      ],
                                    );
                                  } else {
                                    return Column(
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.only(top: 15),
                                        ),
                                        TOCard(
                                          child: Padding(
                                            padding: const EdgeInsets.all(14.0),
                                            child: Text(
                                              article['content'][index].toString().replaceAll('\\n', '\n'),
                                              textAlign: TextAlign.start,
                                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  }
                                }
                              } else {
                                return article['content'][index] != ''
                                    ? Column(
                                        children: <Widget>[
                                          Padding(
                                            padding: EdgeInsets.only(top: 15),
                                          ),
                                          TOCard(
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(15),
                                              child: Image(
                                                fit: BoxFit.fitHeight,
                                                alignment: Alignment.topLeft,
                                                image: FirebaseImage(
                                                  'gs://ecoheroes-app.appspot.com/' + article['content'][index],
                                                  shouldCache: true, // The image should be cached (default: True)
                                                  maxSizeBytes: 3000 * 1000, // 3MB max file size (default: 2.5MB)
                                                  cacheRefreshStrategy: CacheRefreshStrategy.BY_METADATA_DATE, // Switch off update checking
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    : SizedBox.shrink();
                              }
                            },
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 15),
                          ),
                          TOCard(
                            child: Padding(
                              padding: const EdgeInsets.all(14.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'Esta nota es posible gracias a:',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  Padding(padding: EdgeInsets.only(bottom: 10)),
                                  Container(
                                    width: double.infinity,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: Image(
                                        height: 130,
                                        fit: BoxFit.fitHeight,
                                        alignment: Alignment.center,
                                        image: FirebaseImage(
                                          'gs://ecoheroes-app.appspot.com/' + article['sponsor'],
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
                        ],
                      ),
                    ),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.only(top: 40.0),
                  child: CircularProgressIndicator(),
                ),
        ],
      ),
    );
  }
}
