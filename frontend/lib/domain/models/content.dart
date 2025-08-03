// This file provides backward compatibility for imports
export '../entities/content.dart';

class Content {
  final int grade;
  final String contentType;
  final String ageGroup;

  Content({
    required this.grade,
    required this.contentType,
    required this.ageGroup,
  });

  factory Content.fromJson(Map<String, dynamic> json) {
    return Content(
      grade: json['grade'],
      contentType: json['content_type'],
      ageGroup: json['age_group'],
    );
  }
}
