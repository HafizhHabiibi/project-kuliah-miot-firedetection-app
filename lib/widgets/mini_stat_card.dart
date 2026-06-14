import 'package:flutter/material.dart';

class MiniStatCard extends StatelessWidget {
  final String label;
  final String value;
  final String statusText;
  final Color statusColor;

  const MiniStatCard({
    super.key,
    required this.label,
    required this.value,
    required this.statusText,
    required this.statusColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E38),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: const TextStyle(
              fontSize: 10,
              color: Color(0xFF8888AA),
              letterSpacing: 0.6,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            statusText,
            style: TextStyle(fontSize: 10, color: statusColor),
          ),
        ],
      ),
    );
  }
}