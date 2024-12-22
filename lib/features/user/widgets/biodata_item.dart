// Reusable Biodata Item Widget
import 'package:baket_mobile/core/themes/_themes.dart';
import 'package:flutter/material.dart';

class BiodataItem extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback? onTap;

  const BiodataItem({
    required this.label,
    required this.value,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Label Section
            Expanded(
              flex: 3,
              child: Text(
                label,
                style: FontTheme.raleway14w500black2(),
              ),
            ),

            // Value Section
            Expanded(
              flex: 5,
              child: Text(
                value,
                style: FontTheme.raleway16w600black(),
              ),
            ),
            // Arrow Icon
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
