import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/models/deskpad_models.dart';

class StudentListTable extends StatelessWidget {
  final List<StudentEntity> students;

  const StudentListTable({super.key, required this.students});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // BREAKPOINT: If width < 700, switch to Mobile Card View
        if (constraints.maxWidth < 700) {
          return _buildMobileLayout(students);
        } else {
          return _buildDesktopTable(students);
        }
      },
    );
  }

  // --- 1. MOBILE LAYOUT (Vertical Cards) ---
  Widget _buildMobileLayout(List<StudentEntity> students) {
    return Column(
      children: students.map((student) {
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Row 1: Name + Status Badge
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    student.name,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  _buildStatusBadge(student.status),
                ],
              ),
              const SizedBox(height: 8),

              // Row 2: Email
              Row(
                children: [
                  Icon(Icons.email_outlined, size: 14, color: Colors.black87),
                  const SizedBox(width: 6),
                  Text(
                    student.email,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),
              const Divider(height: 1),
              const SizedBox(height: 12),

              // Row 3: Fingerprint Status
              Row(
                children: [
                  Text(
                    "Writing Fingerprint:",
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: Colors.black87,
                    ),
                  ),
                  const Spacer(),
                  if (student.hasFingerprint) ...[
                    const Icon(
                      Icons.fingerprint,
                      size: 16,
                      color: Colors.black,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "Submitted",
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ] else
                    Text(
                      "Missing",
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: Colors.black,
                      ),
                    ),
                ],
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  // --- 2. DESKTOP LAYOUT (Classic Table) ---
  Widget _buildDesktopTable(List<StudentEntity> students) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
            child: Row(
              children: [
                Expanded(flex: 2, child: _buildHeader("Student")),
                Expanded(
                  flex: 2,
                  child: Center(child: _buildHeader("Writing Fingerprint")),
                ),
                Expanded(flex: 3, child: Center(child: _buildHeader("Email"))),
                Expanded(
                  flex: 1,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: _buildHeader("Status"),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          // Rows
          Column(
            children: students.asMap().entries.map((entry) {
              final index = entry.key;
              final student = entry.value;
              return Column(
                children: [
                  if (index > 0) const Divider(height: 1),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            student.name,
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Center(
                            child: student.hasFingerprint
                                ? const Icon(
                                    Icons.fingerprint,
                                    size: 24,
                                    color: Colors.black,
                                  )
                                : const Text(
                                    "-",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                  ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Center(
                            child: Text(
                              student.email,
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: _buildStatusBadge(student.status),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // Helper Widgets
  Widget _buildHeader(String text) {
    return Text(
      text,
      style: GoogleFonts.inter(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: Colors.black,
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    bool isActive = status == 'active';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: isActive
            ? const Color(0xFFECFDF3)
            : const Color.fromARGB(255, 220, 222, 224),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isActive ? const Color(0xFFABEFC6) : const Color(0xFFD0D5DD),
        ),
      ),
      child: Text(
        status,
        style: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: isActive ? const Color(0xFF027A48) : Colors.black,
        ),
      ),
    );
  }
}
