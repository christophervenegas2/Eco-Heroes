import 'package:ecoheroes/provider/publicationsprovider.dart';
import 'package:ecoheroes/ui/to_listpublications.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Publications extends StatefulWidget {
  Publications({Key key}) : super(key: key);

  @override
  _PublicationsState createState() => _PublicationsState();
}

class _PublicationsState extends State<Publications> with SingleTickerProviderStateMixin{
  TabController _tabController;

  @override
  void initState() { 
    _tabController = new TabController(vsync: this, length: 9);

    super.initState();
  }

  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final publicationsProvider = Provider.of<PublicationsProvider>(context);
    
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
                    child: Text('General'),
                  ),
                ),
                // Container(
                //   child: Padding(
                //     padding: const EdgeInsets.fromLTRB(10, 4, 10, 2),
                //     child: Text('Seguidos'),
                //   ),
                // ),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 4, 10, 2),
                    child: Text("EcoInventos"),
                  ),
                ),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 4, 10, 2),
                    child: Text("Alimentos"),
                  ),
                ),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 4, 10, 2),
                    child: Text("Plantas & Árboles"),
                  ),
                ),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 4, 10, 2),
                    child: Text("Compostaje"),
                  ),
                ),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 4, 10, 2),
                    child: Text("Reutilización"),
                  ),
                ),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 4, 10, 2),
                    child: Text("Reciclaje"),
                  ),
                ),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 4, 10, 2),
                    child: Text("Desafíos voluntarios"),
                  ),
                ),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 4, 10, 2),
                    child: Text("Otros"),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: TOListPublications(
                          publication: publicationsProvider.general,
                          refresh: publicationsProvider.getPublications,
                          section: 'general',
                        ),
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.only(top: 10.0),
                      //   child: TOListPublications(
                      //     publication: publicationsProvider.following,
                      //     refresh: publicationsProvider.getPublications,
                      //     section: 'seguidos',
                      //   ),
                      // ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: TOListPublications(
                          publication: publicationsProvider.ecoInvents,
                          refresh: publicationsProvider.getEcoInvents,
                          section: 'ecoInvents',
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: TOListPublications(
                          publication: publicationsProvider.foods,
                          refresh: publicationsProvider.getFoods,
                          section: 'foods',
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: TOListPublications(
                          publication: publicationsProvider.plantsAndTrees,
                          refresh: publicationsProvider.getPlantsAndTrees,
                          section: 'plantsAndTrees',
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: TOListPublications(
                          publication: publicationsProvider.composting,
                          refresh: publicationsProvider.getPublications,
                          section: 'composting',
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: TOListPublications(
                          publication: publicationsProvider.reuse,
                          refresh: publicationsProvider.getReuses,
                          section: 'reuse',
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: TOListPublications(
                          publication: publicationsProvider.recycling,
                          refresh: publicationsProvider.getRecycling,
                          section: 'recycling',
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: TOListPublications(
                          publication: publicationsProvider.voluntaryChallenges,
                          refresh: publicationsProvider.getVoluntaryChallenges,
                          section: 'voluntaryChallenges',
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: TOListPublications(
                          publication: publicationsProvider.others,
                          refresh: publicationsProvider.getOthers,
                          section: 'others',
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