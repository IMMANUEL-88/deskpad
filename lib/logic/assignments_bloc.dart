import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../data/models/deskpad_models.dart';

// --- Events ---
abstract class AssignmentsEvent extends Equatable {
  const AssignmentsEvent();
  @override
  List<Object> get props => [];
}

class LoadAssignments extends AssignmentsEvent {}

class FilterAssignments extends AssignmentsEvent {
  final String filter; // 'active', 'pending', 'graded'
  const FilterAssignments(this.filter);
}

// --- States ---
abstract class AssignmentsState extends Equatable {
  const AssignmentsState();
  @override
  List<Object> get props => [];
}

class AssignmentsLoading extends AssignmentsState {}

class AssignmentsLoaded extends AssignmentsState {
  final List<AssignmentEntity> active;
  final List<AssignmentEntity> pending;
  final List<AssignmentEntity> graded;
  final String currentFilter;

  const AssignmentsLoaded({
    this.active = const [],
    this.pending = const [],
    this.graded = const [],
    this.currentFilter = 'active',
  });

  List<AssignmentEntity> get displayedList {
    if (currentFilter == 'pending') return pending;
    if (currentFilter == 'graded') return graded;
    return active;
  }

  @override
  List<Object> get props => [active, pending, graded, currentFilter];
}

// --- BLoC ---
class AssignmentsBloc extends Bloc<AssignmentsEvent, AssignmentsState> {
  AssignmentsBloc() : super(AssignmentsLoading()) {
    on<LoadAssignments>((event, emit) async {
      await Future.delayed(const Duration(seconds: 1)); // Simulate API

      // Mock Data
      final all = [
        const AssignmentEntity(
          id: '1',
          title: 'Author Spotlight: George Orwell',
          description:
              'Writing with clarity, conviction, and political purpose',
          status: 'active',
          tag: 'View',
          courseName: 'Creative Writing 101',
          submittedCount: 30,
          totalStudents: 41,
          gradeLevel: 'Grade 11',
          dueDate: 'September 25, 2025',
        ),

        const AssignmentEntity(
          id: '2',
          title: 'To Kill a Mockingbird Essay',
          description: 'Analyze justice, bias, and conscience...',
          status: 'active',
          tag: 'View',
          courseName: 'English Foundations 1H',
          submittedCount: 24,
          totalStudents: 41,
          gradeLevel: 'Grade 9',
          dueDate: 'September 27, 2025',
        ),

        const AssignmentEntity(
          id: '5',
          title: 'Poetry Analysis: Symbolism & Tone',
          description:
              'Identify symbolic patterns and tonal shifts in modern poetry',
          status: 'active',
          tag: 'View',
          courseName: 'Literary Studies 2A',
          submittedCount: 18,
          totalStudents: 34,
          gradeLevel: 'Grade 10',
          dueDate: 'October 5, 2025',
        ),

        const AssignmentEntity(
          id: '6',
          title: 'Short Story Draft',
          description:
              'Create a character-driven short story with a clear narrative arc',
          status: 'active',
          tag: 'View',
          courseName: 'Creative Writing Workshop',
          submittedCount: 12,
          totalStudents: 29,
          gradeLevel: 'Grade 11',
          dueDate: 'October 8, 2025',
        ),

        const AssignmentEntity(
          id: '7',
          title: 'Research Summary: Climate & Literature',
          description:
              'Explore how climate themes appear in environmental writing',
          status: 'active',
          tag: 'View',
          courseName: 'English Composition 2',
          submittedCount: 10,
          totalStudents: 28,
          gradeLevel: 'Grade 12',
          dueDate: 'October 10, 2025',
        ),

        const AssignmentEntity(
          id: '8',
          title: 'Eloquent Speech Draft',
          description:
              'Write a persuasive speech using rhetorical devices effectively',
          status: 'active',
          tag: 'View',
          courseName: 'Public Speaking Essentials',
          submittedCount: 16,
          totalStudents: 31,
          gradeLevel: 'Grade 10',
          dueDate: 'October 12, 2025',
        ),

        // Pending Assignments
        const AssignmentEntity(
          id: '3',
          title: 'The Art of the Counterargument',
          description: 'Crafting persuasive essays that address opposing views',
          status: 'pending',
          tag: 'Review',
          courseName: 'Writing & Rhetoric 3H',
          submittedCount: 41,
          totalStudents: 41,
          gradeLevel: 'Grade 11',
          dueDate: 'September 20, 2025',
        ),

        const AssignmentEntity(
          id: '9',
          title: 'Thesis Builder Exercise',
          description:
              'Strengthen essay structure through targeted thesis crafting',
          status: 'pending',
          tag: 'Review',
          courseName: 'English Composition 1',
          submittedCount: 37,
          totalStudents: 42,
          gradeLevel: 'Grade 9',
          dueDate: 'October 3, 2025',
        ),

        const AssignmentEntity(
          id: '10',
          title: 'Character Sketch Portfolio',
          description:
              'Develop vivid character descriptions using sensory details',
          status: 'pending',
          tag: 'Review',
          courseName: 'Creative Writing Foundations',
          submittedCount: 25,
          totalStudents: 30,
          gradeLevel: 'Grade 10',
          dueDate: 'October 6, 2025',
        ),

        const AssignmentEntity(
          id: '11',
          title: 'Logical Fallacies Round-Up',
          description: 'Identify and analyze fallacies in opinion writing',
          status: 'pending',
          tag: 'Review',
          courseName: 'AP English Language',
          submittedCount: 44,
          totalStudents: 44,
          gradeLevel: 'Grade 12',
          dueDate: 'October 7, 2025',
        ),

        const AssignmentEntity(
          id: '12',
          title: 'Poetry Rewrite Challenge',
          description: 'Rewrite a classic poem using modern language and style',
          status: 'pending',
          tag: 'Review',
          courseName: 'Poetry Workshop',
          submittedCount: 30,
          totalStudents: 35,
          gradeLevel: 'Grade 11',
          dueDate: 'October 9, 2025',
        ),

        // Graded Assignments
        const AssignmentEntity(
          id: '4',
          title: 'Imitate the Argument Essay',
          description: 'Write in the style of a columnist...',
          status: 'graded',
          tag: 'Done',
          courseName: 'AP English Language',
          submittedCount: 22,
          totalStudents: 22,
          gradeLevel: 'Grade 12',
          dueDate: 'October 2, 2025',
        ),

        const AssignmentEntity(
          id: '13',
          title: 'Narrative Reflection: Personal Growth',
          description:
              'Reflect on a transformative experience using narrative techniques',
          status: 'graded',
          tag: 'Done',
          courseName: 'Creative Nonfiction 2H',
          submittedCount: 28,
          totalStudents: 28,
          gradeLevel: 'Grade 11',
          dueDate: 'September 15, 2025',
        ),

        const AssignmentEntity(
          id: '14',
          title: 'Novel Analysis: Themes & Motifs',
          description: 'Deep thematic analysis of chosen contemporary novel',
          status: 'graded',
          tag: 'Done',
          courseName: 'English Honors Literature',
          submittedCount: 33,
          totalStudents: 33,
          gradeLevel: 'Grade 10',
          dueDate: 'September 18, 2025',
        ),

        const AssignmentEntity(
          id: '15',
          title: 'Rhetorical Devices Quiz',
          description: 'Identify rhetorical elements in curated passages',
          status: 'graded',
          tag: 'Done',
          courseName: 'Writing & Rhetoric 2',
          submittedCount: 40,
          totalStudents: 40,
          gradeLevel: 'Grade 9',
          dueDate: 'September 21, 2025',
        ),
      ];

      emit(
        AssignmentsLoaded(
          active: all.where((a) => a.status == 'active').toList(),
          pending: all.where((a) => a.status == 'pending').toList(),
          graded: all.where((a) => a.status == 'graded').toList(),
        ),
      );
    });

    on<FilterAssignments>((event, emit) {
      if (state is AssignmentsLoaded) {
        final curr = state as AssignmentsLoaded;
        emit(
          AssignmentsLoaded(
            active: curr.active,
            pending: curr.pending,
            graded: curr.graded,
            currentFilter: event.filter,
          ),
        );
      }
    });
  }
}
