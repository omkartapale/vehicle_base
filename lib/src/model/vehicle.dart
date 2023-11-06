/// Dummy Data Repository
class Vehicle {
  final String id;
  final String make;
  final String model;
  final String? variant;

  const Vehicle({
    required this.id,
    required this.make,
    required this.model,
    this.variant,
  });

  String get vehicleDetails {
    List<String> details = [];
    details.add(make);
    variant != null ? details.add(variant!) : '';
    return details.join(' \u2022 ');
  }

  String get name {
    List<String> details = [];
    details.add(make);
    details.add(model);
    variant != null ? details.add(variant!) : '';
    return details.join(' ');
  }

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      id: json['id'],
      make: json['make'],
      model: json['model'],
      variant: json['variant'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['make'] = make;
    data['model'] = model;
    data['variant'] = variant;
    return data;
  }
}
