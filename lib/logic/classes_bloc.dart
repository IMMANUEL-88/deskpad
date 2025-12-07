import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../data/models/deskpad_models.dart'; // Ensure this has your ClassEntity

// --- Events ---
abstract class ClassesEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadClasses extends ClassesEvent {}

class FilterClasses extends ClassesEvent {
  final String filter; // 'active' or 'archived'
  FilterClasses(this.filter);
}

// --- States ---
abstract class ClassesState extends Equatable {
  @override
  List<Object> get props => [];
}

class ClassesLoading extends ClassesState {}

class ClassesLoaded extends ClassesState {
  final List<ClassEntity> activeClasses;
  final List<ClassEntity> archivedClasses;
  final List<StudentEntity> students;
  final String currentFilter; // 'active', 'archived', or 'students'

  ClassesLoaded({
    this.activeClasses = const [],
    this.archivedClasses = const [],
    this.students = const [],
    this.currentFilter = 'active',
  });

  // Helper to determine view
  bool get isStudentView => currentFilter == 'students';

  // Helper to get list based on current filter
  List<ClassEntity> get displayedClasses =>
      currentFilter == 'active' ? activeClasses : archivedClasses;

  @override
  List<Object> get props => [
    activeClasses,
    archivedClasses,
    students,
    currentFilter,
  ];
}

// --- BLoC ---
class ClassesBloc extends Bloc<ClassesEvent, ClassesState> {
  ClassesBloc() : super(ClassesLoading()) {
    on<LoadClasses>((event, emit) async {
      await Future.delayed(const Duration(seconds: 1));

      // ... (Existing Class Data) ...
      final allMockClasses = [
        const ClassEntity(
          id: '1',
          title: 'Creative Writing 101',
          description: 'Introduction to creative writing...',
          status: 'active',
          studentsCount: 41,
          activeAssignments: 4,
          term: 'Fall 2025',
          gradeLevel: 'Grade 11',
          fingerprintsSubmitted: 38,
        ),
        const ClassEntity(
          id: '2',
          title: 'English Foundations 1H',
          description: 'A foundational course in analytical...',
          status: 'active',
          studentsCount: 41,
          activeAssignments: 2,
          term: 'Fall 2025',
          gradeLevel: 'Grade 9',
          fingerprintsSubmitted: 41,
        ),
        const ClassEntity(
          id: '3',
          title: 'AP English Language',
          description: 'College-level study of nonfiction...',
          status: 'active',
          studentsCount: 22,
          activeAssignments: 6,
          term: 'Fall 2025',
          gradeLevel: 'Grade 12',
          fingerprintsSubmitted: 22,
        ),
        const ClassEntity(
          id: '4',
          title: 'Writing & Rhetoric 3H',
          description: 'Exploring persuasive writing...',
          status: 'active',
          studentsCount: 41,
          activeAssignments: 0,
          term: 'Fall 2024',
          gradeLevel: 'Grade 10',
          fingerprintsSubmitted: 36,
        ),
        const ClassEntity(
          id: '5',
          title: 'Journalism 101',
          description: 'Basics of news reporting...',
          status: 'archived',
          studentsCount: 30,
          activeAssignments: 0,
          term: 'Fall 2023',
          gradeLevel: 'Grade 11',
          fingerprintsSubmitted: 30,
        ),
        const ClassEntity(
          id: '6',
          title: 'World Lit',
          description: 'Global literature...',
          status: 'archived',
          studentsCount: 25,
          activeAssignments: 0,
          term: 'Fall 2023',
          gradeLevel: 'Grade 10',
          fingerprintsSubmitted: 25,
        ),
      ];

      // Mock Student Data based on image
      final mockStudents = [
        const StudentEntity(
          id: '1',
          name: 'Marcus Chen',
          email: 'marcus.chen@gmail.com',
          status: 'active',
          hasFingerprint: true,
        ),
        const StudentEntity(
          id: '2',
          name: 'Emma Johnson',
          email: 'emma.johnson@email.com',
          status: 'inactive',
          hasFingerprint: true,
        ),
        const StudentEntity(
          id: '3',
          name: 'Sofia Rodriguez',
          email: 'sofia.rodriguez@email.com',
          status: 'active',
          hasFingerprint: true,
        ),
        const StudentEntity(
          id: '4',
          name: 'James Wilson',
          email: 'james.wilson@email.com',
          status: 'active',
          hasFingerprint: false,
        ),
        const StudentEntity(
          id: '5',
          name: 'Aisha Patel',
          email: 'aisha.patel@email.com',
          status: 'inactive',
          hasFingerprint: true,
        ),
        const StudentEntity(
          id: '6',
          name: 'David Kim',
          email: 'david.kim@gmail.com',
          status: 'active',
          hasFingerprint: true,
        ),
        const StudentEntity(
          id: '7',
          name: 'Jessica Smith',
          email: 'jessica.smith@email.com',
          status: 'active',
          hasFingerprint: true,
        ),
      ];

      emit(
        ClassesLoaded(
          activeClasses: allMockClasses
              .where((c) => c.status == 'active')
              .toList(),
          archivedClasses: allMockClasses
              .where((c) => c.status == 'archived')
              .toList(),
          students: mockStudents,
          currentFilter: 'active',
        ),
      );
    });

    on<FilterClasses>((event, emit) {
      if (state is ClassesLoaded) {
        final curr = state as ClassesLoaded;
        emit(
          ClassesLoaded(
            activeClasses: curr.activeClasses,
            archivedClasses: curr.archivedClasses,
            students: curr.students,
            currentFilter: event.filter, // Updates UI to switch views
          ),
        );
      }
    });
  }
}
