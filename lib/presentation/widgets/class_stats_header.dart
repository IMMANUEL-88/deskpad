import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../logic/classes_bloc.dart';

class ClassStatsHeader extends StatelessWidget {
  const ClassStatsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ClassesBloc, ClassesState>(
      builder: (context, state) {
        if (state is! ClassesLoaded) return const SizedBox.shrink();

        return LayoutBuilder(
          builder: (context, constraints) {
            final isDesktop = constraints.maxWidth > 900;

            // Reusing a simplified version of SummaryCard or a new custom one
            List<Widget> cards = [
              _buildFilterCard(
                context,
                "Active Classes",
                "${state.activeClasses.length}",
                isSelected: state.currentFilter == 'active',
                onTap: () =>
                    context.read<ClassesBloc>().add(FilterClasses('active')),
              ),
              const SizedBox(width: 24, height: 16),
              _buildFilterCard(
                context,
                "Archived Classes",
                "${state.archivedClasses.length}",
                isSelected: state.currentFilter == 'archived',
                onTap: () =>
                    context.read<ClassesBloc>().add(FilterClasses('archived')),
              ),
              const SizedBox(width: 24, height: 16),
              _buildFilterCard(
                context,
                "Total Current Students",
                "102",
                isSelected:
                    state.currentFilter ==
                    'students', // Highlight when selected
                isPurple: true,
                onTap: () {
                  // Trigger the switch
                  context.read<ClassesBloc>().add(FilterClasses('students'));
                },
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
                    .map(
                      (c) => c is SizedBox
                          ? const SizedBox(height: 16)
                          : SizedBox(width: double.infinity, child: c),
                    )
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
    bool isPurple = false,
    required VoidCallback onTap,
  }) {
    Color textColor = isPurple
        ? const Color(0xFF9c40b9)
        : const Color(0xFF027A48);
    if (title.contains("Archived"))
      textColor = const Color(0xFFE04F16); // Orange for archived

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
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
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
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
