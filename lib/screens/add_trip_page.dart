import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../widgets/app_header.dart';
import '../models/trip_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddTripPage extends StatefulWidget {
  final TripModel? existingTrip;

  const AddTripPage({super.key, this.existingTrip});

  @override
  State<AddTripPage> createState() => _AddTripPageState();
}

class _AddTripPageState extends State<AddTripPage> {
  final _formKey = GlobalKey<FormState>();

  final sourceController = TextEditingController();
  final destinationController = TextEditingController();
  final dateController = TextEditingController();
  final timeController = TextEditingController();
  final durationController = TextEditingController();
  final modeController = TextEditingController();
  final routeController = TextEditingController();
  final stopsController = TextEditingController();

  bool _isLoading = false;
  late String tripId;

  @override
  void initState() {
    super.initState();

    if (widget.existingTrip != null) {
      final trip = widget.existingTrip!;
      tripId = trip.id;
      sourceController.text = trip.source;
      destinationController.text = trip.destination;
      dateController.text = trip.date;
      timeController.text = trip.time;
      durationController.text = trip.duration;
      modeController.text = trip.mode;
      routeController.text = trip.route;
      stopsController.text = trip.stops ?? '';
    } else {
      tripId = DateTime.now().millisecondsSinceEpoch.toString();
    }
  }

  Future<void> _selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        dateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _selectTime() async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        timeController.text = picked.format(context);
      });
    }
  }

  Future<void> _saveTrip() async {
    if (!_formKey.currentState!.validate()) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("User not logged in")),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final tripData = {
        "id": tripId,
        "source": sourceController.text.trim(),
        "destination": destinationController.text.trim(),
        "date": dateController.text.trim(),
        "time": timeController.text.trim(),
        "duration": durationController.text.trim(),
        "mode": modeController.text.trim(),
        "route": routeController.text.trim(),
        "stops": stopsController.text.trim(),
        "updatedAt": Timestamp.now(),
        if (widget.existingTrip == null) "createdAt": Timestamp.now(),
      };

      await FirebaseFirestore.instance
          .collection('trips')
          .doc(user.uid)
          .collection('userTrips')
          .doc(tripId)
          .set(tripData, SetOptions(merge: true));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Trip saved successfully!")),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error saving trip: $e")),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Widget _field(String label, TextEditingController controller,
      {bool required = true, IconData? icon, VoidCallback? onTap, bool readOnly = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        readOnly: readOnly,
        onTap: onTap,
        validator: required
            ? (value) => value == null || value.isEmpty ? "Please enter $label" : null
            : null,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: icon != null ? Icon(icon, color: Colors.blueGrey) : null,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      body: Column(
        children: [
          const AppHeader(showBackButton: true),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.existingTrip != null ? "Edit Trip" : "Plan New Trip",
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E3A8A),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            "ID: $tripId",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade800,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _field("Source", sourceController, icon: Icons.location_on_outlined),
                    _field("Destination", destinationController, icon: Icons.flag_outlined),
                    Row(
                      children: [
                        Expanded(
                          child: _field(
                            "Date",
                            dateController,
                            icon: Icons.calendar_today,
                            readOnly: true,
                            onTap: _selectDate,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _field(
                            "Time",
                            timeController,
                            icon: Icons.access_time,
                            readOnly: true,
                            onTap: _selectTime,
                          ),
                        ),
                      ],
                    ),
                    _field("Duration", durationController, icon: Icons.timer_outlined),
                    _field("Mode of Travel", modeController, icon: Icons.directions_bus_outlined),
                    _field("Route Details", routeController, icon: Icons.map_outlined),
                    _field("Stops (Optional)", stopsController, required: false, icon: Icons.stop_circle_outlined),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _saveTrip,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0F766E),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : Text(
                                widget.existingTrip != null ? "Update Trip" : "Save Trip",
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
