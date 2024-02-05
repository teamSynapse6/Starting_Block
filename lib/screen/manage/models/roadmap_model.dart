// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class RoadMapModel extends ChangeNotifier {
  List<String> _roadmapList = [];
  List<String?> _roadmapListCheck = []; // 추가된 리스트
  List<String> get roadmapList => _roadmapList;
  bool _hasUpdated = false;
  bool get hasUpdated => _hasUpdated;

  RoadMapModel() {
    _loadRoadmapList(); // 기존 로드맵 리스트 로드
    _loadRoadmapListCheck(); // 추가된 로드맵 리스트 체크 로드
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
  void reorderRoadmapList(List<String> newList, List<String?> newCheckList) {
    _roadmapList = List<String>.from(newList);
    _roadmapListCheck = List<String?>.from(newCheckList);

    // '현단계'가 있는 인덱스 찾기
    int currentStageIndex = _roadmapListCheck.indexOf('현단계');

    // '현단계' 이전 항목들을 '도약완료'로 설정하고, 이후 항목들은 null로 설정
    for (int i = 0; i < _roadmapListCheck.length; i++) {
      if (i < currentStageIndex) {
        _roadmapListCheck[i] = '도약완료';
      } else if (i > currentStageIndex) {
        _roadmapListCheck[i] = null;
      }
      // '현단계' 자체는 변경하지 않음
    }

    saveRoadmapList(); // 변경 사항을 SharedPreferences에 저장합니다.
    _saveRoadmapListCheck(); // 변경된 roadmapListCheck 저장
    notifyListeners(); // 변경 사항을 알립니다.

    print('로드맵 순서: $_roadmapList');
    print('단계체킹: $_roadmapListCheck');
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

// 로드맵 신규 저장 기능
  void addNewItem(String newItem) {
    if (newItem.isNotEmpty) {
      _roadmapList.add(newItem);

      // 새로 추가된 항목이 리스트의 첫 번째라면 '현단계'로 설정합니다.
      // 그렇지 않은 경우 null (아직 도달하지 않은 단계)로 설정합니다.
      if (_roadmapList.length == 1) {
        _roadmapListCheck.add('현단계');
      } else {
        _roadmapListCheck.add(null);
      }

      saveRoadmapList();
      _saveRoadmapListCheck(); // roadmapListCheck 변경 사항 저장
      notifyListeners();
    }
  }

// 로드맵 항목 삭제 메소드
  void removeAt(int index) async {
    if (index >= 0 && index < _roadmapList.length) {
      bool isCurrentStage = _roadmapListCheck[index] == '현단계';

      // roadmapList에서 해당 항목 삭제
      _roadmapList.removeAt(index);
      // roadmapListCheck에서 해당 항목 삭제
      _roadmapListCheck.removeAt(index);

      // 삭제된 항목이 '현단계'였고, 첫 번째 항목이라면 다음 항목을 '현단계'로 설정
      if (isCurrentStage) {
        if (index == 0 && _roadmapListCheck.isNotEmpty) {
          _roadmapListCheck[0] = '현단계';
        } else if (index > 0) {
          // 삭제된 항목이 첫 번째 항목이 아니면 이전 항목을 새로운 '현단계'로 설정
          _roadmapListCheck[index - 1] = '현단계';
        }
      }

      saveRoadmapList(); // 변경된 roadmapList를 SharedPreferences에 저장
      notifyListeners(); // 변경 사항 리스너들에게 알림
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
      print('저장된 리스트: $savedItems');
    }
    _hasUpdated = true;
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
    _hasUpdated = true;
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

  void resetUpdateFlag() {
    _hasUpdated = false;
  }

  /* 여기부터 로드맵 내 단계 체킹 기능*/
  List<String?> get roadmapListCheck => _roadmapListCheck;

  // SharedPreferences에서 roadmapListCheck를 불러오는 메소드
  Future<void> _loadRoadmapListCheck() async {
    final prefs = await SharedPreferences.getInstance();
    String? roadmapListCheckString = prefs.getString('roadmapListCheck');
    if (roadmapListCheckString != null) {
      // 기존에 저장된 roadmapListCheck가 있으면 불러오기
      _roadmapListCheck =
          List<String?>.from(json.decode(roadmapListCheckString));
    } else {
      // 저장된 roadmapListCheck가 없는 경우
      _roadmapListCheck =
          List<String?>.filled(_roadmapList.length, null, growable: true);
      if (_roadmapList.isNotEmpty) {
        // roadmapList의 첫 번째 항목을 '현단계'로 설정
        _roadmapListCheck[0] = '현단계';
      }
    }
  }

  // roadmapListCheck를 저장하는 메소드
  Future<void> _saveRoadmapListCheck() async {
    final prefs = await SharedPreferences.getInstance();
    String roadmapListCheckString = json.encode(_roadmapListCheck);
    await prefs.setString('roadmapListCheck', roadmapListCheckString);
    notifyListeners(); // 변경 사항 리스너들에게 알림
  }

  void setCurrentStage(int index) {
    for (int i = 0; i < _roadmapListCheck.length; i++) {
      if (i < index) {
        _roadmapListCheck[i] = '도약완료';
      } else if (i == index) {
        _roadmapListCheck[i] = '현단계';
      } else {
        _roadmapListCheck[i] = null;
      }
    }
    _saveRoadmapListCheck();
  }

  // 현 단계를 다음 항목으로 이동하는 메소드
  void moveToNextStage() {
    int currentStageIndex = _roadmapListCheck.indexOf('현단계');
    if (currentStageIndex != -1 &&
        currentStageIndex < _roadmapListCheck.length - 1) {
      // 현재 '현 단계'를 '도약완료'로 변경
      _roadmapListCheck[currentStageIndex] = '도약완료';

      // 다음 항목을 '현 단계'로 설정
      _roadmapListCheck[currentStageIndex + 1] = '현단계';
    }

    _saveRoadmapListCheck();
    notifyListeners();
  }
}
