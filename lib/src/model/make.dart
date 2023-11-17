/// Dummy Data Repository
class Make {
  final String? id;
  final String name;

  const Make({
    this.id,
    required this.name,
  });

  factory Make.fromJson(Map<String, dynamic> json) {
    return Make(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}
