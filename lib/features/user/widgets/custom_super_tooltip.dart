import 'package:flutter/material.dart';
import 'package:super_tooltip/super_tooltip.dart';

class CustomSuperTooltip extends StatelessWidget {
  final String tooltipText;
  final SuperTooltipController controller;
  final Color iconColor;
  final double iconSize;

  const CustomSuperTooltip({
    super.key,
    required this.tooltipText,
    required this.controller,
    this.iconColor = Colors.blue,
    this.iconSize = 18.0,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await controller.showTooltip();
      },
      child: SuperTooltip(
        showBarrier: true,
        controller: controller,
        backgroundColor: Colors.white,
        arrowTipDistance: 15,
        arrowBaseWidth: 15,
        arrowLength: 15,
        borderRadius: 10,
        shadowBlurRadius: 20,
        shadowSpreadRadius: 0,

        showDropBoxFilter: true,
        sigmaX: 2,
        sigmaY: 2,
        content: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            tooltipText,
            softWrap: true,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
            // textAlign: TextAlign.justify,
          ),
        ),
        child: Icon(
          Icons.info_outline,
          color: iconColor,
          size: iconSize,
        ),
      ),
    );
  }
}
