import 'package:flutter/material.dart';
import 'emergency_map_page.dart';

class EmergencySelectionPage extends StatefulWidget {
  const EmergencySelectionPage({super.key});

  @override
  State<EmergencySelectionPage> createState() => _EmergencySelectionPageState();
}

class _EmergencySelectionPageState extends State<EmergencySelectionPage> {
  final Color primaryColor = const Color(0xFF1E3A8A);
  final Color dangerColor = const Color(0xFFDC2626);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      appBar: AppBar(
        title: const Text('Emergency Type'),
        backgroundColor: dangerColor,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HEADER
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
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
                        Icon(Icons.warning, color: dangerColor, size: 32),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'What Type of Emergency?',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1E3A8A),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Select the type to find nearby help',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // MEDICAL EMERGENCY
              _emergencyOption(
                context: context,
                icon: Icons.local_hospital,
                title: 'Medical Emergency',
                subtitle: 'Find nearby hospitals & ambulances',
                color: const Color(0xFF10B981),
                emergencyType: 'medical',
              ),
              const SizedBox(height: 20),

              // POLICE EMERGENCY
              _emergencyOption(
                context: context,
                icon: Icons.local_police,
                title: 'Police Emergency',
                subtitle: 'Find nearby police stations',
                color: const Color(0xFF3B82F6),
                emergencyType: 'police',
              ),
              const SizedBox(height: 20),

              // FIRE EMERGENCY
              _emergencyOption(
                context: context,
                icon: Icons.fire_truck,
                title: 'Fire Emergency',
                subtitle: 'Find nearby fire stations',
                color: const Color(0xFFFB923C),
                emergencyType: 'fire',
              ),
              const SizedBox(height: 32),

              // EMERGENCY NUMBERS
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.amber[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.amber, width: 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info, color: Colors.amber[800]),
                        const SizedBox(width: 8),
                        Text(
                          'Emergency Numbers',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.amber[900],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _emergencyNumberTile(
                      icon: Icons.local_hospital,
                      label: 'Ambulance',
                      number: '102',
                    ),
                    const SizedBox(height: 8),
                    _emergencyNumberTile(
                      icon: Icons.local_police,
                      label: 'Police',
                      number: '100',
                    ),
                    const SizedBox(height: 8),
                    _emergencyNumberTile(
                      icon: Icons.fire_truck,
                      label: 'Fire',
                      number: '101',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _emergencyOption({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required String emergencyType,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                EmergencyMapPage(emergencyType: emergencyType),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3), width: 2),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.1),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 32),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E3A8A),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward, color: color, size: 24),
          ],
        ),
      ),
    );
  }

  Widget _emergencyNumberTile({
    required IconData icon,
    required String label,
    required String number,
  }) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.amber[900]),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: Colors.amber[900],
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.amber[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            number,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.amber[900],
            ),
          ),
        ),
      ],
    );
  }
}
