import 'package:firebase_image/firebase_image.dart';
import 'package:flutter/material.dart';

class Testing extends StatelessWidget {
  const Testing({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('test'),
      ),
      body: Image(
        image: FirebaseImage(
          'gs://ecoheroes-app.appspot.com/tasks/KiOUOizmSf8rLiJbEtmD/ecoheroes.png',
          shouldCache: true, // The image should be cached (default: True)
          maxSizeBytes: 3000 * 1000, // 3MB max file size (default: 2.5MB)
          cacheRefreshStrategy: CacheRefreshStrategy.BY_METADATA_DATE // Switch off update checking
        ),
        width: 100,
      ),
    );
  }
}