import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock Data for September 2025
    // 1st is Monday.
    final List<CalendarEvent> events = [
      CalendarEvent(
          date: 2,
          course: "Creative Writing 101",
          title: "Author Spotlight: George Orwell"),
      CalendarEvent(
          date: 4,
          course: "Writing & Rhetoric 3H",
          title: "The Art of the Counterargument"),
      CalendarEvent(
          date: 12,
          course: "English Foundations 1H",
          title: "To Kill a Mockingbird Human Nature Essay"),
      CalendarEvent(
          date: 16,
          course: "AP English Language & Composition",
          title: "Macbeth Act 2 Essay"),
      CalendarEvent(
          date: 24,
          course: "AP English Language & Composition",
          title: "Imitate the Argument Essay"),
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Header
          _buildHeader(),
          const SizedBox(height: 24),

          // 2. Year Navigation
          _buildYearNav(),
          const SizedBox(height: 16),

          // 3. Responsive Calendar Content
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth < 900) {
                return _buildMobileAgenda(events);
              } else {
                return _buildDesktopGrid(events);
              }
            },
          ),
        ],
      ),
    );
  }

  // --- Header Section ---
  Widget _buildHeader() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 600;
        
        final textSection = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Calendar",
              style: GoogleFonts.inter(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Text(
              "Manage your assignment due dates",
              style: GoogleFonts.inter(color: Colors.black),
            ),
          ],
        );

        if (isMobile) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              textSection,
            ],
          );
        } else {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [textSection],
          );
        }
      },
    );
  }

  // --- Year Navigation (< 2024 ... 2026 >) ---
  Widget _buildYearNav() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "< 2024",
          style: GoogleFonts.inter(
            color: const Color(0xFF9c40b9), // Purple
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          "2026 >",
          style: GoogleFonts.inter(
            color: const Color(0xFF9c40b9),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  // --- Desktop Grid View ---
  Widget _buildDesktopGrid(List<CalendarEvent> events) {
    // September 2025 starts on a Monday (index 1) and has 30 days.
    // 0=Sun, 1=Mon, ..., 6=Sat
    final int firstWeekday = 1; 
    final int daysInMonth = 30;
    
    // Total cells = empty start slots + days
    // We display 5 rows (35 cells) to fit the month nicely
    final List<Widget> dayCells = [];

    // Add empty slots for days before Sep 1
    for (int i = 0; i < firstWeekday; i++) {
      dayCells.add(_CalendarCell(date: null));
    }

    // Add actual days
    for (int day = 1; day <= daysInMonth; day++) {
      // Find event for this day
      final event = events.where((e) => e.date == day).firstOrNull;
      dayCells.add(_CalendarCell(date: day, event: event));
    }

    // Fill remaining slots to complete the grid (up to 35 or 42)
    while (dayCells.length < 35) {
       dayCells.add(_CalendarCell(date: null));
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        children: [
          // 1. Day Headers (SUN, MON...)
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
            ),
            child: Row(
              children: ["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"]
                  .map((day) => Expanded(
                        child: Center(
                          child: Text(
                            day,
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ))
                  .toList(),
            ),
          ),
          
          // 2. Calendar Grid
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 7,
            childAspectRatio: 0.8, // Adjust for cell height
            children: dayCells,
          ),
        ],
      ),
    );
  }

  // --- Mobile Agenda View ---
  Widget _buildMobileAgenda(List<CalendarEvent> events) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               Text("September 2025", style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold)),
               const SizedBox(height: 16),
               ...events.map((e) => Container(
                 margin: const EdgeInsets.only(bottom: 12),
                 padding: const EdgeInsets.all(12),
                 decoration: BoxDecoration(
                   color: const Color(0xFF9c40b9).withOpacity(0.1),
                   border: Border(left: BorderSide(color: const Color(0xFF9c40b9), width: 4)),
                   borderRadius: BorderRadius.circular(4),
                 ),
                 child: Row(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     // Date Box
                     Column(
                       children: [
                         Text("SEP", style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey)),
                         Text("${e.date}", style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
                       ],
                     ),
                     const SizedBox(width: 16),
                     // Event Details
                     Expanded(
                       child: Column(
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: [
                           Text(e.course, style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF9c40b9))),
                           Text(e.title, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600)),
                         ],
                       ),
                     )
                   ],
                 ),
               )).toList()
            ],
          ),
        )
      ],
    );
  }
}

// --- Helper Widgets ---

class _CalendarCell extends StatelessWidget {
  final int? date;
  final CalendarEvent? event;

  const _CalendarCell({this.date, this.event});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(color: Colors.grey.shade100),
          bottom: BorderSide(color: Colors.grey.shade100),
        ),
      ),
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (date != null)
            Text(
              // Format "SEP 1" for the first day, otherwise just number
              date == 1 ? "SEP 1" : "$date",
              style: GoogleFonts.inter(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: Colors.black87,
              ),
            ),
          
          if (event != null) ...[
            const Spacer(),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0xFF9c40b9), // Purple event color
                borderRadius: BorderRadius.circular(4),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    event!.course,
                    style: GoogleFonts.inter(
                      fontSize: 9,
                      color: Colors.white.withOpacity(0.9),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    event!.title,
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ]
        ],
      ),
    );
  }
}

class CalendarEvent {
  final int date;
  final String course;
  final String title;

  CalendarEvent({required this.date, required this.course, required this.title});
}