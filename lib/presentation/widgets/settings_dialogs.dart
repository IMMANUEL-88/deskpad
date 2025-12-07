import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// --- 1. CHANGE PASSWORD DIALOG (Already Responsive, just refined) ---
class ChangePasswordDialog extends StatefulWidget {
  const ChangePasswordDialog({super.key});

  @override
  State<ChangePasswordDialog> createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends State<ChangePasswordDialog> {
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  @override
  Widget build(BuildContext context) {
    // Responsive width: 90% of screen on mobile, max 500px on desktop
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 600;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        width: 500,
        padding: EdgeInsets.all(isMobile ? 20 : 32),
        child: SingleChildScrollView(
          // Prevents overflow on small height screens
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Change Your Password",
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: isMobile ? 20 : 24,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF101828),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Are you sure you want to change?",
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: const Color(0xFF667085),
                ),
              ),
              const SizedBox(height: 24),
              _buildPasswordField(
                "New Password",
                _obscureNew,
                () => setState(() => _obscureNew = !_obscureNew),
              ),
              const SizedBox(height: 16),
              _buildPasswordField(
                "Confirm Password",
                _obscureConfirm,
                () => setState(() => _obscureConfirm = !_obscureConfirm),
              ),
              const SizedBox(height: 32),
              Container(
                width: double.infinity,
                height: 48,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF2E5CB8), Color(0xFF9E77ED)],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                  ),
                  child: Text(
                    "Confirm Password",
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField(
    String label,
    bool obscure,
    VoidCallback onToggle,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF344054),
            ),
            children: const [
              TextSpan(
                text: " *",
                style: TextStyle(color: Colors.red),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          obscureText: obscure,
          decoration: InputDecoration(
            hintText: "**********",
            suffixIcon: IconButton(
              icon: Icon(
                obscure
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                size: 20,
                color: Colors.grey,
              ),
              onPressed: onToggle,
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }
}

// --- 2. SECURITY & PRIVACY DIALOG (Refactored) ---
class SecurityPrivacyDialog extends StatelessWidget {
  const SecurityPrivacyDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 600;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 800, maxHeight: 600),
        child: Container(
          padding: EdgeInsets.all(isMobile ? 20 : 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Security & Privacy",
                style: GoogleFonts.inter(
                  fontSize: isMobile ? 18 : 20,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF101828),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Explains how we protect user data and ensure a secure experience.",
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: const Color(0xFF667085),
                ),
              ),
              const SizedBox(height: 24),

              // Scrollable Content
              Expanded(
                child: Scrollbar(
                  thumbVisibility: true,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(right: 16),
                    child: Text(
                      "At Deskpad, we are committed to safeguarding the privacy and security of all users... \n\nWe collect only the information necessary to provide our educational services. This may include account details such as names, email addresses, school affiliations, and user roles.\n\nThe information we collect is used to deliver and improve our platform, enable class and assignment management, and comply with legal requirements.\n\nAll user data is protected through encryption in transit and at rest. Our system undergoes regular security audits.\n\nWe may update this policy from time to time. For any questions regarding this policy, reach us at: support@deskpad.ai",
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        height: 1.6,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Responsive Actions
              LayoutBuilder(
                builder: (context, constraints) {
                  // Stack buttons if width is very narrow
                  if (constraints.maxWidth < 400) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _deleteButton(context),
                        const SizedBox(height: 12),
                        _acceptButton(context),
                      ],
                    );
                  }
                  // Otherwise Row
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [_deleteButton(context), _acceptButton(context)],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _deleteButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.pop(context);
        showDialog(
          context: context,
          builder: (_) => const DeleteAccountDialog(),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFF04438),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
      child: Text(
        "Delete My Account",
        style: GoogleFonts.inter(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
      ),
    );
  }

  Widget _acceptButton(BuildContext context) {
    return OutlinedButton(
      onPressed: () => Navigator.pop(context),
      style: OutlinedButton.styleFrom(
        foregroundColor: const Color(0xFF344054),
        side: const BorderSide(color: Colors.purple),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
      child: Text(
        "Accept and Close",
        style: GoogleFonts.inter(
          fontWeight: FontWeight.w600,
          fontSize: 13,
          color: Colors.black,
        ),
      ),
    );
  }
}

// --- 3. DELETE ACCOUNT WARNING DIALOG (Refactored) ---
class DeleteAccountDialog extends StatelessWidget {
  const DeleteAccountDialog({super.key});

  @override
  Widget build(BuildContext context) {
    // Width logic: on mobile take more width, on desktop cap at 450
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 600;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 16),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 450),
        child: Container(
          padding: EdgeInsets.all(isMobile ? 24 : 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Delete My Account",
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF101828),
                ),
              ),
              const SizedBox(height: 8),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: "Are you sure you want to delete ",
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: const Color(0xFF344054),
                  ),
                  children: const [
                    TextSpan(
                      text: "David Scott?",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF7F56D9),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Warning Box
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF3F2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.warning_amber_rounded,
                      color: Color(0xFFF04438),
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Warning",
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFFB42318),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "By deleting this account, you won’t be able to access the Deskpad system.",
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              color: const Color(0xFFB42318),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1570EF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text(
                        "No, Cancel",
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        showDialog(
                          context: context,
                          builder: (_) => const AccountDeletedDialog(),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF04438),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text(
                        "Yes, Delete",
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --- 4. ACCOUNT DELETED SUCCESS DIALOG (Refactored) ---
class AccountDeletedDialog extends StatelessWidget {
  const AccountDeletedDialog({super.key});

  @override
  Widget build(BuildContext context) {
    // Switch layout based on width
    final isMobile = MediaQuery.of(context).size.width < 650;

    return Dialog(
      backgroundColor: const Color(0xFFEEF4FF),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: const EdgeInsets.all(16),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: Container(
          padding: const EdgeInsets.all(40),
          child: isMobile
              ? Column(
                  // Mobile: Stack Vertically
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildGraphic(),
                    const SizedBox(height: 24),
                    _buildSuccessText(),
                  ],
                )
              : IntrinsicHeight(
                  // Desktop: Side-by-side
                  child: Row(
                    children: [
                      Expanded(child: _buildSuccessText()),
                      const SizedBox(width: 40),
                      _buildGraphic(),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildSuccessText() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "][deskpad",
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF7F56D9),
          ),
        ),
        const SizedBox(height: 24),
        const Icon(
          Icons.check_circle_outline,
          size: 32,
          color: Color(0xFF027A48),
        ),
        const SizedBox(height: 16),
        Text(
          "Your Account has been successfully deleted.",
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildGraphic() {
    return Container(
      width: 180, // Slightly smaller for better fit
      height: 180,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF1570EF), Color(0xFF9E77ED)],
        ),
      ),
      child: Center(
        // Using generic icon placeholder
        child: Image.asset(
          "assets/icons/elephant-icon.png",
          height: 100,
          width: 100,
        ),
      ),
    );
  }
}
