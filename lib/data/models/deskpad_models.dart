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

// --- Assignment Entity ---
class AssignmentEntity extends Equatable {
  final String id;
  final String title;
  final String description;
  final String status;
  final String courseName;
  final int submitted;
  final int totalStudents;
  final String gradeLevel;
  final DateTime dueDate;

  const AssignmentEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.courseName,
    required this.submitted,
    required this.totalStudents,
    required this.gradeLevel,
    required this.dueDate,
  });

  factory AssignmentEntity.fromJson(Map<String, dynamic> json) {
    return AssignmentEntity(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      status: json['status'],
      courseName: json['courseName'],
      submitted: json['submitted'],
      totalStudents: json['totalStudents'],
      gradeLevel: json['gradeLevel'],
      dueDate: DateTime.parse(json['dueDate']),
    );
  }

  @override
  List<Object?> get props => [id, title, status, submitted];
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