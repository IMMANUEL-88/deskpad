import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class CreateAssignmentModal extends StatefulWidget {
  const CreateAssignmentModal({super.key});

  @override
  State<CreateAssignmentModal> createState() => _CreateAssignmentModalState();
}

class _CreateAssignmentModalState extends State<CreateAssignmentModal> {
  // Controllers
  final _titleController = TextEditingController();
  final _wordsController = TextEditingController();
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();
  final _detailsController = TextEditingController();

  // Dropdown Values
  String? _selectedRubric = '3';
  String? _selectedClass = 'English 101, Year 10, Period 3';

  // Date Selection Logic
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF7F56D9), // Brand Purple
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _dateController.text = DateFormat('MMMM d, y').format(picked);
      });
    }
  }

  // Time Selection Logic
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF7F56D9),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      if (mounted) {
        setState(() {
          _timeController.text = picked.format(context);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // --- RESPONSIVE LOGIC ---
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 600;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Container(
        // FIX 1: Use constraints instead of fixed width
        constraints: const BoxConstraints(maxWidth: 600),
        padding: EdgeInsets.all(
          isMobile ? 20 : 32,
        ), // FIX 2: Smaller padding on mobile
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Close Button on Left for Mobile to balance UI or keep right
                  const SizedBox(width: 24),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          "Create Assignment",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            fontSize: isMobile ? 20 : 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Complete the fields to set up your assignment",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: Colors.black54, // Lighter grey
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // --- Form Fields ---
              _FormRow(
                label: "Title",
                input: _buildTextField(
                  _titleController,
                  "To Kill a Mockingbird Human Nature Essay",
                ),
              ),
              const SizedBox(height: 16),

              _FormRow(
                label: "Target Words",
                input: _buildTextField(_wordsController, "1000"),
              ),
              const SizedBox(height: 16),

              _FormRow(
                label: "Number of Rubric",
                input: _buildDropdown(
                  value: _selectedRubric,
                  items: ['1', '2', '3', '4', '5'],
                  onChanged: (v) => setState(() => _selectedRubric = v),
                ),
              ),
              const SizedBox(height: 16),

              _FormRow(
                label: "Due Date",
                input: _buildTextField(
                  _dateController,
                  "Select Date",
                  icon: Icons.calendar_today_outlined,
                  readOnly: true,
                  onTap: () => _selectDate(context),
                ),
              ),
              const SizedBox(height: 16),

              _FormRow(
                label: "Due by",
                input: _buildTextField(
                  _timeController,
                  "Select Time",
                  icon: Icons.access_time,
                  readOnly: true,
                  onTap: () => _selectTime(context),
                ),
              ),
              const SizedBox(height: 16),

              _FormRow(
                label: "Class",
                input: _buildDropdown(
                  value: _selectedClass,
                  items: [
                    'English 101, Year 10, Period 3',
                    'AP English, Year 12, Period 1',
                    'Creative Writing, Year 11',
                  ],
                  onChanged: (v) => setState(() => _selectedClass = v),
                ),
              ),
              const SizedBox(height: 24),

              // Details Section
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Details",
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF344054),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _detailsController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText:
                      "To Kill a Mockingbird explores how people respond...",
                  hintStyle: GoogleFonts.inter(
                    color: Colors.grey.shade400,
                    fontStyle: FontStyle.italic,
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
              ),

              const SizedBox(height: 32),

              // Next Button
              Container(
                width: 180,
                height: 48,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF2E5CB8), Color(0xFF9E77ED)],
                  ),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: ElevatedButton(
                  onPressed: () {
                    // Handle submission
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: Text(
                    "Next",
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
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

  // Helper: Text Field Builder
  Widget _buildTextField(
    TextEditingController controller,
    String hint, {
    IconData? icon,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return TextField(
      controller: controller,
      readOnly: readOnly,
      onTap: onTap,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.inter(color: Colors.grey.shade500),
        suffixIcon: icon != null
            ? Icon(icon, color: Colors.grey.shade400, size: 20)
            : null,
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

  // Helper: Dropdown Builder
  Widget _buildDropdown({
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey.shade500),
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                style: GoogleFonts.inter(color: Colors.black87),
                overflow: TextOverflow
                    .ellipsis, // Add overflow handling for long dropdown items
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

// Helper: Responsive Form Row
class _FormRow extends StatelessWidget {
  final String label;
  final Widget input;

  const _FormRow({required this.label, required this.input});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Breakpoint for stacking label above input
        if (constraints.maxWidth < 450) {
          // Mobile Stacked Layout
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              input,
            ],
          );
        } else {
          // Desktop Side-by-Side Layout
          return Row(
            children: [
              SizedBox(
                width: 140, // Fixed label width
                child: Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF344054),
                  ),
                ),
              ),
              Expanded(child: input),
            ],
          );
        }
      },
    );
  }
}
