/// Dummy Data Repository
class Make {
  final String? id;
  final String name;
  final String lowercasedName;

  const Make({
    this.id,
    required this.name,
    required this.lowercasedName,
  });

  factory Make.fromJson(Map<String, dynamic> json) {
    return Make(
      id: json['id'],
      name: json['name'],
      lowercasedName: json['lowercasedName'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['lowercasedName'] = lowercasedName;
    return data;
  }
}
