import 'package:ecoheroes/provider/articlesprovider.dart';
import 'package:ecoheroes/provider/staticprovider.dart';
import 'package:ecoheroes/provider/userprovider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ecoheroes/pages/splashscreen.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ArticlesProvider()),
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => StaticProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'EcoHeroes',
        theme: ThemeData(
          fontFamily: 'Proxima Nova',
          buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
        ),
        home: SplashScreen(),
      ),
    );
  }
}
