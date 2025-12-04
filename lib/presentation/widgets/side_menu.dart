import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../logic/navigation_cubit.dart';
import '../../core/theme/app_theme.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({super.key});

  @override
  Widget build(BuildContext context) {
    // The sidebar background color from the image (Soft Periwinkle/Lavender)
    final sidebarColor = const Color(0xFFDCDCF9);
    final sidebarGradient = const LinearGradient(
      colors: [Color(0xffe5cff5), Color(0xFFb3c6e6)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );

    return Container(
      width: 260,
      // color: sidebarColor,
      decoration: BoxDecoration(gradient: sidebarGradient),
      child: Column(
        children: [
          _buildLogo(),
          const SizedBox(height: 30),
          // Main Navigation Items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _SideMenuItem(index: 0, label: 'Dashboard', icon: Icons.speed),
                _SideMenuItem(
                  index: 1,
                  label: 'Classes',
                  icon: Icons.people_alt_outlined,
                ),
                _SideMenuItem(
                  index: 2,
                  label: 'Writing Fingerprint',
                  icon: Icons.fingerprint,
                ),
                _SideMenuItem(
                  index: 3,
                  label: 'Assignments',
                  icon: Icons.assignment_outlined,
                ),
                _SideMenuItem(
                  index: 4,
                  label: 'Grading',
                  icon: Icons.grade_outlined,
                ),
                _SideMenuItem(
                  index: 5,
                  label: 'Calendar',
                  icon: Icons.calendar_today_outlined,
                ),
                _SideMenuItem(
                  index: 6,
                  label: 'Analytics',
                  icon: Icons.analytics_outlined,
                ),
              ],
            ),
          ),
          // Bottom Navigation Items
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Column(
              children: [
                _SideMenuItem(
                  index: 7,
                  label: 'Settings',
                  icon: Icons.settings_outlined,
                ),
                _SideMenuItem(
                  index: 8,
                  label: 'Help',
                  icon: Icons.help_outline,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogo() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 10),
      child: Row(
        children: [
          Text(
            '][',
            style: GoogleFonts.inter(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: AppTheme.primaryColor,
            ),
          ),
          Text(
            'deskpad',
            style: GoogleFonts.inter(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF9E77ED),
            ),
          ),
        ],
      ),
    );
  }
}

class _SideMenuItem extends StatelessWidget {
  final int index;
  final String label;
  final IconData icon;

  const _SideMenuItem({
    required this.index,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final selectedIndex = context.watch<NavigationCubit>().state;
    final isSelected = selectedIndex == index;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => context.read<NavigationCubit>().selectTab(index),
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: isSelected ? Colors.white : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(icon, size: 20, color: Colors.black),
                const SizedBox(width: 12),
                Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
