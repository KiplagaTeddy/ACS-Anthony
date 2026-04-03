class CourseModel {
  final int id;
  final String code;
  final String name;
  final String department;
  final int credits;

  CourseModel({
    required this.id,
    required this.code,
    required this.name,
    required this.department,
    required this.credits,
  });

  factory CourseModel.fromJson(Map<String, dynamic> j) => CourseModel(
    id: int.parse(j['id'].toString()),
    code: j['code'] ?? '',
    name: j['name'] ?? '',
    department: j['department'] ?? '',
    credits: int.parse(j['credits'].toString()),
  );

  String get display => '$code — $name';
}
