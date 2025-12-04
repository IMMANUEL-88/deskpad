import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'presentation/screens/deskpad_shell.dart';

void main() {
  runApp(const DeskpadApp());
}

class DeskpadApp extends StatelessWidget {
  const DeskpadApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Deskpad',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const DeskpadShell(),
    );
  }
}