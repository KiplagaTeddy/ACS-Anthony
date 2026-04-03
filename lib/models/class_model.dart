class ClassModel {
  final int id;
  final String day;
  final String startTime;
  final String endTime;
  final String room;
  final String lecturer;
  final String courseCode;
  final String courseName;

  ClassModel({
    required this.id,
    required this.day,
    required this.startTime,
    required this.endTime,
    required this.room,
    required this.lecturer,
    required this.courseCode,
    required this.courseName,
  });

  factory ClassModel.fromJson(Map<String, dynamic> j) => ClassModel(
    id: int.parse(j['id'].toString()),
    day: j['day'] ?? '',
    startTime: j['start_time'] ?? '',
    endTime: j['end_time'] ?? '',
    room: j['room'] ?? '',
    lecturer: j['lecturer'] ?? '',
    courseCode: j['code'] ?? '',
    courseName: j['course_name'] ?? '',
  );
}
