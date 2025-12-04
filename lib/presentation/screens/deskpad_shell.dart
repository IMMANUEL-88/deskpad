import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../logic/navigation_cubit.dart';
import '../widgets/side_menu.dart';
// Placeholders for future screens
// import 'dashboard_screen.dart'; // We will create this in Day 4
// import 'classes_screen.dart';   // We will create this in Day 5

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

  @override
  Widget build(BuildContext context) {
    final selectedIndex = context.watch<NavigationCubit>().state;

    return LayoutBuilder(
      builder: (context, constraints) {
        // Desktop Layout
        if (constraints.maxWidth > 900) {
          return Scaffold(
            body: Row(
              children: [
                const SideMenu(),
                Expanded(
                  child: _getPage(selectedIndex),
                ),
              ],
            ),
          );
        } 
        
        // Mobile/Tablet Layout
        else {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              iconTheme: const IconThemeData(color: Colors.black87),
              title: const Text("Deskpad", style: TextStyle(color: Colors.black87)),
            ),
            drawer: const Drawer(
              child: SideMenu(), // Reusing the same sidebar widget
            ),
            body: _getPage(selectedIndex),
          );
        }
      },
    );
  }

  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return const Center(child: Text("Dashboard (Coming Day 4)")); 
      case 1:
        return const Center(child: Text("Classes (Coming Day 5)"));
      default:
        return Center(child: Text("Page Index: $index"));
    }
  }
}