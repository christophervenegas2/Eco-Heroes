//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
class Fire extends StatelessWidget {
  const Fire({Key key}) : super(key: key);
  //   Firestore firestore = Firestore.instance;
  // Future<void> b() async {
  //   Firestore firestore = Firestore.instance;
  //   List<Map<String,dynamic>> task = [];
  //   Map<String,dynamic> map = {};
  //   await firestore.collection('task-active').document('active').get().then((value) => {
  //     for(var i in value.data['task']){
  //       map = i,
  //       if(map['text'].contains('%') && map['text'].length > 3){
  //         map.addAll({'text':'\$'+map['text'].split('%')[1]}),
  //       },
  //       task.add(map),
  //     }
  //   });
  //   print(task);
  //   await firestore.collection('task-active').document('active').updateData({'task':task});
  // }

  // Future<void> c() async {
  //   Firestore firestore = Firestore.instance;
  //   List<Map<String,dynamic>> task = [];
  //   Map<String,dynamic> map = {};
  //   await firestore.collection('tasks').getDocuments().then((value) => {
  //     value.documents.forEach((element) async {
  //       // if(element.data['type'] == 'volunteer'){
  //       //   var yougetleaf = element.data['youget'];
  //       //   await firestore.collection('tasks').document(element.documentID).updateData({'yougetleaf':yougetleaf, 'text':'Voluntario'});
  //       // }
  //       // else if(element.data['type'] == 'discount'){
  //       //   String yougetleaf = element.data['youget'];
  //       //   await firestore.collection('tasks').document(element.documentID).updateData({'icon':'discount', 'text': '%'+yougetleaf});
  //       // }
  //       var f = [];
  //       element['stories'].forEach((s)=>{
  //         f.add({'type':s.contains('.mp4') ? 'video' : 'image', 'duration':'5000','assets':s}),
  //       });
        
  //       await firestore.collection('tasks').document(element.documentID).updateData({'stories': f});
  //     })
  //   });
  // }

  // Future<void> d() async {
  //   Firestore firestore = Firestore.instance;
  //   await firestore.collection('users').getDocuments().then((value) => {
  //     value.documents.forEach((element) {
  //       var email = element.data['email'].toLowerCase();
  //       print(email);
  //       firestore.collection('users').document(element.documentID).updateData({'email': email});
  //     })
  //   });
  // }

  @override
  Widget build(BuildContext context) {

    bool a = true;
    if (a) {
      //b();
      //c();
      //d();
      a = false;
    }
    return Container();
  }
}