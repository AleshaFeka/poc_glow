import 'package:flutter/material.dart';

extension SnackBarManager<T extends StatefulWidget> on State<T> {
  ScaffoldFeatureController showEventReceivedSnackBar({
    required String message,
    Duration duration = const Duration(seconds: 1),
    bool isHighlighted = false,
  }) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: isHighlighted ? const TextStyle(color: Colors.deepOrange) : null,
        ),
        duration: const Duration(milliseconds: 1000),
      ),
    );
  }
}
