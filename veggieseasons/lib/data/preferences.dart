// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:scoped_model/scoped_model.dart';
import 'package:veggieseasons/data/veggie.dart';

class Preferences extends Model {
  int _desiredCalories = 2000;

  int get desiredCalories => _desiredCalories;

  List<VeggieCategory> _preferredCategories = <VeggieCategory>[
    VeggieCategory.gourd,
    VeggieCategory.stealthFruit,
  ];

  List<VeggieCategory> get preferredCategories =>
      List<VeggieCategory>.from(_preferredCategories);

  Future<void> _updateFromStorage() async {}

  Future<void> _saveToStorage() async {}
}
