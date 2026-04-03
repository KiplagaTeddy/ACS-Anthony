class ScheduleModel {
  final int id;
  final String day;
  final String startTime;
  final String endTime;
  final String room;
  final String lecturer;
  final String courseCode;
  final String courseName;

  ScheduleModel({
    required this.id,
    required this.day,
    required this.startTime,
    required this.endTime,
    required this.room,
    required this.lecturer,
    required this.courseCode,
    required this.courseName,
  });

  factory ScheduleModel.fromJson(Map<String, dynamic> json) {
    return ScheduleModel(
      id: int.parse(json['id'].toString()),
      day: json['day'] ?? '',
      startTime: json['start_time'] ?? '',
      endTime: json['end_time'] ?? '',
      room: json['room'] ?? '',
      lecturer: json['lecturer'] ?? '',
      courseCode: json['code'] ?? '',
      courseName: json['course_name'] ?? '',
    );
  }
}
