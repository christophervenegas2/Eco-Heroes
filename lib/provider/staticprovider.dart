import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class StaticProvider with ChangeNotifier {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  var counters, dictionary;

  Future<void> init() async {
    await firestore.collection('ui').doc('counters').get().then((value) => {counters = value.data()});
    await firestore.collection('ui').doc('dictionary').get().then((value) => {dictionary = value.data()});
    //print(counters);
    //print(dictionary);
  }
}
