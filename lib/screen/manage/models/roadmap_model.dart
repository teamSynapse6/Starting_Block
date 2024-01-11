import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class RoadMapModel extends ChangeNotifier {
  List<String> _roadmapList = [];

  List<String> get roadmapList => _roadmapList;

  RoadMapModel() {
    _loadRoadmapList();
  }

  Future<void> _loadRoadmapList() async {
    final prefs = await SharedPreferences.getInstance();
    String? roadmapListString = prefs.getString('roadmapList');
    if (roadmapListString != null) {
      _roadmapList = List<String>.from(json.decode(roadmapListString));
      notifyListeners(); // 변경 사항을 리스너들에게 알립니다.
    }
  }

  // 항목의 순서를 변경하는 메소드
  void reorderRoadmapList(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    final item = _roadmapList.removeAt(oldIndex);
    _roadmapList.insert(newIndex, item);
    saveRoadmapList(); // 변경 사항을 SharedPreferences에 저장합니다.
    notifyListeners(); // 변경 사항을 알립니다.
  }

  Future<void> saveRoadmapList() async {
    final prefs = await SharedPreferences.getInstance();
    String roadmapListString = json.encode(_roadmapList);
    await prefs.setString('roadmapList', roadmapListString);
  }

  void updateRoadmapList(List<String> newList) {
    _roadmapList = newList;
    saveRoadmapList(); // 변경 사항을 SharedPreferences에 저장합니다.
    notifyListeners(); // 변경 사항을 알립니다.
  }

  //로드맵 신규 저장 기능
  void addNewItem(String newItem) {
    if (newItem.isNotEmpty) {
      _roadmapList.add(newItem);
      saveRoadmapList();
      notifyListeners();
    }
  }

  //로드맵 삭제 기능
  void removeAt(int index) {
    if (index >= 0 && index < _roadmapList.length) {
      _roadmapList.removeAt(index);
      saveRoadmapList();
      notifyListeners();
    }
  }
}
