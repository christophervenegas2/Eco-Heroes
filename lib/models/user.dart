import 'package:meta/meta.dart';

class User {
    User({
        @required this.id,
        @required this.email,
        @required this.emailV,
        @required this.firstname,
        @required this.instagram,
        @required this.instagramV,
        @required this.lastname,
        @required this.profilePicture,
        @required this.username,
        @required this.publicationsLikes
    });

    String id;
    final String email;
    final bool emailV;
    final String firstname;
    final String instagram;
    final bool instagramV;
    final String lastname;
    final String profilePicture;
    final String username;
    final List<dynamic> publicationsLikes;

    factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        email: json["email"],
        emailV: json["email_v"],
        firstname: json["firstname"],
        instagram: json["instagram"] ?? 'No definido',
        instagramV: json["instagram_v"],
        lastname: json["lastname"],
        profilePicture: json["profile_picture"],
        username: json["username"],
        publicationsLikes: json["publications_likes"] ?? []
    );

    Map<String, dynamic> toJson() => {
        "email": email,
        "email_v": emailV,
        "firstname": firstname,
        "instagram": instagram,
        "instagram_v": instagramV,
        "lastname": lastname,
        "profile_picture": profilePicture,
        "username": username,
        "publications_likes": publicationsLikes
    };
}
