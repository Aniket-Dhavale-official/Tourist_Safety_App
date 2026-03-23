import 'package:flutter/material.dart';
import '../widgets/app_header.dart';
import '../widgets/app_drawer.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isEditing = false;
  final Color primaryColor = const Color(0xFF1E3A8A);

  final TextEditingController contactController = TextEditingController(
    text: "+91 9876543210",
  );
  final TextEditingController heightController = TextEditingController(
    text: "170 cm",
  );
  final TextEditingController weightController = TextEditingController(
    text: "70 kg",
  );
  final TextEditingController dobController = TextEditingController(
    text: "01/01/2000",
  );
  final TextEditingController allergiesController = TextEditingController(
    text: "None",
  );
  final TextEditingController medicationController = TextEditingController(
    text: "None",
  );
  final TextEditingController doctorController = TextEditingController(
    text: "Dr. Sharma - 9876543211",
  );
  final TextEditingController emergency1Controller = TextEditingController(
    text: "Father - 9876543212",
  );
  final TextEditingController emergency2Controller = TextEditingController(
    text: "Mother - 9876543213",
  );

  /// ================= AGE CALCULATION =================
  int calculateAge() {
    try {
      final parts = dobController.text.split("/");
      DateTime birthDate = DateTime(
        int.parse(parts[2]),
        int.parse(parts[1]),
        int.parse(parts[0]),
      );

      DateTime today = DateTime.now();
      int age = today.year - birthDate.year;

      if (today.month < birthDate.month ||
          (today.month == birthDate.month && today.day < birthDate.day)) {
        age--;
      }
      return age;
    } catch (_) {
      return 0;
    }
  }

  /// ================= DATE PICKER =================
  Future<void> _selectDate() async {
    DateTime initialDate = DateTime(2000);

    try {
      final parts = dobController.text.split("/");
      initialDate = DateTime(
        int.parse(parts[2]),
        int.parse(parts[1]),
        int.parse(parts[0]),
      );
    } catch (_) {}

    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        dobController.text =
            "${picked.day.toString().padLeft(2, '0')}/"
            "${picked.month.toString().padLeft(2, '0')}/"
            "${picked.year}";
      });
    }
  }

  /// ================= INPUT FIELD =================
  Widget buildField(
    String label,
    TextEditingController controller, {
    bool isDob = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextField(
        controller: controller,
        readOnly: !isEditing || isDob,
        onTap: isDob && isEditing ? _selectDate : null,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.grey.shade50,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
          suffixIcon: isDob ? const Icon(Icons.calendar_today) : null,
        ),
      ),
    );
  }

  /// ================= SECTION CARD WITH ICON =================
  Widget sectionCard({
    required String title,
    required Widget child,
    IconData? icon,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (icon != null) ...[
                Icon(icon, color: primaryColor, size: 24),
                const SizedBox(width: 12),
              ],
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          child,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    int age = calculateAge();

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      drawer: const AppDrawer(),
      body: Column(
        children: [
          const AppHeader(showBackButton: false),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  /// ================= PERSONAL INFO =================
                  sectionCard(
                    title: "Personal Information",
                    icon: Icons.person,
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            const CircleAvatar(
                              radius: 55,
                              backgroundImage: NetworkImage(
                                "https://via.placeholder.com/150",
                              ),
                            ),
                            if (isEditing)
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: CircleAvatar(
                                  radius: 18,
                                  backgroundColor: primaryColor,
                                  child: const Icon(
                                    Icons.camera_alt,
                                    size: 18,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        buildField("Contact Number", contactController),
                        buildField(
                          "Date of Birth (DD/MM/YYYY)",
                          dobController,
                          isDob: true,
                        ),
                        const SizedBox(height: 8),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Age: $age years",
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),

                  /// ================= PHYSICAL =================
                  sectionCard(
                    title: "Physical Details",
                    icon: Icons.fitness_center,
                    child: Column(
                      children: [
                        buildField("Height", heightController),
                        buildField("Weight", weightController),
                      ],
                    ),
                  ),

                  /// ================= MEDICAL =================
                  sectionCard(
                    title: "Medical Information",
                    icon: Icons.local_hospital,
                    child: Column(
                      children: [
                        buildField("Allergies", allergiesController),
                        buildField("Medication", medicationController),
                        buildField("Family Doctor", doctorController),
                      ],
                    ),
                  ),

                  /// ================= EMERGENCY =================
                  sectionCard(
                    title: "Emergency Contacts",
                    icon: Icons.emergency,
                    child: Column(
                      children: [
                        buildField("Emergency Contact 1", emergency1Controller),
                        buildField("Emergency Contact 2", emergency2Controller),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),

                  /// ================= EDIT BUTTON =================
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() => isEditing = !isEditing);
                    },
                    icon: Icon(isEditing ? Icons.save : Icons.edit),
                    label: Text(isEditing ? "Save Profile" : "Edit Profile"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      minimumSize: const Size(double.infinity, 55),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  /// ================= CHANGE PASSWORD =================
                  OutlinedButton.icon(
                    onPressed: () {
                      // Navigate to Change Password Page
                    },
                    icon: const Icon(Icons.lock_outline),
                    label: const Text("Change Password"),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 55),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
