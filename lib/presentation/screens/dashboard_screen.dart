import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../logic/dashboard_bloc.dart';
import '../widgets/summary_card.dart';
import '../widgets/ai_usage_chart.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  // Helper to build grade columns for the Active Students card
  Widget _buildGradeColumn(String grade, int count) {
    return Column(
      children: [
        Text(
          grade,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          "$count",
          style: GoogleFonts.inter(
            fontSize: 28,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF9c40b9),
          ),
        ), // Pink accent
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DashboardBloc()..add(LoadDashboardData()),
      child: BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, state) {
          if (state is DashboardLoading || state is DashboardInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is DashboardLoaded) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- FIX 1: Responsive Header (Stack on Mobile) ---
                  LayoutBuilder(
                    builder: (context, constraints) {
                      bool isMobile = constraints.maxWidth < 600;

                      // The content of the header
                      Widget welcomeText = Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Welcome Back, Mr. Smith",
                            style: GoogleFonts.inter(
                              fontSize: isMobile ? 20 : 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            "Here’s what’s happening with your students",
                            style: GoogleFonts.inter(
                              color: Colors.black87,
                              fontSize: isMobile ? 12 : 14,
                            ),
                          ),
                        ],
                      );

                      // Switch Layout based on width
                      if (isMobile) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            welcomeText,
                          ],
                        );
                      } else {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [welcomeText],
                        );
                      }
                    },
                  ),

                  const SizedBox(height: 32),

                  // --- FIX 2: Summary Cards Layout ---
                  LayoutBuilder(
                    builder: (context, constraints) {
                      // Define cards
                      Widget pendingCard = SummaryCard(
                        title: "Pending Review",
                        value: "${state.pendingReview}",
                        subtitle: "Submissions awaiting review",
                        accentColor: const Color(0xFFE04F16),
                      );
                      Widget gradedCard = SummaryCard(
                        title: "Graded This Week",
                        value: "${state.gradedThisWeek}",
                        subtitle: "Recently graded assignments",
                        accentColor: const Color(0xFF027A48),
                      );

                      // Custom "Active Students" card with grade breakdown
                      Widget activeCard = SummaryCard(
                        title: "Active Students",
                        subtitle: "Students using Deskpad in the last 24h",
                        value: "${state.activeStudents}",
                        active: true,
                        accentColor: const Color(0xFF9c40b9),
                        // Pass the custom row as bottomWidget
                        bottomWidget: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildGradeColumn("Grade 9", state.grade9Count),
                              _buildGradeColumn("Grade 10", state.grade10Count),
                              _buildGradeColumn("Grade 11", state.grade11Count),
                            ],
                          ),
                        ),
                      );

                      if (constraints.maxWidth > 900) {
                        // Desktop: Row
                        return Row(
                          children: [
                            Expanded(child: pendingCard),
                            const SizedBox(width: 24),
                            Expanded(child: gradedCard),
                            const SizedBox(width: 24),
                            Expanded(child: activeCard),
                          ],
                        );
                      } else {
                        // Mobile: Column
                        return Column(
                          children: [
                            SizedBox(
                              width: double.infinity,
                              child: pendingCard,
                            ),
                            const SizedBox(height: 16),
                            SizedBox(width: double.infinity, child: gradedCard),
                            const SizedBox(height: 16),
                            SizedBox(width: double.infinity, child: activeCard),
                          ],
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 32),

                  // --- Lower Section (Graph + Alerts) ---
                  LayoutBuilder(
                    builder: (context, constraints) {
                      bool isWide = constraints.maxWidth > 1000;

                      List<Widget> children = [
                        isWide
                            ? Expanded(
                                flex: 2,
                                child: SizedBox(
                                  height: 450,
                                  child: const AiUsageChart(),
                                ),
                              )
                            : SizedBox(
                                height: 500,
                                child: const AiUsageChart(),
                              ),

                        SizedBox(
                          width: isWide ? 24 : 0,
                          height: isWide ? 0 : 24,
                        ),

                        isWide
                            ? Expanded(
                                flex: 1,
                                child: _buildAlertsPanel(state.alerts),
                              )
                            : SizedBox(
                                height: 400,
                                child: _buildAlertsPanel(state.alerts),
                              ),
                      ];

                      return isWide
                          ? Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: children,
                            )
                          : Column(children: children);
                    },
                  ),
                ],
              ),
            );
          }
          return const Center(child: Text("Something went wrong"));
        },
      ),
    );
  }
}

Widget _buildAlertsPanel(List<Map<String, dynamic>> alerts) {
  return Container(
    height: 400,
    padding: const EdgeInsets.all(24),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(24),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Writing Fingerprint Alerts",
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 20),
        Expanded(
          child: ListView.separated(
            itemCount: alerts.length,
            separatorBuilder: (_, __) => const Divider(height: 30),
            itemBuilder: (context, index) {
              final alert = alerts[index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    alert['name'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    "Potential ${alert['deviation']} deviation.",
                    style: const TextStyle(fontSize: 12, color: Colors.black87),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    ),
  );
}
