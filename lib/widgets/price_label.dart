import 'package:flutter/material.dart';

/// Widget custom: label harga format Rupiah sederhana.
///
/// Contoh: 24999 -> "Rp 24.999"
class PriceLabel extends StatelessWidget {
  final double price;

  const PriceLabel({super.key, required this.price});

  static String formatRupiah(double price) {
    final rounded = price.toStringAsFixed(0);
    final formatted = rounded.replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]}.',
    );
    return 'Rp $formatted';
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      formatRupiah(price),
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}
