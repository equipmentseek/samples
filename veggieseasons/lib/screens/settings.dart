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

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Preferred Categories'),
        previousPageTitle: 'Settings',
      ),
      backgroundColor: Styles.scaffoldBackground,
      child: FutureBuilder<Set<VeggieCategory>>(
        future: currentPrefs,
        builder: (context, snapshot) {
          final items = <SettingsItem>[];

          for (final category in VeggieCategory.values) {
            CupertinoSwitch toggle;

            // It's possible that category data hasn't loaded from shared prefs
            // yet, so display it if possible, and fall back to disabled
            // switches otherwise.
            if (snapshot.hasData) {
              toggle = CupertinoSwitch(
                value: snapshot.data.contains(category),
                onChanged: (isOn) {
                  if (isOn) {
                    model.addPreferredCategory(category);
                  } else {
                    model.removePreferredCategory(category);
                  }
                },
              );
            } else {
              toggle = CupertinoSwitch(
                value: false,
                onChanged: (value) {},
              );
            }

            items.add(SettingsItem(
              label: veggieCategoryNames[category],
              content: toggle,
            ));
          }

          return ListView(
            children: [
              SettingsGroup(
                items: items,
              ),
            ],
          );
        },
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

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Target Calorie Level'),
        previousPageTitle: 'Settings',
      ),
      backgroundColor: Styles.scaffoldBackground,
      child: ListView(
        children: [
          FutureBuilder<int>(
            future: model.desiredCalories,
            builder: (context, snapshot) {
              final steps = <SettingsItem>[];

              for (int cals = minCalories;
                  cals < maxCalories;
                  cals += calorieStep) {
                steps.add(
                  SettingsItem(
                    label: cals.toString(),
                    icon: SettingsIcon(
                      icon: Styles.checkIcon,
                      foregroundColor: snapshot.hasData && snapshot.data == cals
                          ? CupertinoColors.activeBlue
                          : Styles.transparentColor,
                      backgroundColor: Styles.transparentColor,
                    ),
                    onPress: snapshot.hasData
                        ? () {
                            model.setDesiredCalories(cals);
                          }
                        : null,
                  ),
                );
              }

              return SettingsGroup(
                items: steps,
                header: SettingsGroupHeader('Available calorie levels'),
                footer: SettingsGroupFooter('These are used for serving '
                    'calculations'),
              );
            },
          ),
        ],
      ),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  Widget _buildCaloriesItem(BuildContext context, Preferences prefs) {
    return SettingsItem(
      label: 'Target Calorie level',
      icon: SettingsIcon(
        backgroundColor: Styles.iconBlue,
        icon: Styles.calorieIcon,
      ),
      content: FutureBuilder<int>(
        future: prefs.desiredCalories,
        builder: (context, snapshot) => Text(snapshot.data?.toString() ?? ''),
      ),
      onPress: () {
        Navigator.of(context).push(
          CupertinoPageRoute(
            builder: (context) => CalorieSettingsScreen(),
          ),
        );
      },
    );
  }

  Widget _buildCategoriesItem(BuildContext context, Preferences prefs) {
    return SettingsItem(
      label: 'Preferred Categories',
      subtitle: 'What types of veggies you prefer!',
      icon: SettingsIcon(
        backgroundColor: Styles.iconGold,
        icon: Styles.preferenceIcon,
      ),
      content: SettingsNavigationIndicator(),
      onPress: () {
        Navigator.of(context).push(
          CupertinoPageRoute(
            builder: (context) => VeggieCategorySettingsScreen(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final prefs = ScopedModel.of<Preferences>(context, rebuildOnChange: true);

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
                        _buildCaloriesItem(context, prefs),
                        _buildCategoriesItem(context, prefs),
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
