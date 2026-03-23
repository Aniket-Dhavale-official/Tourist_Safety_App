class TripModel {
  final String id;
  final String source;
  final String destination;
  final String date;
  final String time;
  final String duration;
  final String mode;
  final String route;
  final String? stops;

  TripModel({
    required this.id,
    required this.source,
    required this.destination,
    required this.date,
    required this.time,
    required this.duration,
    required this.mode,
    required this.route,
    this.stops,
  });
}