import 'package:shared_preferences/shared_preferences.dart';

typedef OnSearchUpdate = void Function();

class RecentSearchManager {
  static const _storageKey = 'recentSearch';
  static const _maxSearchCount = 5; // 최대 저장할 수 있는 검색어 개수

  OnSearchUpdate? onSearchUpdate;

  Future<List<String>> loadRecentSearches() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_storageKey) ?? [];
  }

  // 콜백 함수 호출을 위한 공통 메소드
  void _notifySearchUpdate() {
    if (onSearchUpdate != null) {
      onSearchUpdate!();
    }
  }

  Future<void> addSearch(String query) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> recentSearches = await loadRecentSearches();

    // 이미 있는 검색어 제거
    recentSearches.remove(query);

    // 새로운 검색어를 리스트의 앞에 추가
    recentSearches.insert(0, query);

    // 검색어 리스트가 최대 개수를 초과하는 경우, 가장 오래된 검색어 삭제
    if (recentSearches.length > _maxSearchCount) {
      recentSearches.removeLast();
    }

    await prefs.setStringList(_storageKey, recentSearches);
    _notifySearchUpdate();
  }

  Future<void> deleteSearch(String search) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> recentSearches = await loadRecentSearches();
    recentSearches.remove(search);
    await prefs.setStringList(_storageKey, recentSearches);
    _notifySearchUpdate();
  }

  Future<void> deleteAllSearches() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_storageKey, []); // 모든 검색어를 삭제
    _notifySearchUpdate();
  }
}
