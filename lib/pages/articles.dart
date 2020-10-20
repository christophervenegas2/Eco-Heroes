import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecoheroes/provider/articlesprovider.dart';
import 'package:ecoheroes/ui/to_listarticles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Articles extends StatefulWidget {
  const Articles({Key key}) : super(key: key);
  @override
  _ArticlesState createState() => _ArticlesState();
}

class _ArticlesState extends State<Articles> with SingleTickerProviderStateMixin {
  TabController _tabController;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  bool loadtask = false;

  void initState() {
    final articlesprovider = Provider.of<ArticlesProvider>(context, listen: false);
    _tabController = new TabController(vsync: this, length: 3)
      ..addListener(() {
        articlesprovider.indextab = _tabController.index;
      });
    super.initState();
  }

  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final articlesprovider = Provider.of<ArticlesProvider>(context);
    _tabController.index = articlesprovider.indextab;
    return (Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 60),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 7, 20, 0),
            child: TabBar(
              indicatorColor: Colors.white,
              indicatorSize: TabBarIndicatorSize.label,
              indicatorPadding: EdgeInsets.zero,
              labelStyle: TextStyle(fontWeight: FontWeight.w700, fontFamily: 'Proxima Nova'),
              unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w400),
              indicator: BoxDecoration(color: Color(0xFF4AD6B0), borderRadius: BorderRadius.circular(50)),
              labelPadding: EdgeInsets.zero,
              isScrollable: true,
              controller: _tabController,
              unselectedLabelColor: Color(0xFF4AD6B0),
              tabs: <Widget>[
                Container(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 4, 10, 2),
                    child: Text('Noticias'),
                  ),
                ),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 4, 10, 2),
                    child: Text("Ecoinventos"),
                  ),
                ),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 4, 10, 2),
                    child: Text("Tutoriales"),
                  ),
                ),
              ],
            ),
          ),
          loadtask
              ? Padding(
                  padding: const EdgeInsets.only(top: 60.0),
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4AD6A7)),
                    strokeWidth: 3,
                  ),
                )
              : Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: TOListArticles(
                          articles: articlesprovider.activenews,
                          articlessort: articlesprovider.activenewssort,
                          refresh: articlesprovider.getactivenews,
                          section: 'news',
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: TOListArticles(
                          articles: articlesprovider.activeecoinventions,
                          articlessort: articlesprovider.activeecoinventionssort,
                          refresh: articlesprovider.getactiveecoinventions,
                          section: 'ecoinventions',
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: TOListArticles(
                          articles: articlesprovider.activetutorials,
                          articlessort: articlesprovider.activetutorialssort,
                          refresh: articlesprovider.getactivetutorials,
                          section: 'tutorials',
                        ),
                      ),
                    ],
                  ),
                )
        ],
      ),
    ));
  }
}
