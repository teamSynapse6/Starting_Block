import 'package:shared_preferences/shared_preferences.dart';

class BookMarkManager {
  SharedPreferences? bookmarklist;

  Future<void> initPrefs() async {
    bookmarklist = await SharedPreferences.getInstance();
  }

  Future<bool> isBookMarked(String id) async {
    await initPrefs(); // bookmarklist 초기화 보장
    final bookMarked = bookmarklist?.getStringList('bookMarked') ?? [];
    return bookMarked.contains(id);
  }

  Future<void> toggleBookMark(String id) async {
    await initPrefs(); // bookmarklist 초기화 보장
    final bookMarked = bookmarklist?.getStringList('bookMarked') ?? [];
    if (bookMarked.contains(id)) {
      bookMarked.remove(id);
    } else {
      bookMarked.add(id);
    }
    await bookmarklist?.setStringList('bookMarked', bookMarked);
  }
}
