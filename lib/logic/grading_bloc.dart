import 'package:deskpad/data/models/deskpad_models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

// --- Events ---
abstract class GradingEvent extends Equatable {
  const GradingEvent();
  @override
  List<Object> get props => [];
}

class LoadGradingData extends GradingEvent {}

class FilterGradingEvent extends GradingEvent {
  final String filter; // 'pending', 'graded', 'total'
  const FilterGradingEvent(this.filter);
}

// --- States ---
abstract class GradingState extends Equatable {
  const GradingState();
  @override
  List<Object> get props => [];
}

class GradingLoading extends GradingState {}

class GradingLoaded extends GradingState {
  final List<GradingEntity> allItems;
  final List<GradingEntity> pendingItems;
  final List<GradingEntity> gradedItems;
  final String currentFilter;

  const GradingLoaded({
    this.allItems = const [],
    this.pendingItems = const [],
    this.gradedItems = const [],
    this.currentFilter = 'pending',
  });

  // Helper to get the list currently being shown
  List<GradingEntity> get displayedList {
    switch (currentFilter) {
      case 'pending':
        return pendingItems;
      case 'graded':
        return gradedItems;
      default:
        return allItems;
    }
  }

  @override
  List<Object> get props => [allItems, currentFilter];
}

// --- BLoC ---
class GradingBloc extends Bloc<GradingEvent, GradingState> {
  GradingBloc() : super(GradingLoading()) {
    on<LoadGradingData>((event, emit) async {
      await Future.delayed(const Duration(seconds: 1)); // Simulate API

      // Generate 100 Mock Items
      final List<GradingEntity> mockData = List.generate(100, (index) {
        // Toggle status every few items to create mix
        bool isGraded = index % 3 != 0; 
        
        return GradingEntity(
          id: '$index',
          studentName: _getStudentName(index),
          hasFingerprint: index % 4 == 0, // Every 4th has fingerprint
          assignmentTitle: isGraded ? 'To Kill a Mockingbird Essay' : 'Macbeth Analysis',
          submittedDate: 'Sep ${20 + (index % 10)}, 2025 10:30 AM',
          wordCount: 1200 + (index * 15),
          status: isGraded ? 'graded' : 'pending',
          grade: isGraded ? (10 + (index % 10)) : null,
        );
      });

      emit(GradingLoaded(
        allItems: mockData,
        pendingItems: mockData.where((e) => e.status == 'pending').toList(),
        gradedItems: mockData.where((e) => e.status == 'graded').toList(),
        currentFilter: 'pending', // Default view
      ));
    });

    on<FilterGradingEvent>((event, emit) {
      if (state is GradingLoaded) {
        final currentState = state as GradingLoaded;
        emit(GradingLoaded(
          allItems: currentState.allItems,
          pendingItems: currentState.pendingItems,
          gradedItems: currentState.gradedItems,
          currentFilter: event.filter,
        ));
      }
    });
  }

  String _getStudentName(int index) {
    const names = ['Marcus Chen', 'Emma Johnson', 'Sofia Rodriguez', 'James Wilson', 'Aisha Patel', 'David Kim'];
    return names[index % names.length];
  }
}