import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../logic/auth_bloc.dart';
import '../../core/theme/app_theme.dart';
import 'deskpad_shell.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Plain background as per image
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            // Navigate to Dashboard on success
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const DeskpadShell()),
            );
          } else if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error), backgroundColor: Colors.red),
            );
          }
        },
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: LayoutBuilder(
              builder: (context, constraints) {
                // Determine if we are on wide screen
                bool isWide = constraints.maxWidth > 900;

                return Container(
                  width: isWide ? 900 : 450,
                  height: isWide ? 600 : null, // Auto height on mobile
                  decoration: BoxDecoration(
                    color: const Color(
                      0xFFEEF2FF,
                    ), // Very light periwinkle background inside the border
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: Colors.blue.withOpacity(0.3),
                      width: 1,
                    ), // The dotted/dashed line implementation
                  ),
                  child: isWide
                      ? Row(
                          children: [
                            Expanded(child: _LoginForm()),
                            Expanded(child: _BrandSidePanel()),
                          ],
                        )
                      : Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // On mobile, maybe show brand logo smaller or just the form
                            const SizedBox(height: 20),
                            const _BrandSidePanel(isMobile: true),
                            _LoginForm(),
                          ],
                        ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _LoginForm extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  _LoginForm();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "WELCOME BACK",
            style: GoogleFonts.inter(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Please enter your details.",
            style: GoogleFonts.inter(color: Colors.grey, fontSize: 14),
          ),

          const SizedBox(height: 32),

          _buildLabel("Email"),
          _buildInput("Enter your email", _emailController),

          const SizedBox(height: 20),

          _buildLabel("Password"),
          _buildInput("**********", _passController, isObscure: true),

          const SizedBox(height: 16),

          // Remember Me & Forgot Password
          Row(
            children: [
              SizedBox(
                height: 24,
                width: 24,
                child: Checkbox(value: false, onChanged: (v) {}),
              ),
              const SizedBox(width: 8),
              Text("Remember me", style: GoogleFonts.inter(fontSize: 12)),
              const Spacer(),
              TextButton(
                onPressed: () {},
                child: Text(
                  "Forgot password",
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Sign In Button (Gradient)
          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              return Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF7F56D9),
                      Color(0xFF53389E),
                    ], // Purple Gradient
                  ),
                ),
                child: ElevatedButton(
                  onPressed: state is AuthLoading
                      ? null
                      : () {
                          context.read<AuthBloc>().add(
                            LoginRequested(
                              _emailController.text,
                              _passController.text,
                            ),
                          );
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: state is AuthLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "Sign in",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              );
            },
          ),

          const SizedBox(height: 16),

          // Google Button
          OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              side: BorderSide(color: Colors.grey.shade300),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Placeholder for Google Icon
                Image.asset(
                  "assets/icons/google-icon.png",
                  width: 24,
                  height: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  "Sign in with Google",
                  style: GoogleFonts.inter(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),
          Center(
            child: Text(
              "To sign in your school? Click this SSO Button",
              style: GoogleFonts.inter(fontSize: 11, color: Colors.purple),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildInput(
    String hint,
    TextEditingController controller, {
    bool isObscure = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: isObscure,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
      ),
    );
  }
}

class _BrandSidePanel extends StatelessWidget {
  final bool isMobile;
  const _BrandSidePanel({this.isMobile = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: isMobile ? 200 : double.infinity,
      width: double.infinity,
      decoration: const BoxDecoration(color: Colors.transparent),
      child: Center(
        child: Container(
          width: isMobile ? 150 : 280,
          height: isMobile ? 150 : 280,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF2E5CB8),
                Color(0xFF9E77ED),
              ], // Blue to Purple gradient
            ),
          ),
          child: Center(
            child: Image.asset(
              "assets/icons/elephant-icon.png",
              width: isMobile ? 80 : 120,
              height: isMobile ? 80 : 120,
            ),
          ),
        ),
      ),
    );
  }
}
