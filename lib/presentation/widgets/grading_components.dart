import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// --- 1. Responsive Toolbar (Search & Sort) ---
class GradingToolbar extends StatelessWidget {
  const GradingToolbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 700;

          // Title
          final title = Text(
            "All Students",
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          );

          // Controls (Search + Sort)
          final controls = Row(
            children: [
              // Search
              Expanded(
                flex: isMobile ? 1 : 0, // Expand on mobile
                child: Container(
                  width: isMobile ? double.infinity : 200,
                  height: 40,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade500),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: [
                      Icon(Icons.search, color: Colors.grey.shade600, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: "Search",
                            border: InputBorder.none,
                            isDense: true,
                            hintStyle: GoogleFonts.inter(
                              fontSize: 13,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Sort
              Container(
                height: 40,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    if (!isMobile) ...[
                      Text(
                        "Sort by : ",
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                    Text(
                      "Newest",
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.keyboard_arrow_down,
                      size: 16,
                      color: Colors.black,
                    ),
                  ],
                ),
              ),
            ],
          );

          if (isMobile) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                title,
                const SizedBox(height: 16),
                controls, // Full width controls
              ],
            );
          } else {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [title, controls],
            );
          }
        },
      ),
    );
  }
}

// --- 2. Responsive Pagination Footer ---
class GradingPagination extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final int start;
  final int end;
  final Function(int) onPageChanged;

  const GradingPagination({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    required this.start,
    required this.end,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 700;

          final infoText = Text(
            "Showing data ${start + 1} to $end of $totalItems students",
            style: GoogleFonts.inter(fontSize: 12, color: Colors.grey.shade600),
          );

          final buttons = Row(
            mainAxisAlignment: isMobile
                ? MainAxisAlignment.center
                : MainAxisAlignment.end,
            children: [
              _pageBtn(
                Icons.chevron_left,
                enabled: currentPage > 1,
                onTap: () => onPageChanged(currentPage - 1),
              ),
              const SizedBox(width: 8),
              if (!isMobile) ...[
                _pageBtn(
                  "1",
                  active: currentPage == 1,
                  onTap: () => onPageChanged(1),
                ),
                const SizedBox(width: 8),
                _pageBtn(
                  "2",
                  active: currentPage == 2,
                  onTap: () => onPageChanged(2),
                ),
                const SizedBox(width: 8),
                _pageBtn(
                  "3",
                  active: currentPage == 3,
                  onTap: () => onPageChanged(3),
                ),
                const SizedBox(width: 8),
                Text("...", style: TextStyle(color: Colors.grey.shade600)),
                const SizedBox(width: 8),
                _pageBtn(
                  "$totalPages",
                  active: currentPage == totalPages,
                  onTap: () => onPageChanged(totalPages),
                ),
                const SizedBox(width: 8),
              ] else ...[
                // Simplified mobile pagination (Just "Page X of Y")
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    "Page $currentPage of $totalPages",
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
              _pageBtn(
                Icons.chevron_right,
                enabled: currentPage < totalPages,
                onTap: () => onPageChanged(currentPage + 1),
              ),
            ],
          );

          if (isMobile) {
            return Column(
              children: [buttons, const SizedBox(height: 16), infoText],
            );
          } else {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [infoText, buttons],
            );
          }
        },
      ),
    );
  }

  Widget _pageBtn(
    dynamic content, {
    bool active = false,
    bool enabled = true,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: enabled ? onTap : null,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: active ? const Color(0xFF7F56D9) : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Center(
          child: content is IconData
              ? Icon(
                  content,
                  size: 16,
                  color: enabled ? Colors.grey.shade600 : Colors.grey.shade300,
                )
              : Text(
                  content,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: active ? Colors.white : Colors.grey.shade700,
                  ),
                ),
        ),
      ),
    );
  }
}
