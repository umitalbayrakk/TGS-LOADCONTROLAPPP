import 'flight_info.dart';
import 'cargo_info.dart';
import 'note.dart';
import 'image.dart';

class FlightRecord {
  final String id;
  final FlightInfo flightInfo;
  final CargoInfo cargoInfo;
  final Note note;
  final List<ImageModel> images;
  final DateTime createdAt;

  FlightRecord({
    required this.id,
    required this.flightInfo,
    required this.cargoInfo,
    required this.note,
    required this.images,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'flightInfo': flightInfo.toJson(),
      'cargoInfo': cargoInfo.toJson(),
      'note': note.toJson(),
      'images': images.map((image) => image.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory FlightRecord.fromJson(Map<String, dynamic> json) {
    return FlightRecord(
      id: json['id'],
      flightInfo: FlightInfo.fromJson(json['flightInfo']),
      cargoInfo: CargoInfo.fromJson(json['cargoInfo']),
      note: Note.fromJson(json['note']),
      images: (json['images'] as List)
          .map((image) => ImageModel.fromJson(image))
          .toList(),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
