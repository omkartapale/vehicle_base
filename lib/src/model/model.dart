/// Dummy Data Repository
class Model {
  final String id;
  final String make;
  final String name;

  const Model({
    required this.id,
    required this.make,
    required this.name,
  });

  factory Model.fromJson(Map<String, dynamic> json) {
    return Model(
      id: json['id'],
      make: json['make'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['make'] = make;
    data['name'] = name;
    return data;
  }
}
