import 'package:flutter/material.dart';
import 'package:vector_math/vector_math.dart' as vectormath;

class TOAppBar extends StatelessWidget {
  final animationspeed, offset, tab, height, back;

  const TOAppBar({Key key, this.animationspeed = 0, this.offset = 0, this.tab = 0, this.height = 0, this.back = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AnimatedContainer(
          duration: Duration(milliseconds: animationspeed),
          height: ((offset >= 140 ? 0 + (tab == 0 ? AppBar().preferredSize.height + MediaQuery.of(context).padding.top + height : 0.0) : AppBar().preferredSize.height + MediaQuery.of(context).padding.top + height - (tab == 0 ? 0 : offset))) < 0 ? 0 : (offset >= 140 ? 0 + (tab == 0 ? AppBar().preferredSize.height + MediaQuery.of(context).padding.top + height : 0.0) : AppBar().preferredSize.height + MediaQuery.of(context).padding.top + height - (tab == 0 ? 0 : offset)),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(bottomRight: Radius.circular(15)),
            gradient: LinearGradient(
              colors: [Color(0xFF4AD6A7), Color(0xFF4AD6CC)],
              transform: GradientRotation(
                vectormath.radians(45),
              ),
            ),
          ),
        ),
        AnimatedOpacity(
          duration: Duration(milliseconds: 200),
          opacity: offset == 0 ? 1 : 0,
          child: AppBar(
            automaticallyImplyLeading: back,
            centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            title: SizedBox(
              height: 27,
              child: Hero(
                tag: 'splash',
                child: Image.asset('assets/logo_appbar.png'),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
