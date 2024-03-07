import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FilterModel extends ChangeNotifier {
  String _selectedSupportType = "전체";
  String _selectedResidence = "전체";
  String _selectedEntrepreneur = "전체";
  String _selectedSorting = "최신순"; // 정렬 상태 추가
  String get selectedSorting => _selectedSorting;
  bool _hasChanged = false; // 변화 감지 플래그 추가
  bool get hasChanged => _hasChanged; // 변화가 있는지 확인하는 메서드

  // 변화 플래그를 리셋하는 메서드
  void resetChangeFlag() {
    _hasChanged = false;
  }

  FilterModel() {
    _loadFilterValues();
  }

  // SharedPreferences에서 필터 값을 로드하는 메서드
  Future<void> _loadFilterValues() async {
    final prefs = await SharedPreferences.getInstance();
    _selectedSorting =
        prefs.getString('selectedSorting') ?? "최신순"; // 직접 저장된 값으로 로드합니다.
  }

  // Getter 메서드
  String get selectedSupportType => _selectedSupportType;
  String get selectedResidence => _selectedResidence;
  String get selectedEntrepreneur => _selectedEntrepreneur;

  // Setter 메서드
  void setSelectedSupportType(String newValue) {
    if (_selectedSupportType != newValue) {
      _selectedSupportType = newValue;
      _hasChanged = true; // 플래그 업데이트
      notifyListeners();
    }
  }

  void setSelectedResidence(String newValue) {
    if (_selectedResidence != newValue) {
      _selectedResidence = newValue;
      _hasChanged = true;
      notifyListeners();
    }
  }

  void setSelectedEntrepreneur(String newValue) {
    if (_selectedEntrepreneur != newValue) {
      _selectedEntrepreneur = newValue;
      _hasChanged = true; // 플래그 업데이트
      notifyListeners();
    }
  }

  // 정렬 상태 저장 메서드
  Future<void> saveSortingPreference() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedSorting', _selectedSorting);
  }

  // 기존의 setter에서 saveSortingPreference 호출 추가
  set selectedSorting(String newValue) {
    if (_selectedSorting != newValue) {
      _selectedSorting = newValue;
      _hasChanged = true;
      saveSortingPreference(); // 정렬 상태 저장
      notifyListeners();
    }
  }
}
