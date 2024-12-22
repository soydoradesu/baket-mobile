// lib/features/user/widgets/biodata_item.dart
import 'package:baket_mobile/core/themes/_themes.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class BiodataItem extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onTap;
  final bool isLoading; // New parameter

  const BiodataItem({
    Key? key,
    required this.label,
    required this.value,
    required this.onTap,
    this.isLoading = false, // Default to not loading
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isLoading ? null : onTap, // Disable tap if loading
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            // Label
            SizedBox(
              width: 100, // Fixed width for labels to ensure alignment
              child: Text(
                label,
                style: FontTheme.raleway14w500black2(),
              ),
            ),
            const SizedBox(width: 16),
            // Value or Shimmer with AnimatedSwitcher
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder:
                    (Widget child, Animation<double> animation) {
                  return FadeTransition(opacity: animation, child: child);
                },
                child: isLoading
                    ? Shimmer.fromColors(
                        key: const ValueKey('shimmer'),
                        baseColor: Colors.grey.shade300,
                        highlightColor: Colors.grey.shade100,
                        child: Container(
                          height: 16,
                          width: double.infinity, // Span full width
                          alignment: Alignment.centerLeft, // Enforce left alignment
                          color: Colors.white,
                        ),
                      )
                    : Container(
                        alignment: Alignment.centerLeft, // Enforce left alignment
                        child: Text(
                          value,
                          key: ValueKey<String>(value),
                          style: FontTheme.raleway16w600black(),
                          textAlign: TextAlign.left, // Explicit left alignment
                        ),
                      ),
              ),
            ),
            const SizedBox(width: 16),
            // '>' Icon
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color:
                  isLoading ? Colors.grey.shade400 : Colors.grey.shade600, // Color based on loading state
            ),
          ],
        ),
      ),
    );
  }
}
