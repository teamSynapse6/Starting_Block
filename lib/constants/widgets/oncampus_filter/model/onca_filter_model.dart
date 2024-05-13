import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnCaFilterModel with ChangeNotifier {
  String _selectedProgram = "전체";
  String _selectedSorting = "최신순"; // 초기값을 사용자에게 보여줄 텍스트로 설정

  //getter 메소드
  String get selectedProgram => _selectedProgram;
  String get selectedSorting => _selectedSorting;
  bool _hasChanged = false; // 변화 감지 플래그 추가
  bool get hasChanged => _hasChanged;

  void resetChangeFlag() {
    _hasChanged = false;
  }

  void setSelectedProgram(String newProgram) async {
    _selectedProgram = newProgram;
    _hasChanged = true;
    notifyListeners();
  }

  set selectedSorting(String newValue) {
    if (_selectedSorting != newValue) {
      _selectedSorting = newValue;
      _hasChanged = true;
      saveSortingPreference();
      notifyListeners();
    }
  }

  Future<void> saveSortingPreference() async {
    final prefs = await SharedPreferences.getInstance();
    String sortingValue = _selectedSorting == "최신순" ? "latest" : "savedLot";
    await prefs.setString('selectedOnCaSorting', sortingValue);
    _hasChanged = true;
    notifyListeners();
  }
}
