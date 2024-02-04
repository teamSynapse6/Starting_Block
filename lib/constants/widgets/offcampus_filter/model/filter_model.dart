import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FilterModel extends ChangeNotifier {
  String _selectedSupportType = "전체";
  String _selectedResidence = "전체";
  String _selectedEntrepreneur = "전체";

  FilterModel() {
    _loadFilterValues();
  }

  // SharedPreferences에서 필터 값을 로드하는 메서드
  Future<void> _loadFilterValues() async {
    final prefs = await SharedPreferences.getInstance();
    _selectedSupportType = prefs.getString('selectedSupportType') ?? "전체";
    _selectedResidence = prefs.getString('selectedResidence') ?? "전체";
    _selectedEntrepreneur = prefs.getString('selectedEntrepreneur') ?? "전체";
    notifyListeners();
  }

  // Getter 메서드
  String get selectedSupportType => _selectedSupportType;
  String get selectedResidence => _selectedResidence;
  String get selectedEntrepreneur => _selectedEntrepreneur;

  // Setter 메서드
  void setSelectedSupportType(String newValue) {
    if (_selectedSupportType != newValue) {
      _selectedSupportType = newValue;
      saveFilterList(); // 필터 리스트 저장
      notifyListeners();
    }
  }

  void setSelectedResidence(String newValue) {
    if (_selectedResidence != newValue) {
      _selectedResidence = newValue;
      saveFilterList(); // 필터 리스트 저장
      notifyListeners();
    }
  }

  void setSelectedEntrepreneur(String newValue) {
    if (_selectedEntrepreneur != newValue) {
      _selectedEntrepreneur = newValue;
      saveFilterList(); // 필터 리스트 저장
      notifyListeners();
    }
  }

  // 필터 값들을 저장하는 메서드
  Future<void> saveFilterList() async {
    final prefs = await SharedPreferences.getInstance();
    String filterList =
        '$_selectedSupportType,$_selectedResidence,$_selectedEntrepreneur';
    await prefs.setString('filterlist', filterList);

    print('필터리스트: $filterList');
  }

  // 모든 선택 사항을 "전체"로 초기화하는 메서드
  void resetFilters() {
    _selectedSupportType = "전체";
    _selectedResidence = "전체";
    _selectedEntrepreneur = "전체";
    saveFilterList(); // 필터 리스트 저장
    notifyListeners();
  }
}
