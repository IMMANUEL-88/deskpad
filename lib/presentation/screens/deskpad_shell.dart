import 'package:deskpad/presentation/screens/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../logic/navigation_cubit.dart';
import '../../core/theme/app_theme.dart';
import '../widgets/side_menu.dart';
import '../widgets/top_header.dart';

class DeskpadShell extends StatelessWidget {
  const DeskpadShell({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NavigationCubit(),
      child: const _DeskpadShellView(),
    );
  }
}

class _DeskpadShellView extends StatelessWidget {
  const _DeskpadShellView();

  // Helper to get the title based on the index
  String _getPageTitle(int index) {
    switch (index) {
      case 0:
        return 'Dashboard';
      case 1:
        return 'Classes';
      case 2:
        return 'Writing Fingerprint';
      case 3:
        return 'Assignments';
      case 4:
        return 'Grading';
      case 5:
        return 'Calendar';
      case 6:
        return 'Analytics';
      case 7:
        return 'Settings';
      case 8:
        return 'Help';
      default:
        return 'Deskpad';
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = context.watch<NavigationCubit>().state;

    // Define the same gradient used in SideMenu
    const gradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xffe5cff5), Color(0xFFb3c6e6)],
    );

    return Scaffold(
      backgroundColor: AppTheme.secondaryColor,
      body: LayoutBuilder(
        builder: (context, constraints) {
          // DESKTOP LAYOUT (> 900px)
          if (constraints.maxWidth > 900) {
            return Column(
              children: [
                const TopHeader(),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SideMenu(),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 24, bottom: 24),
                          child: _getPage(selectedIndex),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
          // MOBILE LAYOUT (< 900px)
          else {
            return Scaffold(
              appBar: AppBar(
                // 1. Remove flat background color
                backgroundColor: Colors.transparent,
                elevation: 0,

                // 2. Use flexibleSpace to apply the gradient
                flexibleSpace: Container(
                  decoration: const BoxDecoration(gradient: gradient),
                ),

                // 3. Dynamic Title based on selection
                title: Text(
                  _getPageTitle(selectedIndex),
                  style: const TextStyle(
                    color: Color(0xFF1D2939), // Dark text for contrast
                    fontWeight: FontWeight.w600,
                  ),
                ),

                // Ensure the hamburger menu icon is dark
                iconTheme: const IconThemeData(color: Color(0xFF1D2939)),
              ),
              drawer: const Drawer(
                // Pass isDrawer: true for full width/no margins
                child: SideMenu(isDrawer: true),
              ),
              body: _getPage(selectedIndex),
            );
          }
        },
      ),
    );
  }

  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return const DashboardScreen();
      case 1:
        return const Center(child: Text("Classes Page"));
      case 2:
        return const Center(child: Text("Writing Fingerprint Page"));
      case 3:
        return const Center(child: Text("Assignments Page"));
      case 4:
        return const Center(child: Text("Grading Page"));
      case 5:
        return const Center(child: Text("Calendar Page"));
      case 6:
        return const Center(child: Text("Analytics Page"));
      case 7:
        return const Center(child: Text("Settings Page"));
      case 8:
        return const Center(child: Text("Help Page"));
      default:
        return Center(child: Text("Page Index: $index"));
    }
  }
}
