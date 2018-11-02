// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:veggieseasons/styles.dart';

typedef FutureOr<void> PressOperationCallback();

class SettingsItem extends StatefulWidget {
  const SettingsItem({
    @required this.label,
    this.child,
    this.subtitle,
    this.iconData,
    this.color,
    this.iconColor = const Color(0xFFFFFFFF),
    this.onPress,
  })  : assert(label != null),
        assert(child != null || onPress != null);

  final String label;
  final String subtitle;
  final IconData iconData;
  final Color color;
  final Color iconColor;
  final PressOperationCallback onPress;
  final Widget child;

  @override
  State<StatefulWidget> createState() => new SettingsItemState();
}

class SettingsItemState extends State<SettingsItem> {
  bool pressed = false;

  @override
  Widget build(BuildContext context) {
    List<Widget> rowChildren = [];
    if (widget.iconData != null) {
      rowChildren.add(
        Padding(
          padding: const EdgeInsets.only(
            left: 15.0,
            bottom: 2.0,
          ),
          child: Container(
            height: 29.0,
            width: 29.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              color: widget.color,
            ),
            child: Center(
              child: Icon(
                widget.iconData,
                color: widget.iconColor,
                size: 20.0,
              ),
            ),
          ),
        ),
      );
    }

    Widget titleSection;
    if (widget.subtitle == null) {
      titleSection = Padding(
        padding: EdgeInsets.only(top: 1.5),
        child: Text(widget.label),
      );
    } else {
      titleSection = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Padding(padding: EdgeInsets.only(top: 8.5)),
          Text(widget.label),
          const Padding(padding: EdgeInsets.only(top: 4.0)),
          Text(
            widget.subtitle,
            style: TextStyle(
              fontSize: 12.0,
              letterSpacing: -0.2,
            ),
          )
        ],
      );
    }

    rowChildren.add(
      Expanded(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 15.0,
          ),
          child: titleSection,
        ),
      ),
    );

    if (widget.child != null) {
      rowChildren.add(
        Padding(
          padding: const EdgeInsets.only(right: 11.0),
          child: widget.child,
        ),
      );
    } else {
      rowChildren.add(
        Padding(
          padding: const EdgeInsets.fromLTRB(2.25, 0.5, 8.5, 0.0),
          child: Icon(
            CupertinoIcons.forward,
            color: Styles.settingsMediumGray,
            size: 21.0,
          ),
        ),
      );
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      color: pressed ? Styles.settingsItemPressed : Styles.transparentColor,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () async {
          if (widget.onPress != null) {
            setState(() {
              pressed = true;
            });
            await widget.onPress();
            Future.delayed(
              Duration(milliseconds: 150),
              () {
                setState(() {
                  pressed = false;
                });
              },
            );
          }
        },
        child: SizedBox(
          height: widget.subtitle == null ? 44.0 : 57.0,
          child: Row(
            children: rowChildren,
          ),
        ),
      ),
    );
  }
}
