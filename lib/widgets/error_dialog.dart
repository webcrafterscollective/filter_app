import 'package:flutter/material.dart';

class ErrorDialog extends StatelessWidget {
  final String error;
  final bool isJsonError;

  const ErrorDialog({
    super.key,
    required this.error,
    this.isJsonError = false,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.error_outline, color: Colors.red.shade600),
          const SizedBox(width: 8),
          Text(isJsonError ? 'Error Loading JSON File' : 'Error Loading Excel File'),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Error: $error'),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Troubleshooting:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  isJsonError
                      ? '• Ensure JSON file is properly formatted\n'
                      '• Place JSON file in assets/ folder\n'
                      '• Check pubspec.yaml includes assets\n'
                      '• Run "flutter pub get"\n'
                      '• Verify JSON structure matches expected format'
                      : '• Ensure Excel file is named "products.xlsx"\n'
                      '• Place file in assets/ folder\n'
                      '• Check pubspec.yaml includes assets\n'
                      '• Run "flutter pub get"',
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('OK'),
        ),
      ],
    );
  }
}