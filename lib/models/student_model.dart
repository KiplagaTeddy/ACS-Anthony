class StudentModel {
  final int userId;
  final int studentId;
  final String name;
  final String email;
  final String regNumber;
  final String department;
  final String yearOfStudy;
  final String phone;
  final String? photo;

  StudentModel({
    required this.userId,
    required this.studentId,
    required this.name,
    required this.email,
    required this.regNumber,
    required this.department,
    required this.yearOfStudy,
    required this.phone,
    this.photo,
  });

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
      userId: int.parse(json['id'].toString()),
      studentId: int.parse(json['student_id'].toString()),
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      regNumber: json['reg_number'] ?? '',
      department: json['department'] ?? '',
      yearOfStudy: json['year_of_study'] ?? '',
      phone: json['phone'] ?? '',
      photo: json['photo'],
    );
  }
}
