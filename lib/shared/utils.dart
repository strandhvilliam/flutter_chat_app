import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension ShowSnackBar on BuildContext {
  void showSnackBar({
    required String message,
    Color backgroundColor = Colors.blue,
  }) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
      ),
    );
  }

  void showErrorSnackBar({required String message}) {
    showSnackBar(message: message, backgroundColor: Colors.red);
  }
}

String formatTimeStamp(DateTime timestamp) {
  if (timestamp.day == DateTime.now().day) {
    return DateFormat('HH:mm').format(timestamp);
  } else if (timestamp.day == DateTime.now().day - 1) {
    return 'Yesterday ${DateFormat('HH:mm').format(timestamp)}';
  } else {
    return DateFormat('dd/MM/yyyy').format(timestamp);
  }
}
