// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:scoped_model/scoped_model.dart';
import 'package:veggieseasons/data/veggie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Preferences extends Model {
  Preferences() {
    _load();
  }

  static const caloriesKey = 'calories';
  static const preferredCategoriesKey = 'preferredCategories';

  int _desiredCalories = 2000;

  int get desiredCalories => _desiredCalories;

  Set<VeggieCategory> _preferredCategories = Set<VeggieCategory>();

  Set<VeggieCategory> get preferredCategories => _preferredCategories;

  void addPreferredCategory(VeggieCategory category) {
    _preferredCategories.add(category);
    _save();
    notifyListeners();
  }

  void removePreferredCategory(VeggieCategory category) {
    _preferredCategories.remove(category);
    _save();
    notifyListeners();
  }

  void setDesiredCalories(int calories) {
    _desiredCalories = calories;
    _save();
    notifyListeners();
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt(caloriesKey, _desiredCalories);

    // Store preferred categories as a comma-separated string containing their
    // indices.
    prefs.setString(preferredCategoriesKey,
        _preferredCategories.map((c) => c.index.toString()).join(','));
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    _desiredCalories = prefs.getInt(caloriesKey) ?? 2000;
    _preferredCategories.clear();
    final names = prefs.getString(preferredCategoriesKey) ?? '';

    for (final name in names.split(',')) {
      final index = int.parse(name) ?? 0;
      if (VeggieCategory.values[index] != null) {
        _preferredCategories.add(VeggieCategory.values[index]);
      }
    }

    notifyListeners();
  }
}
