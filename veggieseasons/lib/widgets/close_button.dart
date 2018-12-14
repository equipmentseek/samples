import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';

class CupertinoBlur extends StatelessWidget {
  const CupertinoBlur({
    this.child,
    Key key,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Color(0xccf8f8f8),
        ),
        child: child,
      ),
    );
  }
}

class CloseButton extends StatelessWidget {
  const CloseButton(this.onPressed);

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onPressed();
      },
      child: ClipOval(
        child: CupertinoBlur(
          child: Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Center(
              child: Icon(
                CupertinoIcons.clear_thick,
                size: 20,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
