import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AiUsageChart extends StatefulWidget {
  const AiUsageChart({super.key});

  @override
  State<AiUsageChart> createState() => _AiUsageChartState();
}

class _AiUsageChartState extends State<AiUsageChart> {
  String _selectedTimeRange = "Last 30 days";
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Header Section (Title + Time Dropdown + Filter)
          LayoutBuilder(
            builder: (context, constraints) {
              final isMobile = constraints.maxWidth < 400;

              // Title & Time Range Dropdown
              final titleSection = Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "AI Usage Overview",
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Time Range Dropdown
                  PopupMenuButton<String>(
                    initialValue: _selectedTimeRange,
                    color: Colors.white,
                    onSelected: (value) {
                      setState(() {
                        _selectedTimeRange = value;
                      });
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: "Last 24 hours",
                        child: Text("Last 24 hours"),
                      ),
                      const PopupMenuItem(
                        value: "Last 7 days",
                        child: Text("Last 7 days"),
                      ),
                      const PopupMenuItem(
                        value: "Last 30 days",
                        child: Text("Last 30 days"),
                      ),
                      const PopupMenuItem(
                        value: "This year",
                        child: Text("This year"),
                      ),
                      const PopupMenuItem(
                        value: "Custom",
                        child: Text("Custom"),
                      ),
                    ],
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Time Range: ",
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        Text(
                          _selectedTimeRange,
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            color: const Color(0xFF7F56D9), // Brand Purple
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Icon(
                          Icons.keyboard_arrow_down,
                          size: 16,
                          color: Color(0xFF7F56D9),
                        ),
                      ],
                    ),
                  ),
                ],
              );

              // Existing "Creative Writing" Filter
              final dropdownSection = Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade200),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Creative Writing 101",
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: const Color(0xFF7F56D9),
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.keyboard_arrow_down,
                      size: 16,
                      color: Color(0xFF7F56D9),
                    ),
                  ],
                ),
              );

              if (isMobile) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    titleSection,
                    const SizedBox(height: 12),
                    dropdownSection,
                  ],
                );
              } else {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [titleSection, dropdownSection],
                );
              }
            },
          ),

          const SizedBox(height: 12),

          // 2. Stats Boxes (Scrollable Row)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _StatCard(
                  title: "Writing Fingerprint\nAverage Deviation",
                  value: "17%",
                  trendIcon: Icons.arrow_downward,
                  trendColor: const Color(0xFF7F56D9), // Purple
                ),
                const SizedBox(width: 20),
                _StatCard(
                  title: "AI Prompt Used\nAverage",
                  value: "3",
                  trendIcon: Icons.arrow_outward,
                  trendColor: const Color(0xFF7F56D9),
                ),
                const SizedBox(width: 20),
                _StatCard(
                  title: "AI Prompt Used\nTotal",
                  value: "543",
                  trendIcon: Icons.arrow_downward, // Trending down
                  trendColor: const Color(0xFF7F56D9),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // 3. The Chart (Responsive Scrollable Logic)
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                // Logic: If screen width is small (Mobile/Tablet),
                // force the chart to be 800px wide and allow scrolling.
                // Otherwise, let it fit the container normally.
                final isMobile = constraints.maxWidth < 600;

                // The actual Chart Widget
                Widget barChart = BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    maxY: 400,
                    barTouchData: BarTouchData(enabled: false),
                    titlesData: FlTitlesData(
                      show: true,
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            const style = TextStyle(
                              color: Colors.grey,
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            );
                            String text;
                            switch (value.toInt()) {
                              case 0:
                                text = 'JAN';
                                break;
                              case 1:
                                text = 'FEB';
                                break;
                              case 2:
                                text = 'MAR';
                                break;
                              case 3:
                                text = 'APR';
                                break;
                              case 4:
                                text = 'MAY';
                                break;
                              case 5:
                                text = 'JUN';
                                break;
                              case 6:
                                text = 'JUL';
                                break;
                              case 7:
                                text = 'AUG';
                                break;
                              case 8:
                                text = 'SEP';
                                break;
                              case 9:
                                text = 'OCT';
                                break;
                              case 10:
                                text = 'NOV';
                                break;
                              case 11:
                                text = 'DEC';
                                break;
                              default:
                                return Container();
                            }
                            return SideTitleWidget(
                              axisSide: meta.axisSide,
                              child: Text(text, style: style),
                            );
                          },
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 36,
                          interval: 100,
                          getTitlesWidget: (value, meta) {
                            if (value == 0) return const SizedBox.shrink();
                            return SideTitleWidget(
                              axisSide: meta.axisSide,
                              child: Text(
                                value.toInt().toString(),
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 10,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      topTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 12,
                        ),
                      ),
                      rightTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                    ),
                    gridData: FlGridData(show: false),
                    borderData: FlBorderData(show: false),
                    barGroups: List.generate(12, (index) {
                      return BarChartGroupData(
                        x: index,
                        barRods: [
                          BarChartRodData(
                            toY:
                                (index * 35.0) % 350 +
                                50, // Randomized dummy data
                            gradient: const LinearGradient(
                              colors: [Color(0xFF2350b3), Color(0xFFc86de5)],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                            ),
                            width: 14, // Slightly thinner for better spacing
                            borderRadius: BorderRadius.circular(8),
                            backDrawRodData: BackgroundBarChartRodData(
                              show: true,
                              toY: 400,
                              color: const Color(0xFFF9F5FF),
                            ),
                          ),
                        ],
                      );
                    }),
                  ),
                );

                if (isMobile) {
                  return ScrollbarTheme(
                    data: ScrollbarThemeData(
                      thumbColor: WidgetStateProperty.all(
                        Color.fromARGB(255, 183, 153, 243),
                      ), // Your color
                      trackColor: WidgetStateProperty.all(Color(0xFFEDE7F6)),
                      trackBorderColor: WidgetStateProperty.all(
                        Colors.transparent,
                      ),
                      radius: const Radius.circular(8),
                      thickness: WidgetStateProperty.all(6),
                    ),
                    child: Scrollbar(
                      controller: _scrollController,
                      thumbVisibility: true, // Always show the scrollbar
                      trackVisibility: true, // Show the track background

                      child: SingleChildScrollView(
                        controller: _scrollController,
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.only(
                          bottom: 12,
                        ), // Space for scrollbar
                        child: SizedBox(
                          width: 500, // Force sufficient width for spacing
                          child: barChart,
                        ),
                      ),
                    ),
                  );
                } else {
                  return barChart; // Standard fit on desktop
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

// --- Helper Widget for the Stats Boxes ---
class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData trendIcon;
  final Color trendColor;

  const _StatCard({
    required this.title,
    required this.value,
    required this.trendIcon,
    required this.trendColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F3FF),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1D2939),
              height: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                value,
                style: GoogleFonts.inter(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF7F56D9),
                ),
              ),
              const Spacer(),
              Icon(trendIcon, color: trendColor, size: 20),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            "in the last 30 days",
            style: GoogleFonts.inter(
              fontSize: 10,
              color: const Color(0xFF7F56D9).withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }
}
