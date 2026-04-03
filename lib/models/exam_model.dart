class ExamModel {
  final int id;
  final String courseCode;
  final String courseName;
  final String examDate;
  final String startTime;
  final String endTime;
  final String venue;
  final String term;

  ExamModel({
    required this.id,
    required this.courseCode,
    required this.courseName,
    required this.examDate,
    required this.startTime,
    required this.endTime,
    required this.venue,
    required this.term,
  });

  factory ExamModel.fromJson(Map<String, dynamic> j) => ExamModel(
    id: int.parse(j['id'].toString()),
    courseCode: j['code'] ?? '',
    courseName: j['course_name'] ?? '',
    examDate: j['exam_date'] ?? '',
    startTime: j['start_time'] ?? '',
    endTime: j['end_time'] ?? '',
    venue: j['venue'] ?? '',
    term: j['term'] ?? '',
  );

  // Days until exam
  int get daysUntil {
    final date = DateTime.tryParse(examDate);
    if (date == null) return 0;
    return date.difference(DateTime.now()).inDays;
  }
}
