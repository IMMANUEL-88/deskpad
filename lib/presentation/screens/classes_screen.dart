import 'package:deskpad/presentation/widgets/student_list_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../logic/classes_bloc.dart';
import '../widgets/class_stats_header.dart';
import '../widgets/class_card.dart';

class ClassesScreen extends StatelessWidget {
  const ClassesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ClassesBloc()..add(LoadClasses()),
      // FIX 1: Wrap the whole page in SingleChildScrollView
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Header Section ---
            LayoutBuilder(
              builder: (context, constraints) {
                final isMobile = constraints.maxWidth < 600;

                final textSection = Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Classes",
                      style: GoogleFonts.inter(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      "Manage your classes and view student rosters",
                      style: GoogleFonts.inter(color: Colors.black),
                    ),
                  ],
                );

                final buttonSection = Container(
                  height: 36,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF2350b3), Color(0xFFc86de5)],
                    ),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.add, size: 18),
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    label: Text(
                      "Create Class",
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                );

                if (isMobile) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      textSection,
                      const SizedBox(height: 16),
                      buttonSection,
                    ],
                  );
                } else {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [textSection, buttonSection],
                  );
                }
              },
            ),

            const SizedBox(height: 32),

            // Stats / Filters
            const ClassStatsHeader(),

            const SizedBox(height: 32),

            // --- FIX 2: Removed Expanded. Content flows naturally ---
            BlocBuilder<ClassesBloc, ClassesState>(
              builder: (context, state) {
                if (state is ClassesLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is ClassesLoaded) {
                  // View 1: Student Table
                  if (state.currentFilter == 'students') {
                    // The table internally handles horizontal scroll.
                    // Vertical scroll is now handled by the page.
                    return StudentListTable(students: state.students);
                  }

                  // View 2: Class List
                  final classes = state.displayedClasses;
                  return ListView.separated(
                    // FIX 3: Disable inner scrolling so the page scrolls instead
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: classes.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      return ClassCard(classData: classes[index]);
                    },
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }
}