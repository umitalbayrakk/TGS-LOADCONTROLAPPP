class CargoInfo {
  final String id;
  final String cargoFlag;
  final String loadingNumber;
  final String loadingInstructions;
  final String loadingChange;
  final String loadPlan;
  final String loadPlanDelivery;
  final String loadPageCompatibility;
  final DateTime createdAt;

  CargoInfo({
    required this.id,
    required this.cargoFlag,
    required this.loadingNumber,
    required this.loadingInstructions,
    required this.loadingChange,
    required this.loadPlan,
    required this.loadPlanDelivery,
    required this.loadPageCompatibility,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cargoFlag': cargoFlag,
      'loadingNumber': loadingNumber,
      'loadingInstructions': loadingInstructions,
      'loadingChange': loadingChange,
      'loadPlan': loadPlan,
      'loadPlanDelivery': loadPlanDelivery,
      'loadPageCompatibility': loadPageCompatibility,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory CargoInfo.fromJson(Map<String, dynamic> json) {
    return CargoInfo(
      id: json['id'],
      cargoFlag: json['cargoFlag'],
      loadingNumber: json['loadingNumber'],
      loadingInstructions: json['loadingInstructions'],
      loadingChange: json['loadingChange'],
      loadPlan: json['loadPlan'],
      loadPlanDelivery: json['loadPlanDelivery'],
      loadPageCompatibility: json['loadPageCompatibility'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
