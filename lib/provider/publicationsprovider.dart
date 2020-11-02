import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecoheroes/models/publication.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

class PublicationsProvider with ChangeNotifier {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  List<Publication> following = List<Publication>();
  List<Publication> reuse = List<Publication>();
  List<Publication> foods = List<Publication>();
  List<Publication> others = List<Publication>();
  List<Publication> general = List<Publication>();
  List<Publication> recycling = List<Publication>();
  List<Publication> composting = List<Publication>();
  List<Publication> ecoInvents = List<Publication>();
  List<Publication> plantsAndTrees = List<Publication>();
  List<Publication> voluntaryChallenges = List<Publication>();
  Publication publication;
  bool _displayAddButton = false;
  bool _success = false;

  bool get displayAddButton => _displayAddButton;
  bool get success => _success;

  void setDisplayAddButton() {
    this._displayAddButton = !_displayAddButton;
    notifyListeners();
  }

  Future<void> getPublications() async {
    await firestore
        .collection('publications')
        // .where('active', isEqualTo: true)
        .orderBy('timestamp', descending: true)
        .get()
        .then((value) {
      general =
          value.docs.map((e) => Publication.fromDocumentSnapshot(e)).toList();
    }).catchError((e) {
      print('Error on getPublications $e');
    });

    filter(general, 'reuse');
    filter(general, 'foods');
    filter(general, 'others');
    filter(general, 'recycling');
    filter(general, 'composting');
    filter(general, 'ecoInvents');
    filter(general, 'plantsAndTrees');
    filter(general, 'voluntaryChallenges');
    notifyListeners();
  }

  Future getPublication(String id) async {
    try {
      await firestore
          .collection('publications')
          .doc(id)
          .get()
          .then((DocumentSnapshot value) {
        publication = Publication.fromDocumentSnapshot(value);
      });
    } catch (e) {
      print('Error on getPublication $e');
    }
    notifyListeners();
  }

  Future<void> getReuses() async {
    await firestore
        .collection('publications')
        .where('category', isEqualTo: 'reuse')
        .orderBy('timestamp', descending: true)
        .get()
        .then((value) {
      reuse = value.docs
          // .where((publications) => publications.data()['active'])
          .map((e) => Publication.fromDocumentSnapshot(e))
          .toList();
      general.addAll(reuse);
      setGeneral();
    }).catchError((e) {
      print('Error on getReuses: $e');
    });
  }

  Future<void> getFoods() async {
    await firestore
        .collection('publications')
        .where('category', isEqualTo: 'foods')
        .orderBy('timestamp', descending: true)
        .get()
        .then((value) {
      foods = value.docs
          // .where((publications) => publications.data()['active'])
          .map((e) => Publication.fromDocumentSnapshot(e))
          .toList();
      general.addAll(foods);
      setGeneral();
    }).catchError((e) {
      print('Error on getFoods: $e');
    });
  }

  Future<void> getOthers() async {
    await firestore
        .collection('publications')
        .where('category', isEqualTo: 'others')
        .orderBy('timestamp', descending: true)
        .get()
        .then((value) {
      others = value.docs
          // .where((publications) => publications.data()['active'])
          .map((e) => Publication.fromDocumentSnapshot(e))
          .toList();
      general.addAll(others);
      setGeneral();
    }).catchError((e) {
      print('Error on getOthers: $e');
    });
  }

  Future<void> getRecycling() async {
    await firestore
        .collection('publications')
        .where('category', isEqualTo: 'recycling')
        .orderBy('timestamp', descending: true)
        .get()
        .then((value) {
      recycling = value.docs
          // .where((publications) => publications.data()['active'])
          .map((e) => Publication.fromDocumentSnapshot(e))
          .toList();
      general.addAll(recycling);
      setGeneral();
    }).catchError((e) {
      print('Error on getRecycling: $e');
    });
  }

  Future<void> getComposting() async {
    await firestore
        .collection('publications')
        .where('category', isEqualTo: 'composting')
        .orderBy('timestamp', descending: true)
        .get()
        .then((value) {
      composting = value.docs
          // .where((publications) => publications.data()['active'])
          .map((e) => Publication.fromDocumentSnapshot(e))
          .toList();
      general.addAll(composting);
      setGeneral();
    }).catchError((e) {
      print('Error $e');
    });
  }

  Future<void> getEcoInvents() async {
    await firestore
        .collection('publications')
        .where('category', isEqualTo: 'ecoInvents')
        .orderBy('timestamp', descending: true)
        .get()
        .then((value) {
      ecoInvents = value.docs
          // .where((publications) => publications.data()['active'])
          .map((e) => Publication.fromDocumentSnapshot(e))
          .toList();
      general.addAll(ecoInvents);
      setGeneral();
    }).catchError((e) {
      print('Error $e');
    });
  }

  Future<void> getPlantsAndTrees() async {
    await firestore
        .collection('publications')
        .where('category', isEqualTo: 'plantsAndTrees')
        .orderBy('timestamp', descending: true)
        .get()
        .then((value) {
      plantsAndTrees = value.docs
          // .where((element) => element.data()['active'])
          .map((e) => Publication.fromDocumentSnapshot(e))
          .toList();
      general.addAll(plantsAndTrees);
      setGeneral();
    }).catchError((e) {
      print('Error $e');
    });
  }

  Future<void> getVoluntaryChallenges() async {
    await firestore
        .collection('publications')
        .where('category', isEqualTo: 'voluntaryChallenges')
        .orderBy('timestamp', descending: true)
        .get()
        .then((value) {
      voluntaryChallenges = value.docs
          // .where((publications) => publications.data()['active'])
          .map((e) => Publication.fromDocumentSnapshot(e))
          .toList();
      general.addAll(voluntaryChallenges);
      setGeneral();
    }).catchError((e) {
      print('Error $e');
    });
  }

  Future<void> addPublication(Publication publication, File photo, Uint8List image) async {
    StorageReference sreference;

    try {
      // Uint8List image = await photo.readAsBytes();
      publication = await changeCategory(publication);
      var uri =
          '/publications/${publication.category}/${photo.path.split('/').last}';
      sreference = FirebaseStorage().ref().child(uri);
      StorageUploadTask uploadTask = sreference.putData(image);
      await uploadTask.onComplete.then((value) async {
        publication.image = uri;
        publication.likes = 0;
        // publication.active = false;
        publication.timestamp = DateTime.now();

        final result = await firestore
            .collection('publications')
            .add(publication.toJson());

        if (result.id != null) {
          _success = true;
        } else {
          _success = false;
        }

        notifyListeners();
      }, onError: (e) {
        print('Error when upload image');
      });
    } catch (e) {
      print(e);
    }
  }

  void setGeneral() {
    final existing = Set<String>();
    final unique =
        general.where((publication) => existing.add(publication.id)).toList();
    general = unique;
    notifyListeners();
  }

  void filter(dynamic publications, String section) {
    switch (section) {
      case 'reuse':
        reuse = publications
            .where((element) => element.category == 'reuse')
            .toList();
        break;
      case 'foods':
        foods = publications
            .where((element) => element.category == 'foods')
            .toList();
        break;
      case 'others':
        others = publications
            .where((element) => element.category == 'others')
            .toList();
        break;
      case 'recycling':
        recycling = publications
            .where((element) => element.category == 'recycling')
            .toList();
        break;
      case 'composting':
        composting = publications
            .where((element) => element.category == 'composting')
            .toList();
        break;
      case 'ecoInvents':
        ecoInvents = publications
            .where((element) => element.category == 'ecoInvents')
            .toList();
        break;
      case 'plantsAndTrees':
        plantsAndTrees = publications
            .where((element) => element.category == 'plantsAndTrees')
            .toList();
        break;
      case 'voluntaryChallenges':
        voluntaryChallenges = publications
            .where((element) => element.category == 'voluntaryChallenges')
            .toList();
        break;
      default:
    }
  }

  Future<Publication> changeCategory(Publication publication) async {
    switch (publication.category) {
      case 'EcoInventos':
        publication.category = 'ecoInvents';
        return publication;
        break;
      case 'Alimentos':
        publication.category = 'foods';
        return publication;
        break;
      case 'Plantas & Árboles':
        publication.category = 'plantsAndTrees';
        return publication;
        break;
      case 'Compostaje':
        publication.category = 'composting';
        return publication;
        break;
      case 'Reutilización':
        publication.category = 'reuse';
        return publication;
        break;
      case 'Desafíos voluntarios':
        publication.category = 'voluntaryChallenges';
        return publication;
        break;
      case 'Otros':
        publication.category = 'others';
        return publication;
        break;
      default:
        publication.category = 'others';
        return publication;
        break;
    }
  }
}
