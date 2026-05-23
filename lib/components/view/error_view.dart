import 'package:flutter/material.dart';
import '../AppText.dart';

class ErrorView extends StatelessWidget {
  const ErrorView({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 64,
            color: Color(0xFF898989),
          ),
          const SizedBox(height: 16),
          AppText(
            text: title,
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Color(0xFF898989),
          ),
        ],
      ),
    );
  }
}
