import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/models/deskpad_models.dart';

class AssignmentCard extends StatelessWidget {
  final AssignmentEntity data;

  const AssignmentCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    // Logic to hide button if status is Pending (as per requirements)
    bool isPending = data.status == 'pending';

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 600;

          // 1. Main Content
          final mainContent = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Title + Tag Row
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 12,
                runSpacing: 8,
                children: [
                  Text(
                    data.title,
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: data.tag == 'Review'
                          ? Colors.orange.shade100
                          : data.tag == 'View'
                          ? Colors.purple.shade100
                          : Colors.green.shade100,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: data.tag == 'Review'
                            ? Colors.orange.shade500
                            : data.tag == 'View'
                            ? Colors.purple.shade500
                            : Colors.green.shade500,
                      ),
                    ),
                    child: Text(
                      data.tag,
                      style:  TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: data.tag == 'Review'
                            ? Colors.orange.shade500
                            : data.tag == 'View'
                            ? Colors.purple.shade500
                            : Colors.green.shade500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                data.description,
                style: GoogleFonts.inter(fontSize: 13, color: Colors.black),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 20),

              // Meta Info Icons
              Wrap(
                spacing: 16,
                runSpacing: 8,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  _IconText(
                    Icons.people_outline,
                    "${data.submittedCount}/${data.totalStudents} submitted",
                  ),
                  _IconText(Icons.flag_outlined, data.courseName),
                  _IconText(Icons.school_outlined, data.gradeLevel),
                  _IconText(Icons.calendar_today_outlined, data.dueDate),
                ],
              ),
            ],
          );

          // 2. Action Button (only if not pending)
          Widget? actionButton;
          if (!isPending) {
            actionButton = OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.black,
                side: BorderSide(color: Colors.grey.shade300),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 16,
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "View Details",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(
                    Icons.visibility_outlined,
                    size: 18,
                    color: Colors.black,
                  ),
                ],
              ),
            );
          }

          // Responsive Layout Logic
          if (isMobile) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                mainContent,
                if (actionButton != null) ...[
                  const SizedBox(height: 24),
                  actionButton,
                ],
              ],
            );
          } else {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(child: mainContent),
                if (actionButton != null) ...[
                  const SizedBox(width: 24),
                  actionButton,
                ],
              ],
            );
          }
        },
      ),
    );
  }
}

class _IconText extends StatelessWidget {
  final IconData icon;
  final String text;
  const _IconText(this.icon, this.text);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: Colors.black),
        const SizedBox(width: 6),
        Text(text, style: GoogleFonts.inter(fontSize: 12, color: Colors.black)),
      ],
    );
  }
}
