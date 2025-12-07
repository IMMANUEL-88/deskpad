import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../logic/assignments_bloc.dart';

class AssignmentsStatsHeader extends StatelessWidget {
  const AssignmentsStatsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AssignmentsBloc, AssignmentsState>(
      builder: (context, state) {
        if (state is! AssignmentsLoaded) return const SizedBox.shrink();

        return LayoutBuilder(
          builder: (context, constraints) {
            final isDesktop = constraints.maxWidth > 900;

            List<Widget> cards = [
              _buildFilterCard(
                context,
                "Active",
                "${state.active.length}",
                isSelected: state.currentFilter == 'active',
                textColor: Color(0xFF027A48),
                onTap: () => context
                    .read<AssignmentsBloc>()
                    .add(const FilterAssignments('active')),
              ),
              const SizedBox(width: 24, height: 16),
              _buildFilterCard(
                context,
                "Pending",
                "${state.pending.length}",
                isSelected: state.currentFilter == 'pending',
                textColor: const Color(0xFFE04F16), // Orange
                onTap: () => context
                    .read<AssignmentsBloc>()
                    .add(const FilterAssignments('pending')),
              ),
              const SizedBox(width: 24, height: 16),
              _buildFilterCard(
                context,
                "Graded",
                "${state.graded.length}",
                isSelected: state.currentFilter == 'graded',
                textColor: const Color(0xFF9E77ED), // Purple
                onTap: () => context
                    .read<AssignmentsBloc>()
                    .add(const FilterAssignments('graded')),
              ),
            ];

            if (isDesktop) {
              return Row(
                children: cards
                    .map((c) => c is SizedBox ? c : Expanded(child: c))
                    .toList(),
              );
            } else {
              return Column(
                children: cards
                    .map((c) => c is SizedBox
                        ? const SizedBox(height: 16)
                        : SizedBox(width: double.infinity, child: c))
                    .toList(),
              );
            }
          },
        );
      },
    );
  }

  Widget _buildFilterCard(
    BuildContext context,
    String title,
    String count, {
    bool isSelected = false,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          // Same gradient logic as Classes page
          gradient: isSelected
              ? const LinearGradient(
                  colors: [
                    Color.fromARGB(255, 245, 233, 253),
                    Color.fromARGB(255, 211, 226, 255),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.topRight,
                )
              : const LinearGradient(
                  colors: [Colors.white, Colors.white],
                  begin: Alignment.topLeft,
                  end: Alignment.topRight,
                ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade300),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              count,
              style: GoogleFonts.inter(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}