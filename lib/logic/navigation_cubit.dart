import 'package:flutter_bloc/flutter_bloc.dart';

enum NavigationTab { dashboard, classes, fingerprints, assignments, grading, calendar, analytics, settings, help }

class NavigationCubit extends Cubit<int> {
  NavigationCubit() : super(0); // Default to Dashboard (Index 0)

  void selectTab(int index) {
    emit(index);
  }
}