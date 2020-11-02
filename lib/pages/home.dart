import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecoheroes/pages/articles.dart';
import 'package:ecoheroes/pages/publications.dart';
import 'package:ecoheroes/provider/articlesprovider.dart';
import 'package:ecoheroes/provider/publicationsprovider.dart';
import 'package:ecoheroes/provider/staticprovider.dart';
import 'package:ecoheroes/provider/userprovider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:ecoheroes/const/custom_icon_icons.dart';
import 'package:ecoheroes/pages/profile.dart';
import 'package:ecoheroes/pages/task.dart';
import 'package:ecoheroes/ui/to_appbar.dart';
import 'package:provider/provider.dart';
import 'package:vector_math/vector_math.dart' as vectormath;
import 'package:ecoheroes/lib/notifications.dart';

class Home extends StatefulWidget {
  final User user;

  const Home({Key key, this.user}) : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  ScrollController scrollController;
  int tab = 0, animationspeed = 100;
  double height = 0, opacity = 0, offset = 0.0;
  var loading = true;
  var user = [];
  var alltask = [];
  List<Map<String, dynamic>> task = [];
  var wip = [];
  var ids = [];
  var revision = [];
  var complete = [];
  var wipcompletenames = [];
  var tabindex = 0;

  void settabindex(value) {
    tabindex = value;
  }

  Future<void> getUser() async {
    final articlesprovider = Provider.of<ArticlesProvider>(context, listen: false);
    final staticprovider = Provider.of<StaticProvider>(context, listen: false);
    final userprovider = Provider.of<UserProvider>(context, listen: false);
    final publicationsprovider = Provider.of<PublicationsProvider>(context, listen: false);
    await articlesprovider.getactivenews();
    await articlesprovider.getactiveecoinventions();
    await articlesprovider.getactivetutorials();
    await publicationsprovider.getPublications();
    await staticprovider.init();
    await firestore.collection('users').where('email', isEqualTo: widget.user.email).get().then((value) => {
          setState(() {
            loading = false;
          }),
          userprovider.userinfo.addAll(value.docs.single.data()),
          userprovider.userinfo['id'] = value.docs.single.id,
        });
    FirebaseMessaging().getToken().then((value) => {
          if (userprovider.userinfo['pushtoken'] == null || value != userprovider.userinfo['pushtoken'])
            {
              firestore.collection('users').doc(userprovider.userinfo['id']).update({'pushtoken': value}),
            },
        });

    await getWipTask();
  }

  Future<void> getWipTask([tab = 0]) async {
    final userprovider = Provider.of<UserProvider>(context, listen: false);
    final staticprovider = Provider.of<StaticProvider>(context, listen: false);
    wip = [];
    ids = [];
    revision = [];
    complete = [];
    wipcompletenames = [];
    userprovider.ecopoints = 0;
    userprovider.leafpoints = 0;
    userprovider.resetcontribution();
    tabindex = tab;
    var datatemp;
    await firestore.collection('users').doc(userprovider.userinfo['id']).collection('tasks').get().then(
          (documents) => {
            if (documents.docs.isNotEmpty)
              {
                documents.docs.forEach(
                  (e) => {
                    datatemp = e.data(),
                    datatemp['id_desafio'] = e.id,
                    if (e.data()['status'] == 'wip')
                      {
                        setState(() {
                          wip.add(datatemp);
                          ids.add(e.data()['id']);
                          wipcompletenames.add(e.data()['name']);
                        })
                      }
                    else if (e.data()['status'] == 'revision')
                      {
                        setState(() {
                          revision.add(datatemp);
                          ids.add(e.data()['id']);
                          wipcompletenames.add(e.data()['name']);
                        })
                      }
                    else if (e.data()['status'] == 'complete')
                      {
                        userprovider.ecopoints +=
                            int.parse(e.data()['yougetpoints'] == null ? '0' : e.data()['yougetpoints']),
                        userprovider.leafpoints +=
                            int.parse(e.data()['yougetleaf'] == null ? '0' : e.data()['yougetleaf']),
                        if (e.data()['counters'] != null)
                          {
                            e.data()['counters'].forEach(
                                  (key, element) => {
                                    if (staticprovider.counters[staticprovider.dictionary[key]] != null)
                                      {
                                        staticprovider.counters[staticprovider.dictionary[key]]['contribution'].forEach(
                                          (el) => {
                                            userprovider.contribution[el] += element *
                                                staticprovider.counters[staticprovider.dictionary[key]]['conversion'],
                                          },
                                        ),
                                      },
                                  },
                                ),
                          },
                        if (e.data()['contribution'] != null)
                          {
                            e.data()['contribution'].forEach(
                                  (key, element) => {userprovider.contribution[key] += element},
                                ),
                          },
                        setState(() {
                          complete.add(datatemp);
                          ids.add(e.data()['id']);
                        })
                      }
                  },
                )
              }
          },
        );
    getAllTask();
  }

  Future getAllTask() async {
    task = [];
    await firestore.collection('task-active').doc('active').get().then(
          (document) => {
            setState(
              () {
                alltask = document.data()['task'];
              },
            ),
          },
        );
    alltask.forEach((element) {
      if (!ids.contains(element['id']) && element['status'] == 'enabled') {
        task.add(element);
      }
    });
    sort();
  }

  void sort() {
    task.sort((b, a) => a['order'].compareTo(b['order']));
  }

  @override
  void initState() {
    PushNotifications();
    scrollController = new ScrollController();
    scrollController.addListener(updateOffset);
    getUser();
    super.initState();
  }

  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void updateOffset() {
    setState(() {
      offset = scrollController.offset;
    });
  }

  void setAnimSpeed(value) {
    animationspeed = value;
  }

  Widget bottombar() {
    return (Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(15)),
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.16),
              blurRadius: 6,
              offset: Offset(0, 0),
            ),
          ],
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: Color(0xFF4AD6A7),
          type: BottomNavigationBarType.fixed,
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: false,
          showSelectedLabels: false,
          currentIndex: tab,
          onTap: (newIndex) => {
            setState(() {
              tab = newIndex;
              height = newIndex == 3 ? 60 : 0;
              opacity = newIndex == 3 ? 1 : 0;
              if ((tab == 0 || tab == 1) && scrollController.hasClients) {
                animationspeed = 100;
                scrollController.jumpTo(0.0);
              }
            }),
          },
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(
                CustomIcon.tasks,
                key: Key('tasks-bottombar'),
              ),
              title: Text('Buscar'),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                CustomIcon.lightbulb,
                key: Key('publications-bottombar'),
              ),
              title: Text('Publicaciones'),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                CustomIcon.news,
                key: Key('articles-bottombar'),
              ),
              title: Text('Noticias'),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                CustomIcon.profile,
                key: Key('profile-bottombar'),
              ),
              title: Text('Perfil'),
            ),
          ],
        ),
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: (Scaffold(
        body: loading
            ? Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [Color(0xFF4AD6A7), Color(0xFF4AD6CC)],
                        transform: GradientRotation(vectormath.radians(45)))),
                child: Center(
                  child: Hero(
                    tag: 'logo',
                    child: Image.asset(
                      'assets/logo_splash.png',
                      width: 180,
                      height: 180,
                    ),
                  ),
                ),
              )
            : Container(
                child: Stack(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        TOAppBar(animationspeed: animationspeed, height: height, offset: offset, tab: tab),
                        tab == 0
                            ? Expanded(
                                child: Task(
                                  getUser: getUser,
                                  getWipTask: getWipTask,
                                  revision: revision,
                                  names: wipcompletenames,
                                  settabindex: settabindex,
                                  tabindex: tabindex,
                                  task: task,
                                  wip: wip,
                                ),
                              )
                            : SizedBox.shrink(),
                        tab == 1
                            ? Expanded(
                                child: Publications(),
                              )
                            : SizedBox.shrink(),
                        tab == 2
                            ? Expanded(
                                child: Articles(),
                              )
                            : SizedBox.shrink(),
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        Expanded(
                          child: tab == 3
                              ? Profile(
                                  complete: complete,
                                  height: height,
                                  scrollController: scrollController,
                                  setanimspeed: setAnimSpeed,
                                  gettask: getWipTask,
                                )
                              : SizedBox.shrink(),
                        ),
                      ],
                    ),
                    bottombar(),
                  ],
                ),
              ),
      )),
    );
  }
}
