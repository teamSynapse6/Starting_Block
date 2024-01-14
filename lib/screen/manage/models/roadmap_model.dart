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

// 로드맵 항목 삭제 메소드
  void removeAt(int index) async {
    if (index >= 0 && index < _roadmapList.length) {
      String itemName = _roadmapList[index];

      // roadmapList에서 항목 삭제
      _roadmapList.removeAt(index);
      saveRoadmapList();

      // SharedPreferences에서 해당 itemName을 키로 사용하는 데이터 삭제
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(itemName);

      notifyListeners(); // 변경 사항을 리스너들에게 알립니다.
    }
  }

  /* 여기부터 로드맵 내 북마크 저장 기능*/

  // 로드맵 아이템 저장 기능
  void saveRoadmapItem(
      String id, String classification, String itemName) async {
    final prefs = await SharedPreferences.getInstance();
    String key = itemName; // roadmap 항목 이름을 키로 사용
    List<Map<String, dynamic>> savedItems = [];

    String? existingItemsString = prefs.getString(key);
    if (existingItemsString != null) {
      savedItems =
          List<Map<String, dynamic>>.from(json.decode(existingItemsString));
    }

    Map<String, dynamic> newItem = {'id': id, 'classification': classification};

    // 이미 저장된 아이템이 아니라면 추가
    if (!savedItems.any((item) =>
        item['id'] == id && item['classification'] == classification)) {
      savedItems.add(newItem);
      String encodedItems = json.encode(savedItems);
      prefs.setString(key, encodedItems);

      // 저장된 키와 값 출력
      print("Saved under key: $key");
      print("Saved value: $encodedItems");
    }
    notifyListeners(); // UI 업데이트를 위해 호출
  }

// 로드맵 리스트에 아이템이 이미 저장되었는지 확인하는 메소드
  Future<bool> isItemSaved(
      String id, String classification, String itemName) async {
    final prefs = await SharedPreferences.getInstance();
    String? itemsString = prefs.getString(itemName);
    if (itemsString == null) return false;

    List<dynamic> items = json.decode(itemsString);
    return items.any(
        (item) => item['id'] == id && item['classification'] == classification);
  }

// 저장된 아이템을 삭제하는 메소드
  Future<void> removeSavedItem(
      String id, String classification, String itemName) async {
    final prefs = await SharedPreferences.getInstance();
    String? itemsString = prefs.getString(itemName);
    if (itemsString == null) return;

    List<Map<String, dynamic>> items =
        List<Map<String, dynamic>>.from(json.decode(itemsString));
    items.removeWhere(
        (item) => item['id'] == id && item['classification'] == classification);

    await prefs.setString(itemName, json.encode(items));
    notifyListeners();
  }

// 특정 id를 포함하는 roadmapList 항목이 있는지 확인하는 메소드
  Future<bool> hasSavedItems(String id) async {
    final prefs = await SharedPreferences.getInstance();
    bool hasSavedItems = false;

    for (String key in _roadmapList) {
      String? itemsString = prefs.getString(key);
      if (itemsString != null) {
        List<dynamic> items = json.decode(itemsString);
        if (items.any((item) => item['id'] == id)) {
          hasSavedItems = true;
          break;
        }
      }
    }

    return hasSavedItems;
  }
}
