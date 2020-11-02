import 'package:cloud_firestore/cloud_firestore.dart';

class Publication {
    Publication({
        this.id,
        this.image,
        this.description,
        this.category,
        this.likes,
        this.active,
        this.userId,
        this.timestamp
    });

    String id;
    String image;
    String description;
    String category;
    int likes;
    bool active;
    String userId;
    DateTime timestamp;

    Publication.fromDocumentSnapshot(DocumentSnapshot doc) {
      id = doc.id;
      image = doc.data()["image"];
      description = doc.data()["description"];
      category = doc.data()["category"];
      active = doc.data()["active"];
      likes = doc.data()["likes"];
      userId = doc.data()["userId"];
      timestamp = doc.data()["datetime"];
    }

    factory Publication.fromJson(Map<String, dynamic> json) => Publication(
        id: json["id"],
        image: json["image"],
        description: json["description"],
        category: json["category"],
        active: json["active"],
        likes: json["likes"],
        userId: json["userId"],
        timestamp: json["datetime"]
    );

    Map<String, dynamic> toJson() => {
        "image": image,
        "description": description,
        "category": category,
        "likes": likes,
        "active": active,
        "userId": userId,
        "timestamp": timestamp
    };
}
