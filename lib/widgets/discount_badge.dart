import 'package:flutter/material.dart';

class DiscountBadge extends StatelessWidget {
  final double discountPercentage;

  const DiscountBadge({
    super.key,
    required this.discountPercentage,
  });

  String get label {
    final v = discountPercentage;
    final text = v % 1 == 0 ? v.toStringAsFixed(0) : v.toString();
    return 'Diskon $text%';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}
