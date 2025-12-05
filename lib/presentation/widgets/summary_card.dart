import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'gradient_button.dart'; // Import the new button

class SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final Color accentColor;
  final Widget? bottomWidget; // New: Accepts custom bottom content
  final String? subtitle; // Optional now
  final bool active; // Always show button for now

  const SummaryCard({
    super.key,
    required this.title,
    required this.value,
    required this.accentColor,
    this.bottomWidget,
    this.subtitle,
    this.active = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha:0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 42,
              fontWeight: FontWeight.w500,
              color: accentColor,
            ),
          ),
          const SizedBox(height: 2),

          // Display either custom bottomWidget or the default subtitle
          subtitle != null
              ? Text(
                  subtitle!,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: Colors.black,
                  ),
                )
              : SizedBox(),

          active ? const SizedBox(height: 12) : SizedBox(),

          bottomWidget != null ? bottomWidget! : SizedBox(),

          bottomWidget != null ? SizedBox() : const SizedBox(height: 24),

          // Use the new reusable GradientButton
          SizedBox(
            width: 110,
            child: active
                ? SizedBox()
                : GradientButton(
                    text: "View All >",
                    onPressed: () {
                      // TODO: Handle navigation
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
