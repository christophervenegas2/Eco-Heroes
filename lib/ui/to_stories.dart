// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// //import '../lib/flutter_stories.dart';

// class TOStories extends StatefulWidget {
//   final List<Widget> images;

//   TOStories({Key key, this.images}) : super(key: key);

//   @override
//   _TOStoriesState createState() => _TOStoriesState();
// }

// class _TOStoriesState extends State<TOStories> {
//   var _momentCount;
//   final _momentDuration = const Duration(seconds: 5);

//   @override
//   void initState() {
//     super.initState();
//     _momentCount = widget.images.length;
//   }

//   @override
//   void dispose(){
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final images = List.generate(
//       _momentCount,
//       (idx) => widget.images[idx],
//     );

//     return Story(
//       onFlashForward: Navigator.of(context).pop,
//       onFlashBack: Navigator.of(context).pop,
//       momentCount: _momentCount,
//       momentDurationGetter: (idx) => _momentDuration,
//       momentBuilder: (context, idx) => images[idx],
//     );
//   }
// }
