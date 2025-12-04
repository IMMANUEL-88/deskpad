import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_theme.dart';

class TopHeader extends StatelessWidget {
  const TopHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80, // Fixed height for the header
      padding: const EdgeInsets.symmetric(horizontal: 24),
      color: AppTheme.secondaryColor, // Matches background
      child: Row(
        children: [
          // 1. Logo Section
          Text('][',
              style: GoogleFonts.inter(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.primaryColor)),
          Text('deskpad',
              style: GoogleFonts.inter(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF9E77ED))),

          const Spacer(), // Pushes everything else to the right

          // 2. Search Bar (Visible on Desktop)
          if (MediaQuery.of(context).size.width > 800)
            Container(
              width: 300,
              height: 45,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  const Icon(Icons.search, color: Colors.grey),
                  const SizedBox(width: 8),
                  Text('Search students, assignments...',
                      style: GoogleFonts.inter(color: Colors.grey.shade500, fontSize: 13)),
                ],
              ),
            ),

          const SizedBox(width: 24),

          // 3. Icons (Calendar, Bell, Settings)
          _HeaderIcon(icon: Icons.calendar_today_outlined),
          _HeaderIcon(icon: Icons.notifications_none),
          _HeaderIcon(icon: Icons.settings_outlined),

          const SizedBox(width: 24),

          // 4. User Profile
          Row(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('Mr. John Smith',
                      style: GoogleFonts.inter(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textDark,
                          fontSize: 14)),
                  Text('English Teacher',
                      style: GoogleFonts.inter(
                          color: AppTheme.textLight, fontSize: 12)),
                ],
              ),
              const SizedBox(width: 12),
              CircleAvatar(
                backgroundColor: Colors.grey.shade200,
                radius: 20,
                child: Text('JS',
                    style: GoogleFonts.inter(
                        fontWeight: FontWeight.bold, color: AppTheme.textDark)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeaderIcon extends StatelessWidget {
  final IconData icon;
  const _HeaderIcon({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Icon(icon, size: 22, color: AppTheme.textDark),
    );
  }
}