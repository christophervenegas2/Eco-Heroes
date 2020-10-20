import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_driver/driver_extension.dart';
import 'package:ecoheroes/main.dart' as app;

void main() {
  // This line enables the extension.
  enableFlutterDriverExtension();

  // Call the `main()` function of the app, or call `runApp` with
  // any widget you are interested in testing.
  FirebaseAuth.instance.signOut();
  app.main();
}
