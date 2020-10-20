import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecoheroes/pages/detail_article.dart';
import 'package:ecoheroes/provider/articlesprovider.dart';
import 'package:ecoheroes/ui/to_cardarticles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class TOListArticles extends StatefulWidget {
  final Map<String, dynamic> articles;
  final List<String> articlessort;
  final bool dismissible;
  final Function refresh;
  final String section;

  const TOListArticles({Key key, this.articles, this.dismissible = false, this.refresh, this.section, this.articlessort}) : super(key: key);

  @override
  _TOListArticlesState createState() => _TOListArticlesState();
}

class _TOListArticlesState extends State<TOListArticles> {
  int articlesloaded = 6;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  List articles;
  RefreshController _refreshController = RefreshController(initialRefresh: false);

  void _onRefresh(Function refresh) async {
    await refresh();
    Future.delayed(Duration(milliseconds: 1000));
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    await Future.delayed(Duration(milliseconds: 1500));
    setState(() {
      articlesloaded += 6;
    });
    if (articlesloaded > widget.articlessort.length) {
      _refreshController.loadNoData();
    } else {
      _refreshController.loadComplete();
    }
  }

  void initState() {
    super.initState();
  }

  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final articlesprovider = Provider.of<ArticlesProvider>(context);
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
        completeText: 'Artículos actualizados!',
        refreshingText: 'Actualizando artículos...',
        idleText: 'Desliza para actualizar!',
        releaseText: 'Soltar para actualizar!',
        failedText: 'Internet no es para mí :(, hubo un error',
      ),
      footer: ClassicFooter(
        completeDuration: Duration(seconds: 2),
        idleText: 'Desliza para cargar más!',
        loadingText: 'Cargando más artículos...',
        noDataText: 'No hay más articulos...',
        failedText: 'Internet no es para mí :(, hubo un error',
        canLoadingText: 'Soltar para cargar más',
      ),
      enablePullUp: true,
      child: (widget.articles).length == 0
          ? Center(child: Text('No hay articulos disponibles...'))
          : ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: articlesloaded > widget.articlessort.length ? widget.articlessort.length : articlesloaded,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                  child: TOCardArticles(
                    onTap: (Function updatelike) => {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => DetailArticle(id: widget.articlessort[index], section: widget.section, updatelike: updatelike),
                        ),
                      ),
                    },
                    index: index,
                    article: widget.articles[widget.articlessort[index]],
                    articleid: widget.articlessort[index],
                    section: widget.section,
                  ),
                );
              },
            ),
    );
  }
}
