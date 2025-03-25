import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../domain/models/flight_record.dart';

class FlightRecordViewModel extends ChangeNotifier {
  List<FlightRecord> _records = [];
  bool _isLoading = false;

  List<FlightRecord> get records => _records;
  bool get isLoading => _isLoading;

  get themeMode => null;

  Future<void> loadRecords() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final String? recordsJson = prefs.getString('flight_records');

      if (recordsJson != null) {
        final List<dynamic> decoded = json.decode(recordsJson);
        _records = decoded.map((json) => FlightRecord.fromJson(json)).toList();
      }
    } catch (e) {
      debugPrint('Error loading records: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> saveRecords() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String encoded = json.encode(
        _records.map((record) => record.toJson()).toList(),
      );
      await prefs.setString('flight_records', encoded);
    } catch (e) {
      debugPrint('Error saving records: $e');
    }
  }

  void addRecord(FlightRecord record) {
    _records.add(record);
    saveRecords();
    notifyListeners();
  }

  void updateRecord(FlightRecord record) {
    final index = _records.indexWhere((r) => r.id == record.id);
    if (index != -1) {
      _records[index] = record;
      saveRecords();
      notifyListeners();
    }
  }

  void deleteRecord(String id) {
    _records.removeWhere((record) => record.id == id);
    saveRecords();
    notifyListeners();
  }

  FlightRecord? getRecordById(String id) {
    return _records.firstWhere((record) => record.id == id);
  }

  void sortRecordsByCreation(bool isAscending) {}
}
