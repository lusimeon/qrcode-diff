import 'package:flutter/material.dart';

class ScanModel with ChangeNotifier {
  ScanModel();

  late String? _source;

  late String? _target;

  String? get result => _target;

  void setSource(String? source) {
    if (source == _source) return;

    _source = source;

    notifyListeners();
  }

  void setTarget(String? target) {
    if (target == _target) return;

    _target = target;

    notifyListeners();
  }
}
