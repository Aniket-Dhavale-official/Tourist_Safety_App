import 'package:flutter/material.dart';
import '../widgets/app_header.dart';
import '../widgets/app_drawer.dart';

class IssueReporting extends StatefulWidget {
  const IssueReporting({super.key});

  @override
  State<IssueReporting> createState() => _IssueReportingState();
}

class _IssueReportingState extends State<IssueReporting> {
  final Color primaryColor = const Color(0xFF1E3A8A);
  final Color dangerColor = const Color(0xFFDC2626);

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController locationController = TextEditingController();

  String selectedSeverity = 'Medium';
  String selectedCategory = 'Safety Concern';

  final List<String> severityLevels = ['Low', 'Medium', 'High', 'Critical'];
  final List<String> categories = [
    'Safety Concern',
    'Harassment',
    'Theft',
    'Accident',
    'Health Issue',
    'Infrastructure',
    'Other',
  ];

  @override
  Widget build(BuildContext context) {
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // HEADER
                  Row(
                    children: [
                      Icon(
                        Icons.warning_outlined,
                        color: dangerColor,
                        size: 28,
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Report Issue',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Help us improve safety by reporting issues you encounter',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 28),

                  // CATEGORY
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.category, color: primaryColor, size: 20),
                            const SizedBox(width: 8),
                            const Text(
                              'Issue Category',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        DropdownButton<String>(
                          value: selectedCategory,
                          isExpanded: true,
                          items: categories.map((String category) {
                            return DropdownMenuItem<String>(
                              value: category,
                              child: Row(
                                children: [
                                  Icon(
                                    _getCategoryIcon(category),
                                    size: 18,
                                    color: primaryColor,
                                  ),
                                  const SizedBox(width: 12),
                                  Text(category),
                                ],
                              ),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedCategory = newValue!;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // SEVERITY LEVEL
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.priority_high,
                              color: dangerColor,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Severity Level',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: severityLevels.map((level) {
                            final isSelected = selectedSeverity == level;
                            return GestureDetector(
                              onTap: () {
                                setState(() => selectedSeverity = level);
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? _getSeverityColor(level)
                                      : Colors.grey[100],
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: _getSeverityColor(level),
                                    width: isSelected ? 2 : 1,
                                  ),
                                ),
                                child: Text(
                                  level,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: isSelected
                                        ? Colors.white
                                        : _getSeverityColor(level),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // TITLE
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                        hintText: 'Issue Title',
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        prefixIcon: Icon(Icons.subject, color: primaryColor),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // LOCATION
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: locationController,
                      decoration: InputDecoration(
                        hintText: 'Location / Area',
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        prefixIcon: Icon(
                          Icons.location_on,
                          color: primaryColor,
                        ),
                        suffixIcon: Icon(
                          Icons.gps_fixed,
                          color: primaryColor,
                          size: 20,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // DESCRIPTION
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: descriptionController,
                      maxLines: 5,
                      decoration: InputDecoration(
                        hintText: 'Describe the issue in detail...',
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        prefixIcon: Icon(
                          Icons.description,
                          color: primaryColor,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // ATTACHMENT SECTION
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Column(
                      children: [
                        Icon(Icons.image, color: primaryColor, size: 32),
                        const SizedBox(height: 8),
                        const Text(
                          'Attach Evidence',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Photos or videos help us verify and act faster',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.photo_camera),
                              label: const Text('Camera'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor,
                              ),
                            ),
                            ElevatedButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.image),
                              label: const Text('Gallery'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),

                  // SUBMIT BUTTON
                  ElevatedButton.icon(
                    onPressed: () {
                      if (titleController.text.isEmpty ||
                          descriptionController.text.isEmpty ||
                          locationController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please fill all required fields'),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Issue reported successfully! Thank you.',
                            ),
                            backgroundColor: Color(0xFF10B981),
                          ),
                        );
                        // Clear fields
                        titleController.clear();
                        descriptionController.clear();
                        locationController.clear();
                      }
                    },
                    icon: const Icon(Icons.send, size: 20),
                    label: const Text('Submit Report'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      minimumSize: const Size(double.infinity, 55),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Safety Concern':
        return Icons.warning;
      case 'Harassment':
        return Icons.block;
      case 'Theft':
        return Icons.info;
      case 'Accident':
        return Icons.car_crash;
      case 'Health Issue':
        return Icons.medical_services;
      case 'Infrastructure':
        return Icons.construction;
      default:
        return Icons.help;
    }
  }

  Color _getSeverityColor(String level) {
    switch (level) {
      case 'Low':
        return const Color(0xFF10B981);
      case 'Medium':
        return const Color(0xFFFB923C);
      case 'High':
        return const Color(0xFFDC2626);
      case 'Critical':
        return const Color(0xFF7C2D12);
      default:
        return Colors.grey;
    }
  }
}
