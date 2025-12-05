import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/theme/app_theme.dart';
import 'logic/auth_bloc.dart';
import 'presentation/screens/login_screen.dart';

void main() {
  runApp(const DeskpadApp());
}

class DeskpadApp extends StatelessWidget {
  const DeskpadApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthBloc()),
        // NavigationCubit will be created inside DeskpadShell when we get there
      ],
      child: MaterialApp(
        title: 'Deskpad',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        // Start with Login Screen
        home: const LoginScreen(),
      ),
    );
  }
}
