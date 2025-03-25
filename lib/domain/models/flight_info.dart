class FlightInfo {
  final String id;
  final String team;
  final String flightNumber;
  final String tailNumber;
  final String parkingPosition;
  final String operationsOfficer;
  final String postMaster;
  final DateTime createdAt;

  FlightInfo({
    required this.id,
    required this.team,
    required this.flightNumber,
    required this.tailNumber,
    required this.parkingPosition,
    required this.operationsOfficer,
    required this.postMaster,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'team': team,
      'flightNumber': flightNumber,
      'tailNumber': tailNumber,
      'parkingPosition': parkingPosition,
      'operationsOfficer': operationsOfficer,
      'postMaster': postMaster,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory FlightInfo.fromJson(Map<String, dynamic> json) {
    return FlightInfo(
      id: json['id'],
      team: json['team'],
      flightNumber: json['flightNumber'],
      tailNumber: json['tailNumber'],
      parkingPosition: json['parkingPosition'],
      operationsOfficer: json['operationsOfficer'],
      postMaster: json['postMaster'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
