import 'package:deskpad/data/models/deskpad_models.dart';
import 'package:deskpad/presentation/widgets/grading_components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../logic/grading_bloc.dart';

class GradingScreen extends StatefulWidget {
  const GradingScreen({super.key});

  @override
  State<GradingScreen> createState() => _GradingScreenState();
}

class _GradingScreenState extends State<GradingScreen> {
  int _currentPage = 1;
  final int _itemsPerPage = 6;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GradingBloc()..add(LoadGradingData()),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 32),
            const _GradingStatsHeader(),
            const SizedBox(height: 32),

            // Content Block
            BlocBuilder<GradingBloc, GradingState>(
              builder: (context, state) {
                if (state is GradingLoading)
                  return const Center(child: CircularProgressIndicator());

                if (state is GradingLoaded) {
                  final data = state.displayedList;

                  // Pagination Calculations
                  if ((_currentPage - 1) * _itemsPerPage >= data.length)
                    _currentPage = 1;
                  final int totalPages = (data.length / _itemsPerPage).ceil();
                  final int start = (_currentPage - 1) * _itemsPerPage;
                  final int end = (start + _itemsPerPage > data.length)
                      ? data.length
                      : start + _itemsPerPage;
                  final pageData = data.sublist(start, end);

                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      children: [
                        // 1. Responsive Toolbar
                        const GradingToolbar(),

                        const Divider(height: 1, color: Color(0xFFEAECF0)),

                        // 2. Responsive Table/List
                        LayoutBuilder(
                          builder: (context, constraints) {
                            // FIX: Lowered breakpoint to 900px to ensure Table shows on Laptops
                            if (constraints.maxWidth < 900) {
                              return _buildMobileList(pageData);
                            } else {
                              return _buildDesktopTable(pageData);
                            }
                          },
                        ),

                        const Divider(height: 1, color: Color(0xFFEAECF0)),

                        // 3. Responsive Pagination
                        GradingPagination(
                          currentPage: _currentPage,
                          totalPages: totalPages,
                          totalItems: data.length,
                          start: start,
                          end: end,
                          onPageChanged: (page) =>
                              setState(() => _currentPage = page),
                        ),
                      ],
                    ),
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

  // --- Header Layout ---
  Widget _buildHeader() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 600;
        final textSection = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Grading",
              style: GoogleFonts.inter(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF101828),
              ),
            ),
            Text(
              "Review and grade student work in one place",
              style: GoogleFonts.inter(color: const Color(0xFF475467)),
            ),
          ],
        );

        if (isMobile) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [textSection, const SizedBox(height: 8)],
          );
        }
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [textSection],
        );
      },
    );
  }

  // --- Desktop Table View (Refined to match Images) ---
  Widget _buildDesktopTable(List<GradingEntity> data) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 1000),
        child: SizedBox(
          width: 1000, // Fixed width for consistent layout
          child: Column(
            children: [
              // Header Row
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                child: Row(
                  children: [
                    Expanded(flex: 2, child: _tableHeader("Student")),
                    Expanded(
                      flex: 2,
                      child: Center(
                        child: _tableHeader(
                          "Writing\nFingerprint",
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Expanded(flex: 3, child: _tableHeader("Assignment Title")),
                    Expanded(
                      flex: 2,
                      child: Center(child: _tableHeader("Submitted")),
                    ),
                    Expanded(
                      flex: 2,
                      child: Center(child: _tableHeader("Word Count")),
                    ),
                    Expanded(
                      flex: 1,
                      child: Center(child: _tableHeader("Grade")),
                    ),
                    Expanded(
                      flex: 2,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: _tableHeader("Action"),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1, color: Color(0xFFEAECF0)),

              // Data Rows
              ...data.map(
                (item) => Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Color(0xFFEAECF0)),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  child: Row(
                    children: [
                      // 1. Student Name
                      Expanded(
                        flex: 2,
                        child: Text(
                          item.studentName,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF101828), // Darker text
                          ),
                        ),
                      ),

                      // 2. Fingerprint Icon
                      Expanded(
                        flex: 2,
                        child: Center(
                          child: item.hasFingerprint
                              ? const Icon(
                                  Icons.fingerprint,
                                  size: 24,
                                  color: Color(0xFF344054),
                                )
                              : const Text(
                                  "-",
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Color(0xFF98A2B3),
                                  ),
                                ),
                        ),
                      ),

                      // 3. Assignment Title (Multiline: Title + Subtitle)
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.assignmentTitle,
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF101828),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Human Nature Essay", // Mock subtitle
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: const Color(0xFF667085), // Grey text
                              ),
                            ),
                          ],
                        ),
                      ),

                      // 4. Submitted (Date + Time)
                      Expanded(
                        flex: 2,
                        child: Center(
                          child: Column(
                            children: [
                              Text(
                                item.submittedDate.split(' ')[0] +
                                    " " +
                                    item.submittedDate
                                        .split(' ')[1]
                                        .replaceAll(',', ''),
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFF101828),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                item.submittedDate
                                    .split(' ')
                                    .sublist(2)
                                    .join(' '),
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: const Color(0xFF667085),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // 5. Word Count
                      Expanded(
                        flex: 2,
                        child: Center(
                          child: Text(
                            "${item.wordCount}",
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF101828),
                            ),
                          ),
                        ),
                      ),

                      // 6. Grade
                      Expanded(
                        flex: 1,
                        child: Center(
                          child: Text(
                            "${item.grade ?? '-'}",
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF101828),
                            ),
                          ),
                        ),
                      ),

                      // 7. Action Button
                      Expanded(
                        flex: 2,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: _buildActionButton(item.status),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- Mobile Card View ---
  Widget _buildMobileList(List<GradingEntity> data) {
    return Column(
      children: data.map((item) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: Color(0xFFEAECF0))),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Row 1: Student & Action
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    item.studentName,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF101828),
                    ),
                  ),
                  _buildActionButton(item.status, isCompact: true),
                ],
              ),
              const SizedBox(height: 8),

              // Row 2: Title
              Text(
                item.assignmentTitle,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF344054),
                ),
              ),
              Text(
                "Human Nature Essay",
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: const Color(0xFF667085),
                ),
              ),
              const SizedBox(height: 12),

              // Row 3: Metrics Grid
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _mobileMetric(
                    "Submitted",
                    item.submittedDate.split(' ').sublist(0, 2).join(' '),
                  ),
                  _mobileMetric("Word Count", "${item.wordCount}"),
                  _mobileMetric("Grade", "${item.grade ?? '-'}"),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "Fingerprint",
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          color: const Color(0xFF667085),
                        ),
                      ),
                      const SizedBox(height: 4),
                      item.hasFingerprint
                          ? const Icon(
                              Icons.fingerprint,
                              size: 18,
                              color: Color(0xFF344054),
                            )
                          : const Text("-"),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _mobileMetric(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 10,
            color: const Color(0xFF667085),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF101828),
          ),
        ),
      ],
    );
  }

  Widget _tableHeader(String text, {TextAlign textAlign = TextAlign.left}) =>
      Text(
        text,
        textAlign: textAlign,
        style: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: const Color(0xFF667085), // Grey 500
        ),
      );

  // --- Dynamic Action Button ---
  Widget _buildActionButton(String status, {bool isCompact = false}) {
    bool isReview =
        status ==
        'pending'; // Pending = Review (Purple), Graded = View (Outlined)

    return Container(
      height: 36,
      constraints: BoxConstraints(minWidth: isCompact ? 80 : 100),
      decoration: BoxDecoration(
        // Use Gradient for Review, White for View
        gradient: isReview
            ? const LinearGradient(
                colors: [
                  Color(0xFF7F56D9),
                  Color(0xFF53389E),
                ], // Purple Gradient
              )
            : null,
        color: isReview ? null : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: isReview
            ? null
            : Border.all(color: const Color(0xFFD0D5DD)), // Outline for View
      ),
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.visibility_outlined,
              size: 16,
              color: isReview ? Colors.white : const Color(0xFF344054),
            ),
            const SizedBox(width: 8),
            Text(
              isReview ? "Review" : "View",
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isReview ? Colors.white : const Color(0xFF344054),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- 4. Helper: Stats/Filter Header (Reused/Updated) ---
class _GradingStatsHeader extends StatelessWidget {
  const _GradingStatsHeader();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GradingBloc, GradingState>(
      builder: (context, state) {
        if (state is! GradingLoaded) return const SizedBox.shrink();

        return LayoutBuilder(
          builder: (context, constraints) {
            final isDesktop = constraints.maxWidth > 900;

            final cards = [
              _buildCard(
                context,
                "Pending Review",
                "${state.pendingItems.length}",
                const Color(0xFFE04F16),
                'pending',
                state.currentFilter,
              ),
              const SizedBox(width: 24, height: 16),
              _buildCard(
                context,
                "Graded Assignments",
                "${state.gradedItems.length}",
                const Color(0xFF027A48),
                'graded',
                state.currentFilter,
              ),
              const SizedBox(width: 24, height: 16),
              _buildCard(
                context,
                "Total Assignment",
                "${state.allItems.length}",
                const Color(0xFF9c40b9),
                'total',
                state.currentFilter,
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

  Widget _buildCard(
    BuildContext context,
    String title,
    String count,
    Color color,
    String filterKey,
    String currentFilter,
  ) {
    final isSelected = filterKey == currentFilter;
    return InkWell(
      onTap: () =>
          context.read<GradingBloc>().add(FilterGradingEvent(filterKey)),
      borderRadius: BorderRadius.circular(16),
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
          border: Border.all(color: const Color(0xFFEAECF0)),
          boxShadow: isSelected
              ? []
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF101828),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              count,
              style: GoogleFonts.inter(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
