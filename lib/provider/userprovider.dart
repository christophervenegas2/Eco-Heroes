import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:ecoheroes/models/user.dart' as userM;

class UserProvider with ChangeNotifier {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  User _user;
  Map userinfo = {};
  int leafpoints = 0, ecopoints = 0;
  Map contribution = {};

  User get user => _user;

  set user(User newuser) {
    _user = newuser;
    notifyListeners();
  }

  void resetcontribution() {
    contribution = {
      'co2': 0,
      'ecobrick': 0,
      'organicwaste': 0,
      'plantedtrees': 0,
      'recycledplastic': 0,
      'recycledwaste': 0,
      'watersaved': 0,
    };
  }

  void togglearticlelike(
      String articleid, bool like, String section, int quantity) {
    var batch = firestore.batch();
    var docrefuser = firestore.collection('users').doc(userinfo['id']);
    var docrefactive = firestore.collection('articles-active').doc(section);
    var docrefarticle = firestore.collection(section).doc(articleid);
    if (!like) {
      batch.update(docrefuser, {
        'articles_likes': FieldValue.arrayUnion([articleid])
      });
      batch.set(
          docrefactive,
          {
            articleid: {
              'likes': FieldValue.increment(1),
            },
          },
          SetOptions(merge: true));
      batch.update(docrefarticle, {'likes': FieldValue.increment(1)});
    } else {
      if (quantity > 0) {
        batch.update(firestore.collection('users').doc(userinfo['id']), {
          'articles_likes': FieldValue.arrayRemove([articleid])
        });
        batch.set(
            docrefactive,
            {
              articleid: {
                'likes': FieldValue.increment(-1),
              },
            },
            SetOptions(merge: true));
        batch.update(docrefarticle, {'likes': FieldValue.increment(-1)});
      }
    }
    batch.commit().then((value) => {
          if (!like)
            {
              userinfo['articles_likes'].add(articleid),
            }
          else
            {
              userinfo['articles_likes'].remove(articleid),
            }
        });
    notifyListeners();
  }

  Future<Map<String, dynamic>> loginfacebook() async {
    final result = await FacebookAuth.instance.login();
    switch (result.status) {
      case FacebookAuthLoginResponse.ok:
        try {
          // Create a credential from the access token
          final FacebookAuthCredential facebookAuthCredential =
              FacebookAuthProvider.credential(result.accessToken.token);

          // Once signed in, return the UserCredential
          UserCredential resultauth =
              await auth.signInWithCredential(facebookAuthCredential);
          // get the user data
          final token = result.accessToken.token;
          final graphResponse = await http.get(
              'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email,picture.width(200).height(200)&access_token=$token');
          final profile = jsonDecode(graphResponse.body);
          await trySignUp(profile);
          user = resultauth.user;
          return ({
            'fail': false,
            'message': 'Todo bien!',
          });
        } catch (e) {
          String message;
          if (e.code == 'account-exists-with-different-credential') {
            message =
                'Esta cuenta no esta registrada con facebook, intenta iniciar con tu mail y contraseña';
          } else if (e['code'] == '0' || e['code'] == '1') {
            message = e['message'];
          } else {
            message = 'Hubo un error, por favor intente nuevamente';
          }
          return ({
            'fail': true,
            'message': message,
          });
        }
        break;
      case FacebookAuthLoginResponse.cancelled:
        return ({
          'fail': true,
          'message': 'Inicio Sesión cancelado por el usuario',
        });
        break;
      default:
        return ({
          'fail': true,
          'message':
              'Inicio Sesión fallido, intente con otra vez o con otro metodo',
        });
    }
  }

  Future<Map<String, dynamic>> loginGoogle() async {
    final GoogleSignInAccount resultgoogleuser = await GoogleSignIn(
      scopes: [
        'email',
        'https://www.googleapis.com/auth/userinfo.profile',
      ],
    ).signIn();
    if (resultgoogleuser != null) {
      try {
        final GoogleSignInAuthentication googleAuth =
            await resultgoogleuser.authentication;

        final GoogleAuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        UserCredential resultauth =
            await FirebaseAuth.instance.signInWithCredential(credential);
        Map<String, dynamic> idMap = parseJwt(googleAuth.idToken);
        var profile = {
          'first_name': idMap["given_name"],
          'last_name': idMap["family_name"],
          'email': resultgoogleuser.email,
          'picture': {
            'data': {
              'url': resultgoogleuser.photoUrl.replaceAll('s96-c', 's200-c')
            }
          },
        };
        await trySignUp(profile);
        _user = resultauth.user;
        return ({
          'fail': false,
          'message': 'Todo bien!',
        });
      } catch (e) {
        String message;
        if (e.code == 'account-exists-with-different-credential') {
          message =
              'Esta cuenta no esta registrada con google, intenta iniciar con tu mail y contraseña';
        } else if (e['code'] == '0' || e['code'] == '1') {
          message = e['message'];
        } else {
          message = 'Hubo un error, por favor intente nuevamente';
        }
        return ({
          'fail': true,
          'message': message,
        });
      }
    } else {
      return ({
        'fail': true,
        'message':
            'Inicio Sesión fallido, intente con otra vez o con otro metodo',
      });
    }
  }

  // ignore: missing_return
  Future<Map<String, dynamic>> loginApple() async {
    if (await SignInWithApple.isAvailable()) {
      try {
        final AuthorizationCredentialAppleID result =
            await SignInWithApple.getAppleIDCredential(
          scopes: [
            AppleIDAuthorizationScopes.email,
            AppleIDAuthorizationScopes.fullName,
          ],
        );
        OAuthProvider oAuthProvider = new OAuthProvider("apple.com");
        final AuthCredential credential = oAuthProvider.credential(
          idToken: result.identityToken,
          accessToken: result.authorizationCode,
        );
        UserCredential resultauth =
            await FirebaseAuth.instance.signInWithCredential(credential);
        var profile = {
          'first_name': result.givenName,
          'last_name': result.familyName,
          'email': result.email,
          'picture': {
            'data': {'url': '/default/default.png'}
          },
        };
        await trySignUp(profile);
        _user = resultauth.user;
        return ({
          'fail': false,
          'message': 'Todo bien!',
        });
      } catch (e) {
        String message;
        if (e.code == 'account-exists-with-different-credential') {
          message =
              'Esta cuenta no esta registrada con apple, intenta iniciar con tu mail y contraseña';
        } else {
          message = 'Hubo un error, por favor intente nuevamente';
        }
        return ({
          'fail': true,
          'message': message,
        });
      }
    } else {
      return ({
        'fail': true,
        'message':
            'Apple Sign In no esta disponible para la versión de tu iOS, es posible que debas actualizarlo',
      });
    }
  }

  Future<void> trySignUp(profile) async {
    var response = await firestore
        .collection('users')
        .where('email', isEqualTo: profile['email'])
        .get()
        .catchError((onError) {
      print(onError);
      throw ({
        'code': '0',
        'message': 'Error conectandose a la Base de Datos',
      });
    });
    if (response.docs.isEmpty) {
      await firestore.collection('users').add(
        {
          'email': profile['email'],
          'firstname': profile['first_name'],
          'lastname': profile['last_name'],
          'username': profile['email'].split('@')[0],
          'profile_picture': profile['picture']['data']['url'],
          'instagram_v': false,
          'email_v': false,
        },
      ).catchError((onError) {
        throw ({
          'code': '0',
          'message': 'Error conectandose a la Base de Datos',
        });
      });
    }
  }

  static Map<String, dynamic> parseJwt(String token) {
    // validate token
    if (token == null) return null;
    final List<String> parts = token.split('.');
    if (parts.length != 3) {
      return null;
    }
    // retrieve token payload
    final String payload = parts[1];
    final String normalized = base64Url.normalize(payload);
    final String resp = utf8.decode(base64Url.decode(normalized));
    // convert to Map
    final payloadMap = json.decode(resp);
    if (payloadMap is! Map<String, dynamic>) {
      return null;
    }
    return payloadMap;
  }

  Future getUserById(String id) async {
    userM.User user;

    try {
      await firestore
          .collection('users')
          .doc(id)
          .get()
          .then((DocumentSnapshot value) {
        user = userM.User.fromJson(value.data());
        user.id = value.id;
      });
    } catch (e) {
      print(e);
    }

    notifyListeners();
    return user;
  }

  void togglepublactionlike(String userid,
      String publicationid, bool like, int quantity) {
    var batch = firestore.batch();
    var docrefuser = firestore.collection('users').doc(userid);
    var docrefpub = firestore.collection('publications').doc(publicationid);

    if (!like) {
      batch.update(docrefuser, {
        'publications_likes': FieldValue.arrayUnion([publicationid])
      });
      batch.update(docrefpub, {'likes': FieldValue.increment(1)});
    } else {
      if (quantity > 0) {
        batch.update(firestore.collection('users').doc(userid), {
          'publications_likes': FieldValue.arrayRemove([publicationid])
        });
        batch.update(docrefpub, {'likes': FieldValue.increment(-1)});
      }
    }

    batch.commit();

    notifyListeners();
  }
}
