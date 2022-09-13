import 'package:whatsapp_clone/models/status.dart';

class StatusContact{
  final List<Status> statuses;
  final DateTime lastStatusTime;

  StatusContact({required this.statuses, required this.lastStatusTime});
}