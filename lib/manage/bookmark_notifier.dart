import 'package:flutter/foundation.dart';

class BookMarkNotifier extends ChangeNotifier {
  bool _isUpdated = false;

  bool get isUpdated => _isUpdated;

  void updateBookmark() {
    _isUpdated = !_isUpdated;
    notifyListeners();
  }

  void resetUpdate() {
    _isUpdated = false;
  }
}
