import 'package:flutter/material.dart';
import '../widgets/app_header.dart';
import '../widgets/app_drawer.dart';
import '../widgets/trip_statistics_chart.dart';
import '../widgets/safety_stats_card.dart';
import 'add_trip_page.dart';
import 'emergency_selection_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final Color primaryColor = const Color(0xFF1E3A8A);
  final Color secondaryColor = const Color(0xFF0F766E);
  final Color dangerColor = const Color(0xFFDC2626);

  // ✅ FETCH TRIPS FROM FIRESTORE
  Stream<QuerySnapshot> getTrips() {
    final user = FirebaseAuth.instance.currentUser;

    return FirebaseFirestore.instance
        .collection('trips')
        .doc(user!.uid)
        .collection('userTrips')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // ✅ NAVIGATE TO ADD TRIP PAGE
  void _openAddTrip() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddTripPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      drawer: const AppDrawer(),
      body: Column(
        children: [
          const AppHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 📊 SAFETY STATISTICS CARDS
                  const Text(
                    "Safety Overview",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 16),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    children: [
                      SafetyStatsCard(
                        title: 'Active Trips',
                        value: '3',
                        icon: Icons.card_travel,
                        color: const Color(0xFF1E3A8A),
                      ),
                      SafetyStatsCard(
                        title: 'Alerts',
                        value: '0',
                        icon: Icons.notifications_active,
                        color: const Color(0xFFDC2626),
                      ),
                      SafetyStatsCard(
                        title: 'Safe Zones',
                        value: '12',
                        icon: Icons.location_on,
                        color: const Color(0xFF0F766E),
                      ),
                      SafetyStatsCard(
                        title: 'Emergency',
                        value: '05',
                        icon: Icons.emergency,
                        color: const Color(0xFFFB923C),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // 📈 TRIP STATISTICS CHART
                  const TripStatisticsChart(tripCounts: [2, 3, 1, 4, 2, 5, 3]),
                  const SizedBox(height: 24),

                  const Text(
                    "Active Trip",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 20),

                  // ✅ ADD TRIP BUTTON
                  ElevatedButton.icon(
                    onPressed: _openAddTrip,
                    icon: const Icon(Icons.add),
                    label: const Text("Add New Trip"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: secondaryColor,
                      minimumSize: const Size(double.infinity, 55),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // ✅ FIRESTORE TRIPS LIST
                  StreamBuilder<QuerySnapshot>(
                    stream: getTrips(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return Container(
                          padding: const EdgeInsets.all(22),
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
                          child: const Center(
                            child: Text(
                              "No Trips Added",
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        );
                      }

                      final trips = snapshot.data!.docs;

                      return Column(
                        children: trips.map<Widget>((doc) {
                          final trip = doc.data() as Map<String, dynamic>;

                          return Container(
                            margin: const EdgeInsets.only(bottom: 24),
                            child: Column(
                              children: [
                                // TRIP CARD
                                Container(
                                  padding: const EdgeInsets.all(22),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Trip ID: ${trip['id']}",
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          Icon(
                                            Icons.directions_car,
                                            color: primaryColor,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        "${trip['source']} → ${trip['destination']}",
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.calendar_today,
                                            size: 16,
                                            color: Colors.grey,
                                          ),
                                          const SizedBox(width: 6),
                                          Text("${trip['date']}"),
                                          const SizedBox(width: 16),
                                          const Icon(
                                            Icons.access_time,
                                            size: 16,
                                            color: Colors.grey,
                                          ),
                                          const SizedBox(width: 6),
                                          Text("${trip['time']}"),
                                        ],
                                      ),
                                      const SizedBox(height: 6),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.route,
                                            size: 14,
                                            color: Colors.grey,
                                          ),
                                          const SizedBox(width: 6),
                                          Expanded(
                                            child: Text(
                                              "Mode: ${trip['mode']}",
                                              style: const TextStyle(
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 16),
                                // BUTTONS OUTSIDE CARD
                                Row(
                                  children: [
                                    Expanded(
                                      child: ElevatedButton.icon(
                                        onPressed: () {},
                                        icon: const Icon(Icons.error_outline),
                                        label: const Text("Submit Issue"),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: primaryColor,
                                          minimumSize: const Size(
                                            double.infinity,
                                            50,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 14),
                                    Expanded(
                                      child: ElevatedButton.icon(
                                        onPressed: () {},
                                        icon: const Icon(Icons.history),
                                        label: const Text("View History"),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: secondaryColor,
                                          minimumSize: const Size(
                                            double.infinity,
                                            50,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),

                  const SizedBox(height: 30),
                  // 🚨 PANIC BUTTON
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const EmergencySelectionPage(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.emergency, size: 28),
                    label: const Text(
                      "PANIC",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: dangerColor,
                      minimumSize: const Size(double.infinity, 65),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
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
}
