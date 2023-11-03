/// Dummy Data Repository
class Make {
  final String id;
  final String make;

  const Make({
    required this.id,
    required this.make,
  });

  factory Make.fromJson(Map<String, dynamic> json) {
    return Make(
      id: json['id'],
      make: json['make'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['make'] = make;
    return data;
  }
}
