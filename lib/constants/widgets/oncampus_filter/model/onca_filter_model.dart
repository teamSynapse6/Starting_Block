import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnCaFilterModel with ChangeNotifier {
  String _selectedProgram = "전체";
  String _selectedSorting = "최신순"; // 초기값을 사용자에게 보여줄 텍스트로 설정
  String get selectedProgram => _selectedProgram;
  String get selectedSorting => _selectedSorting;
  bool _hasChanged = false; // 변화 감지 플래그 추가
  bool get hasChanged => _hasChanged;

  OnCaFilterModel() {
    _loadSelectedProgram();
    _loadSelectedSorting();
  }

  void resetChangeFlag() {
    _hasChanged = false;
  }

  Future<void> _loadSelectedProgram() async {
    final prefs = await SharedPreferences.getInstance();
    _selectedProgram = prefs.getString('selectedProgram') ?? "전체";
    notifyListeners();
  }

  Future<void> _loadSelectedSorting() async {
    final prefs = await SharedPreferences.getInstance();
    String storedValue = prefs.getString('selectedOnCaSorting') ?? "latest";
    // 저장된 값에 따라 사용자에게 보여줄 텍스트로 변환
    _selectedSorting = storedValue == "latest"
        ? "최신순"
        : storedValue == "savedLot"
            ? "로드맵에 저장 많은 순"
            : "최신순";
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
  }

  void setSelectedProgram(String program) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedProgram', program);
    _hasChanged = true;
    _selectedProgram = program;
    notifyListeners();
  }

  void resetProgram() {
    setSelectedProgram("전체");
  }
}
