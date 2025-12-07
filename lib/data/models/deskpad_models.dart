import 'package:equatable/equatable.dart';

// --- Class Entity ---
class ClassEntity extends Equatable {
  final String id;
  final String title;
  final String description;
  final String status; // 'active' or 'archived'
  final int studentsCount;
  final int activeAssignments;
  final String term;
  final String gradeLevel;
  final int fingerprintsSubmitted;

  const ClassEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.studentsCount,
    required this.activeAssignments,
    required this.term,
    required this.gradeLevel,
    required this.fingerprintsSubmitted,
  });

  factory ClassEntity.fromJson(Map<String, dynamic> json) {
    return ClassEntity(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      status: json['status'],
      studentsCount: json['studentsCount'],
      activeAssignments: json['activeAssignments'],
      term: json['term'],
      gradeLevel: json['gradeLevel'],
      fingerprintsSubmitted: json['fingerprintsSubmitted'],
    );
  }

  @override
  List<Object?> get props => [id, title, status, studentsCount];
}

// --- Dashboard Stats Entity ---
class DashboardStats extends Equatable {
  final int activeClasses;
  final int archivedClasses;
  final int totalStudents;
  final int pendingReview;
  final int gradedThisWeek;

  const DashboardStats({
    required this.activeClasses,
    required this.archivedClasses,
    required this.totalStudents,
    required this.pendingReview,
    required this.gradedThisWeek,
  });

  factory DashboardStats.fromJson(Map<String, dynamic> json) {
    return DashboardStats(
      activeClasses: json['activeClasses'],
      archivedClasses: json['archivedClasses'],
      totalStudents: json['totalStudents'],
      pendingReview: json['pendingReview'],
      gradedThisWeek: json['gradedThisWeek'],
    );
  }

  @override
  List<Object?> get props => [activeClasses, pendingReview];
}

// -- Student Entity ---
class StudentEntity extends Equatable {
  final String id;
  final String name;
  final String email;
  final String status; // 'active' or 'inactive'
  final bool hasFingerprint;

  const StudentEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.status,
    required this.hasFingerprint,
  });

  @override
  List<Object?> get props => [id, name, status, hasFingerprint];
}

// --- Assignment Entity ---
class AssignmentEntity extends Equatable {
  final String id;
  final String title;
  final String description;
  final String status; // 'active', 'pending', 'graded'
  final String tag; // e.g. 'View', 'New', 'Urgent'
  final String courseName;
  final int submittedCount;
  final int totalStudents;
  final String gradeLevel;
  final String dueDate; // Keeping as String for mock simplicity

  const AssignmentEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.tag,
    required this.courseName,
    required this.submittedCount,
    required this.totalStudents,
    required this.gradeLevel,
    required this.dueDate,
  });

  @override
  List<Object?> get props => [id, title, status, submittedCount];
}

class GradingEntity extends Equatable {
  final String id;
  final String studentName;
  final bool hasFingerprint;
  final String assignmentTitle;
  final String submittedDate;
  final int wordCount;
  final int? grade; // Null if pending
  final String status; // 'pending' or 'graded'

  const GradingEntity({
    required this.id,
    required this.studentName,
    required this.hasFingerprint,
    required this.assignmentTitle,
    required this.submittedDate,
    required this.wordCount,
    this.grade,
    required this.status,
  });

  @override
  List<Object?> get props => [id, studentName, status, grade];
}
