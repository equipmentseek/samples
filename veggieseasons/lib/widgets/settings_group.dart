// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:veggieseasons/styles.dart';

import 'settings_item.dart';

class SettingsGroup extends StatelessWidget {
  const SettingsGroup(
    this.items, {
    this.header,
    this.footer,
  }) : assert(items != null);

  final List<Widget> items;

  final Widget header;
  final Widget footer;

  @override
  Widget build(BuildContext context) {
    List<Widget> dividedItems = items;
    if (items.length > 1) {
      dividedItems = dividedItems.map<Widget>((Widget item) {
        if (dividedItems.last == item) {
          return item;
        } else {
          final leftPadding = item is SettingsItem
              ? (item.iconData == null ? 15.0 : 58.0)
              : 0.0;
          // Add inner dividers.
          return Stack(
            children: <Widget>[
              Positioned(
                bottom: 0.0,
                right: 0.0,
                left: leftPadding,
                child: new Container(
                  color: Styles.settingsLineation,
                  height: 0.3,
                ),
              ),
              item,
            ],
          );
        }
      }).toList();
    }

    final List<Widget> columnChildren = [];

    if (header != null) {
      columnChildren.add(DefaultTextStyle(
        style: TextStyle(
          color: CupertinoColors.inactiveGray,
          fontSize: 13.5,
          letterSpacing: -0.5,
        ),
        child: Padding(
          padding: EdgeInsets.only(
            left: 15.0,
            right: 15.0,
            bottom: 6.0,
          ),
          child: header,
        ),
      ));
    }

    columnChildren.add(
      Container(
        decoration: BoxDecoration(
          color: CupertinoColors.white,
          border: Border(
            top: const BorderSide(
              color: Styles.settingsLineation,
              width: 0.0,
            ),
            bottom: const BorderSide(
              color: Styles.settingsLineation,
              width: 0.0,
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: dividedItems,
        ),
      ),
    );

    if (footer != null) {
      columnChildren.add(DefaultTextStyle(
        style: TextStyle(
          color: Styles.settingsGroupSubtitle,
          fontSize: 13.0,
          letterSpacing: -0.08,
        ),
        child: Padding(
          padding: EdgeInsets.only(
            left: 15.0,
            right: 15.0,
            top: 7.5,
          ),
          child: footer,
        ),
      ));
    }

    return Padding(
      padding: EdgeInsets.only(
        top: header == null ? 35.0 : 22.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: columnChildren,
      ),
    );
  }
}
