import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../domain/models/load_model.dart';

class LoadControlViewModel extends ChangeNotifier {
  List<LoadModel> _loads = [];
  bool _isLoading = false;

  List<LoadModel> get loads => _loads;
  bool get isLoading => _isLoading;

  Future<void> loadData() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final String? loadsJson = prefs.getString('loads');

      if (loadsJson != null) {
        final List<dynamic> decoded = List<dynamic>.from(
          const JsonDecoder().convert(loadsJson),
        );
        _loads = decoded.map((json) => LoadModel.fromJson(json)).toList();
      }
    } catch (e) {
      debugPrint('Error loading data: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> saveData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String encoded = const JsonEncoder().convert(
        _loads.map((load) => load.toJson()).toList(),
      );
      await prefs.setString('loads', encoded);
    } catch (e) {
      debugPrint('Error saving data: $e');
    }
  }

  void addLoad(LoadModel load) {
    _loads.add(load);
    saveData();
    notifyListeners();
  }

  void updateLoad(LoadModel load) {
    final index = _loads.indexWhere((l) => l.id == load.id);
    if (index != -1) {
      _loads[index] = load;
      saveData();
      notifyListeners();
    }
  }

  void deleteLoad(String id) {
    _loads.removeWhere((load) => load.id == id);
    saveData();
    notifyListeners();
  }

  void toggleLoadStatus(String id) {
    final index = _loads.indexWhere((load) => load.id == id);
    if (index != -1) {
      final load = _loads[index];
      _loads[index] = LoadModel(
        id: load.id,
        name: load.name,
        currentLoad: load.currentLoad,
        maxLoad: load.maxLoad,
        isActive: !load.isActive,
        lastUpdated: DateTime.now(),
      );
      saveData();
      notifyListeners();
    }
  }
}
