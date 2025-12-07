import 'package:deskpad/presentation/widgets/create_assignment_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../logic/assignments_bloc.dart';
import '../widgets/assignments_stats_header.dart';
import '../widgets/assignment_card.dart';

class AssignmentsScreen extends StatelessWidget {
  const AssignmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AssignmentsBloc()..add(LoadAssignments()),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Responsive Header ---
            LayoutBuilder(
              builder: (context, constraints) {
                final isMobile = constraints.maxWidth < 600;

                final textSection = Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Assignments",
                      style: GoogleFonts.inter(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      "Plan, edit, and grade assignments across all classes",
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
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return const CreateAssignmentModal();
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    label: Text(
                      "Create Assignment",
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

            // --- Stats Filters ---
            const AssignmentsStatsHeader(),

            const SizedBox(height: 32),

            // --- Assignment List ---
            BlocBuilder<AssignmentsBloc, AssignmentsState>(
              builder: (context, state) {
                if (state is AssignmentsLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is AssignmentsLoaded) {
                  final list = state.displayedList;

                  if (list.isEmpty) {
                    return Container(
                      padding: const EdgeInsets.all(40),
                      alignment: Alignment.center,
                      child: Text(
                        "No assignments found.",
                        style: GoogleFonts.inter(color: Colors.grey),
                      ),
                    );
                  }

                  // Non-scrolling ListView (Page handles scrolling)
                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: list.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      return AssignmentCard(data: list[index]);
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
