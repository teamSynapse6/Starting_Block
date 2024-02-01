import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnCaFilterModel with ChangeNotifier {
  String _selectedProgram = "전체";

  OnCaFilterModel() {
    _loadSelectedProgram();
  }

  String get selectedProgram => _selectedProgram;

  Future<void> _loadSelectedProgram() async {
    final prefs = await SharedPreferences.getInstance();
    _selectedProgram = prefs.getString('selectedProgram') ?? "전체";
    notifyListeners();
  }

  void setSelectedProgram(String program) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedProgram', program);
    _selectedProgram = program;
    notifyListeners();
  }

  void resetProgram() {
    setSelectedProgram("전체");
  }
}
