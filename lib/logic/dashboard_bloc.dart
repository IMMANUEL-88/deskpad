import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

// --- Events ---
abstract class DashboardEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadDashboardData extends DashboardEvent {}

// --- States ---
abstract class DashboardState extends Equatable {
  @override
  List<Object> get props => [];
}

class DashboardInitial extends DashboardState {}
class DashboardLoading extends DashboardState {}
class DashboardError extends DashboardState {}

class DashboardLoaded extends DashboardState {
  final int pendingReview;
  final int gradedThisWeek;
  final int activeStudents;
  // Add grade breakdown data
  final int grade9Count;
  final int grade10Count;
  final int grade11Count;
  final List<Map<String, dynamic>> alerts;

  DashboardLoaded({
    required this.pendingReview,
    required this.gradedThisWeek,
    required this.activeStudents,
    required this.grade9Count,
    required this.grade10Count,
    required this.grade11Count,
    required this.alerts,
  });

  @override
  List<Object> get props => [
        pendingReview,
        gradedThisWeek,
        activeStudents,
        grade9Count,
        grade10Count,
        grade11Count,
        alerts
      ];
}

// --- BLoC ---
class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc() : super(DashboardInitial()) {
    on<LoadDashboardData>((event, emit) async {
      emit(DashboardLoading());
      await Future.delayed(const Duration(seconds: 1)); // Simulate API call

      // Hardcoded data matching the screenshot
      emit(DashboardLoaded(
        pendingReview: 17,
        gradedThisWeek: 31,
        activeStudents: 102,
        grade9Count: 34,
        grade10Count: 31,
        grade11Count: 37,
        alerts: const [
          {'name': 'Marcus Chen', 'deviation': '52%'},
          {'name': 'David Kim', 'deviation': '82%'},
          {'name': 'Sofia Rodriguez', 'deviation': '42%'},
          {'name': 'James Wilson', 'deviation': '64%'},
        ],
      ));
    });
  }
}