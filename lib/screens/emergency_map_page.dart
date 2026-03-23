import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class EmergencyMapPage extends StatefulWidget {
  final String emergencyType; // 'medical', 'police', 'fire'

  const EmergencyMapPage({super.key, required this.emergencyType});

  @override
  State<EmergencyMapPage> createState() => _EmergencyMapPageState();
}

class _EmergencyMapPageState extends State<EmergencyMapPage> {
  final Color primaryColor = const Color(0xFF1E3A8A);
  late String emergencyNumber;
  late String emergencyTitle;
  late IconData emergencyIcon;
  late Color emergencyColor;
  late List<EmergencyLocation> nearbyLocations;

  @override
  void initState() {
    super.initState();
    _initializeEmergencyData();
  }

  void _initializeEmergencyData() {
    switch (widget.emergencyType) {
      case 'medical':
        emergencyNumber = '102';
        emergencyTitle = 'Hospitals & Ambulances';
        emergencyIcon = Icons.local_hospital;
        emergencyColor = const Color(0xFF10B981);
        nearbyLocations = [
          EmergencyLocation(
            name: 'City General Hospital',
            distance: '2.3 km',
            address: '123 Medical Square, Downtown',
            phone: '+91-9876543210',
          ),
          EmergencyLocation(
            name: 'Apollo Medical Center',
            distance: '3.5 km',
            address: '456 Health Avenue, Midtown',
            phone: '+91-9876543211',
          ),
          EmergencyLocation(
            name: 'Emergency Care Clinic',
            distance: '1.8 km',
            address: '789 Relief Street, Suburb',
            phone: '+91-9876543212',
          ),
        ];
        break;
      case 'police':
        emergencyNumber = '100';
        emergencyTitle = 'Nearby Police Stations';
        emergencyIcon = Icons.local_police;
        emergencyColor = const Color(0xFF3B82F6);
        nearbyLocations = [
          EmergencyLocation(
            name: 'Central Police Station',
            distance: '1.5 km',
            address: '100 Law Street, Downtown',
            phone: '+91-9876543220',
          ),
          EmergencyLocation(
            name: 'Midtown Police Station',
            distance: '2.8 km',
            address: '200 Justice Avenue, Midtown',
            phone: '+91-9876543221',
          ),
          EmergencyLocation(
            name: 'Suburb Police Outpost',
            distance: '4.2 km',
            address: '300 Safety Lane, Suburb',
            phone: '+91-9876543222',
          ),
        ];
        break;
      case 'fire':
        emergencyNumber = '101';
        emergencyTitle = 'Nearby Fire Stations';
        emergencyIcon = Icons.fire_truck;
        emergencyColor = const Color(0xFFFB923C);
        nearbyLocations = [
          EmergencyLocation(
            name: 'Central Fire Station',
            distance: '3.1 km',
            address: '111 Fire Lane, Downtown',
            phone: '+91-9876543230',
          ),
          EmergencyLocation(
            name: 'Midtown Fire Brigade',
            distance: '2.4 km',
            address: '222 Emergency Road, Midtown',
            phone: '+91-9876543231',
          ),
          EmergencyLocation(
            name: 'Rapid Response Fire Station',
            distance: '5.0 km',
            address: '333 Alert Street, Suburb',
            phone: '+91-9876543232',
          ),
        ];
        break;
    }
  }

  Future<void> _callEmergency() async {
    final phoneNumber = 'tel:$emergencyNumber';
    if (await canLaunchUrl(Uri.parse(phoneNumber))) {
      await launchUrl(Uri.parse(phoneNumber));
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Cannot call $emergencyNumber')));
    }
  }

  Future<void> _callLocation(String phone) async {
    final phoneUrl = 'tel:$phone';
    if (await canLaunchUrl(Uri.parse(phoneUrl))) {
      await launchUrl(Uri.parse(phoneUrl));
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Cannot call $phone')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      appBar: AppBar(
        title: Text(emergencyTitle),
        backgroundColor: emergencyColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // MAP PLACEHOLDER & EMERGENCY CALL SECTION
          Container(
            color: emergencyColor,
            padding: const EdgeInsets.all(16),
            child: SafeArea(
              child: Column(
                children: [
                  // Map Placeholder
                  Container(
                    height: 240,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.map, size: 64, color: emergencyColor),
                        const SizedBox(height: 8),
                        Text(
                          'Map View',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Google Maps integration ready',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // EMERGENCY CALL BUTTON
                  ElevatedButton.icon(
                    onPressed: _callEmergency,
                    icon: const Icon(Icons.call, size: 24),
                    label: Text(
                      'Call Emergency: $emergencyNumber',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFDC2626),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 55),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // NEARBY LOCATIONS LIST
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(
                    'Nearest Locations',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                ),
                ...nearbyLocations.asMap().entries.map((entry) {
                  int index = entry.key;
                  EmergencyLocation location = entry.value;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _locationCard(location, index + 1),
                  );
                }).toList(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _locationCard(EmergencyLocation location, int rank) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: emergencyColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    '$rank',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: emergencyColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      location.name,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E3A8A),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.straighten, size: 14, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(
                          location.distance,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.location_on, size: 14, color: Colors.grey),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  location.address,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _callLocation(location.phone),
                  icon: const Icon(Icons.call, size: 18),
                  label: const Text('Call'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: emergencyColor,
                    side: BorderSide(color: emergencyColor),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Opening map to ${location.name}...'),
                      ),
                    );
                  },
                  icon: const Icon(Icons.directions, size: 18),
                  label: const Text('Directions'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: emergencyColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class EmergencyLocation {
  final String name;
  final String distance;
  final String address;
  final String phone;

  EmergencyLocation({
    required this.name,
    required this.distance,
    required this.address,
    required this.phone,
  });
}
