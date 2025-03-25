class LoadModel {
  final String id;
  final String name;
  final double currentLoad;
  final double maxLoad;
  final bool isActive;
  final DateTime lastUpdated;

  LoadModel({
    required this.id,
    required this.name,
    required this.currentLoad,
    required this.maxLoad,
    required this.isActive,
    required this.lastUpdated,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'currentLoad': currentLoad,
      'maxLoad': maxLoad,
      'isActive': isActive,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  factory LoadModel.fromJson(Map<String, dynamic> json) {
    return LoadModel(
      id: json['id'],
      name: json['name'],
      currentLoad: json['currentLoad'].toDouble(),
      maxLoad: json['maxLoad'].toDouble(),
      isActive: json['isActive'],
      lastUpdated: DateTime.parse(json['lastUpdated']),
    );
  }
}
