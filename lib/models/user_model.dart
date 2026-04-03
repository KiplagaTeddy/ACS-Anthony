class UserModel {
  final int id;
  final String name;
  final String email;
  final int? studentId;
  final String? regNumber;
  final String? department;
  final String? yearOfStudy;
  final String? phone;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.studentId,
    this.regNumber,
    this.department,
    this.yearOfStudy,
    this.phone,
  });

  factory UserModel.fromJson(Map<String, dynamic> j) => UserModel(
    id: int.parse(j['id'].toString()),
    name: j['name'] ?? '',
    email: j['email'] ?? '',
    studentId: j['student_id'] != null
        ? int.parse(j['student_id'].toString())
        : null,
    regNumber: j['reg_number'],
    department: j['department'],
    yearOfStudy: j['year_of_study'],
    phone: j['phone'],
  );
}
