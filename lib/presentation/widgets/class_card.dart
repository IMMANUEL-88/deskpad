import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/models/deskpad_models.dart';

class ClassCard extends StatelessWidget {
  final ClassEntity classData;

  const ClassCard({super.key, required this.classData});

  @override
  Widget build(BuildContext context) {
    bool isActive = classData.status == 'active';

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

          // 1. Main Content (Title, Description, Stats)
          final mainContent = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Title + Badge
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 12,
                runSpacing: 8,
                children: [
                  Text(
                    classData.title,
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
                      color: isActive
                          ? const Color(0xFFECFDF3)
                          : const Color.fromARGB(255, 255, 242, 236),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isActive
                            ? const Color(0xFFABEFC6)
                            : const Color.fromARGB(255, 245, 192, 172),
                      ),
                    ),
                    child: Text(
                      classData.status,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: isActive
                            ? const Color(0xFF027A48)
                            : const Color(0xFFE04F16),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                classData.description,
                style: GoogleFonts.inter(color: Colors.black, fontSize: 13),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 20),
              // Stats
              Wrap(
                spacing: 16,
                runSpacing: 8,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  _buildIconStat(
                    Icons.people_outline,
                    "${classData.studentsCount} students",
                  ),
                  _buildIconStat(
                    Icons.assignment_outlined,
                    "${classData.activeAssignments} active assignments",
                  ),
                  _buildIconStat(
                    Icons.calendar_today_outlined,
                    classData.term,
                  ),
                  _buildIconStat(
                    Icons.school_outlined,
                    classData.gradeLevel,
                  ),
                  _buildIconStat(
                    Icons.fingerprint,
                    "${classData.fingerprintsSubmitted} Writing Fingerprints submitted",
                  ),
                ],
              ),
            ],
          );

          // 2. Action Button
          final actionButton = OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.black,
              side: BorderSide(color: Colors.grey.shade300),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center, // Center text
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
                  Icons.arrow_forward,
                  size: 18,
                  color: Colors.black,
                ),
              ],
            ),
          );

          // Responsive Logic
          if (isMobile) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                mainContent,
                const SizedBox(height: 24),
                actionButton,
              ],
            );
          } else {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(child: mainContent), // Text takes available space
                const SizedBox(width: 24),
                actionButton,
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildIconStat(IconData icon, String text) {
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