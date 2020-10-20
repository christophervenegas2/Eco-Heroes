import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class ArticlesProvider with ChangeNotifier {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Map<String, dynamic> activenews = {};
  List<String> activenewssort = [];
  Map<String, dynamic> activeecoinventions = {};
  List<String> activeecoinventionssort = [];
  Map<String, dynamic> activetutorials = {};
  List<String> activetutorialssort = [];

  int indextab = 0;

  Future<void> getactivenews() async {
    await firestore
        .collection('articles-active')
        .doc('news')
        .get()
        .then(
          (value) => {
            activenews = value.data(),
            activenewssort = value.data().keys.toList(),
            activenewssort.sort((a, b) {
              return activenews[b]['timestamp'].compareTo(activenews[a]['timestamp']);
            }),
            notifyListeners(),
          },
        )
        .catchError(
          (onError) => {
            print(onError),
          },
        );
  }

  Future<void> getactiveecoinventions() async {
    await firestore
        .collection('articles-active')
        .doc('ecoinventions')
        .get()
        .then(
          (value) => {
            activeecoinventions = value.data(),
            activeecoinventionssort = value.data().keys.toList(),
            activeecoinventionssort.sort((a, b) {
              return activeecoinventions[b]['timestamp'].compareTo(activeecoinventions[a]['timestamp']);
            }),
            notifyListeners(),
          },
        )
        .catchError(
          (onError) => {
            print(onError),
          },
        );
  }

  Future<void> getactivetutorials() async {
    await firestore
        .collection('articles-active')
        .doc('tutorials')
        .get()
        .then(
          (value) => {
            activetutorials = value.data(),
            activetutorialssort = value.data().keys.toList(),
            activetutorialssort.sort((a, b) {
              return activetutorials[b]['timestamp'].compareTo(activetutorials[a]['timestamp']);
            }),
            notifyListeners(),
          },
        )
        .catchError(
          (onError) => {
            print(onError),
          },
        );
  }

  Future getarticle(String id, String collection) async {
    var newcontent;
    try {
      await firestore.collection(collection).doc(id).get().then(
            (value) => {
              if (value.exists)
                {
                  newcontent = value.data(),
                }
              else
                {
                  newcontent = 'Error',
                },
            },
          );
    } catch (e) {
      newcontent = 'Error';
    }

    notifyListeners();
    return newcontent;
  }
}
