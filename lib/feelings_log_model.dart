import 'dart:collection';

import 'package:flutter/material.dart';

class FeelingsLogModel extends ChangeNotifier {
  final List<String> _selectedEmotions = [];

  UnmodifiableListView<String> get selectedEmotions =>
      UnmodifiableListView(_selectedEmotions);

  void add(String emotion) {
    _selectedEmotions.add(emotion);
    notifyListeners();
  }

  void remove(emotion) {
    _selectedEmotions.remove(emotion);
    notifyListeners();
  }
}
