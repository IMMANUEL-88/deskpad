import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AiUsageChart extends StatelessWidget {
  const AiUsageChart({super.key});

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
          // Use LayoutBuilder to switch between Row and Column for the header
          LayoutBuilder(
            builder: (context, constraints) {
              // Breakpoint: if width is less than 400px, stack them vertically
              final isMobile = constraints.maxWidth < 400;

              // 1. Title Section
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
                  Text(
                    "Time Range: Last 30 Days",
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: Colors.purple,
                    ),
                  ),
                ],
              );

              // 2. Dropdown Section
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
                  mainAxisSize: MainAxisSize.min, // Keep tight to content
                  children: [
                    Text(
                      "Creative Writing 101",
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: Colors.purple,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.keyboard_arrow_down,
                      size: 16,
                      color: Colors.purple,
                    ),
                  ],
                ),
              );

              // Conditional Layout
              if (isMobile) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    titleSection,
                    const SizedBox(
                      height: 12,
                    ), // Spacing between title and dropdown
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

          const SizedBox(height: 24),

          Expanded(
            child: BarChart(
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
                          color: Colors.black,
                          fontSize: 10,
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
                      reservedSize: 36, // Keeping your fix for overflow
                      interval: 100,
                    ),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
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
                        toY: (index * 30.0) % 400 + 50,
                        gradient: const LinearGradient(
                          colors: [Color(0xFF2350b3), Color(0xFFc86de5)],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                        width: 16,
                        borderRadius: BorderRadius.circular(12),
                        backDrawRodData: BackgroundBarChartRodData(
                          show: true,
                          toY: 400,
                          color: Colors.purple.withValues(
                            alpha: 0.05,
                          ), // Fixed for compatibility
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
