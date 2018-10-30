// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:veggieseasons/data/preferences.dart';
import 'package:veggieseasons/data/veggie.dart';
import 'package:veggieseasons/styles.dart';
import 'package:veggieseasons/widgets/settings_group.dart';
import 'package:veggieseasons/widgets/settings_item.dart';

class VeggieTypeSettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final model = ScopedModel.of<Preferences>(context);
    final currentPrefs = model.preferredCategories;

    final items = VeggieCategory.values
        .map<Widget>((c) => SettingsItem(
              label: veggieCategoryNames[c],
              type: SettingsItemType.toggle,
            ))
        .toList();

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Preferred Produce Types'),
      ),
      backgroundColor: Styles.scaffoldBackground,
      child: ListView(
        children: [
          SettingsGroup(items),
        ],
      ),
    );
  }
}

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Container(
        color: Styles.scaffoldBackground,
        child: CustomScrollView(
          slivers: <Widget>[
            CupertinoSliverNavigationBar(
              largeTitle: Text('Settings'),
            ),
            SliverSafeArea(
              top: false,
              // This is just a big list of all the items in the settings.
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  <Widget>[
                    SettingsGroup(
                      <Widget>[
                        SettingsItem(
                          label: 'Notifications',
                          color: Styles.iconBlue,
                          iconData: Styles.reminderIcon,
                          type: SettingsItemType.toggle,
                        ),
                        SettingsItem(
                          label: 'Preferred Produce',
                          color: Styles.iconGold,
                          iconData: Styles.listIcon,
                          type: SettingsItemType.modal,
                          hasDetails: true,
                          onPress: () {
                            Navigator.of(context).push(CupertinoPageRoute(
                                builder: (context) =>
                                    VeggieTypeSettingsScreen()));
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
