/// Dummy Data Repository
class Model {
  final String id;
  final String make;
  final String model;

  const Model({
    required this.id,
    required this.make,
    required this.model,
  });

  factory Model.fromJson(Map<String, dynamic> json) {
    return Model(
      id: json['id'],
      make: json['make'],
      model: json['model'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['make'] = make;
    data['model'] = model;
    return data;
  }
}
