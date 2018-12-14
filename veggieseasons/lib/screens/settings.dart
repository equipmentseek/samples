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

class VeggieCategorySettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final model = ScopedModel.of<Preferences>(context, rebuildOnChange: true);
    final currentPrefs = model.preferredCategories;

    final items = VeggieCategory.values
        .map<SettingsItem>((c) => SettingsItem(
              label: veggieCategoryNames[c],
              content: CupertinoSwitch(
                value: currentPrefs.contains(c),
                onChanged: (isOn) {
                  if (isOn) {
                    model.addPreferredCategory(c);
                  } else {
                    model.removePreferredCategory(c);
                  }
                },
              ),
            ))
        .toList();

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Preferred Categories'),
        previousPageTitle: 'Settings',
      ),
      backgroundColor: Styles.scaffoldBackground,
      child: ListView(
        children: [
          SettingsGroup(
            items: items,
          ),
        ],
      ),
    );
  }
}

class CalorieSettingsScreen extends StatelessWidget {
  static const minCalories = 1000;
  static const maxCalories = 2600;
  static const calorieStep = 200;

  @override
  Widget build(BuildContext context) {
    final model = ScopedModel.of<Preferences>(context, rebuildOnChange: true);

    final steps = <SettingsItem>[];

    for (int cals = minCalories; cals < maxCalories; cals += calorieStep) {
      steps.add(
        SettingsItem(
          label: cals.toString(),
          icon: model.desiredCalories == cals
              ? SettingsIcon(
                  icon: Styles.checkIcon,
                  foregroundColor: CupertinoColors.activeBlue,
                  backgroundColor: Styles.transparentColor,
                )
              : null,
          onPress: () {
            model.setDesiredCalories(cals);
          },
        ),
      );
    }

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Target Calorie Level'),
        previousPageTitle: 'Settings',
      ),
      backgroundColor: Styles.scaffoldBackground,
      child: ListView(
        children: [
          SettingsGroup(
            items: steps,
            header: SettingsGroupHeader('Available calorie levels'),
            footer: SettingsGroupFooter('These are used for serving '
                'calculations'),
          ),
        ],
      ),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final model = ScopedModel.of<Preferences>(context, rebuildOnChange: true);

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
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  <Widget>[
                    SettingsGroup(
                      items: [
                        SettingsItem(
                          label: 'Target Calorie level',
                          icon: SettingsIcon(
                            backgroundColor: Styles.iconBlue,
                            icon: Styles.calorieIcon, /**/
                          ),
                          content: Text(model.desiredCalories.toString()),
                          onPress: () {
                            Navigator.of(context).push(
                              CupertinoPageRoute(
                                builder: (context) => CalorieSettingsScreen(),
                              ),
                            );
                          },
                        ),
                        SettingsItem(
                          label: 'Preferred Catgories',
                          subtitle: 'What types of veggies you prefer!',
                          icon: SettingsIcon(
                            backgroundColor: Styles.iconGold,
                            icon: Styles.preferenceIcon,
                          ),
                          content: SettingsNavigationIndicator(),
                          onPress: () {
                            Navigator.of(context).push(
                              CupertinoPageRoute(
                                builder: (context) =>
                                    VeggieCategorySettingsScreen(),
                              ),
                            );
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
