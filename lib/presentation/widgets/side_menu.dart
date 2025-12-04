import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../logic/navigation_cubit.dart';

class SideMenu extends StatelessWidget {
  final bool isDrawer; // New flag to determine layout mode

  const SideMenu({
    super.key,
    this.isDrawer = false, // Default to Desktop mode (floating)
  });

  @override
  Widget build(BuildContext context) {
    // Gradient definition based on the purple sidebar
    const gradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xffe5cff5),
        Color(0xFFb3c6e6),
      ],
    );

    return Container(
      // On Mobile (Drawer), fill the available width.
      // On Desktop, stick to the fixed 260px width.
      width: isDrawer ? double.infinity : 260,
      
      // LOGIC: If in Drawer, remove margins to fill the panel.
      // If Desktop, keep the floating margin.
      margin: isDrawer 
          ? EdgeInsets.zero 
          : const EdgeInsets.fromLTRB(24, 0, 24, 24),
      
      decoration: BoxDecoration(
        gradient: gradient,
        // LOGIC: If in Drawer, we don't need rounded corners on the left/outer edges.
        borderRadius: isDrawer 
            ? BorderRadius.zero 
            : BorderRadius.circular(24),
        // Optional: Remove shadow in drawer mode as the Drawer itself usually has elevation
        boxShadow: isDrawer 
            ? [] 
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: SafeArea( // Added SafeArea for mobile notches
        bottom: false, // Don't need bottom safe area usually
        child: Column(
          children: [
            const SizedBox(height: 30),
            // Main Navigation Items
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _SideMenuItem(index: 0, label: 'Dashboard', icon: Icons.speed),
                  _SideMenuItem(index: 1, label: 'Classes', icon: Icons.people_alt_outlined),
                  _SideMenuItem(index: 2, label: 'Writing Fingerprint', icon: Icons.fingerprint),
                  _SideMenuItem(index: 3, label: 'Assignments', icon: Icons.assignment_outlined),
                  _SideMenuItem(index: 4, label: 'Grading', icon: Icons.grade_outlined),
                  _SideMenuItem(index: 5, label: 'Calendar', icon: Icons.calendar_today_outlined),
                  _SideMenuItem(index: 6, label: 'Analytics', icon: Icons.analytics_outlined),
                ],
              ),
            ),
            // Bottom Navigation Items
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Column(
                children: [
                  _SideMenuItem(index: 7, label: 'Settings', icon: Icons.settings_outlined),
                  _SideMenuItem(index: 8, label: 'Help', icon: Icons.help_outline),
                ],
              ),
            ),
          ],
        ),
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
          onTap: () {
            context.read<NavigationCubit>().selectTab(index);
            // Optional: Close drawer on mobile selection
            if (Scaffold.of(context).hasDrawer && Scaffold.of(context).isDrawerOpen) {
              Navigator.pop(context);
            }
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            decoration: BoxDecoration(
              color: isSelected ? Colors.white : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 20,
                  color: const Color(0xFF1D2939),
                ),
                const SizedBox(width: 12),
                Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: const Color(0xFF1D2939),
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