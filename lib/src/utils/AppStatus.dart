import 'package:flutter/material.dart';

class AppStatus {
  AppStatus._();

  static const int pending = 1;
  static const int active = 2;
  static const int paused = 3;
  static const int completed = 4;
  static const int cancelled = 5;
  static const int transferred = 6;
  static const int open = 7;
  static const int resolved = 8;
  static const int closed = 9;
  static const int preparing = 10;
  static const int delivered = 11;
  static const int skipped = 12;
  static const int waiting = 13;
  static const int approved = 14;
  static const int rejected = 15;
  static const int paid = 16;
  static const int paymentPending = 17;
  static const int paymentReceived = 18;
  static const int paymentFailed = 19;
  static const int paymentRefunded = 20;

  static String getStatus(int? status) {
    switch (status) {
      case pending:
        return "Pending";
      case active:
        return "Active";
      case paused:
        return "Paused";
      case completed:
        return "Completed";
      case cancelled:
        return "Cancelled";
      case transferred:
        return "Transferred";
      case open:
        return "Open";
      case resolved:
        return "Resolved";
      case closed:
        return "Closed";
      case preparing:
        return "Preparing";
      case delivered:
        return "Delivered";
      case skipped:
        return "Skipped";
      case waiting:
        return "Waiting";
      case approved:
        return "Approved";
      case rejected:
        return "Rejected";
      case paid:
        return "Paid";
      case paymentPending:
        return "Payment Pending";
      case paymentReceived:
        return "Payment Received";
      case paymentFailed:
        return "Payment Failed";
      case paymentRefunded:
        return "Payment Refunded";
      default:
        return "Unknown";
    }
  }

  static Widget statusWidget(int? status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: getStatusColor(status).withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: getStatusColor(status)),
      ),
      child: Text(
        getStatus(status),
        style: TextStyle(
          color: getStatusColor(status),
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  static Color getStatusColor(int? status) {
    switch (status) {
      case pending:
        return Colors.orange;

      case active:
      case approved:
      case paymentReceived:
      case delivered:
      case paid:
        return Colors.green;

      case paused:
        return Colors.deepOrange;

      case completed:
      case resolved:
        return Colors.teal;

      case cancelled:
      case rejected:
      case paymentFailed:
        return Colors.red;

      case transferred:
        return Colors.indigo;

      case open:
        return Colors.blue;

      case closed:
        return Colors.grey;

      case preparing:
        return Colors.amber;

      case skipped:
        return Colors.brown;

      case waiting:
      case paymentPending:
        return Colors.orangeAccent;

      case paymentRefunded:
        return Colors.purple;

      default:
        return Colors.black54;
    }
  }
}
