import 'package:flutter/foundation.dart';

class UserGuideProvider with ChangeNotifier {
  String _guideName = '';

  String get guideName => _guideName;

  set guideName(String value) {
    _guideName = value;
    notifyListeners();
  }
}
