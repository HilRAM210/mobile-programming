import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/cart_controller.dart';
import '../utils/toast.dart';
import '../widgets/price_label.dart';
import 'main_page.dart';

/// Halaman Checkout sederhana: menampilkan ringkasan pesanan
/// dari CartController. Halaman Keranjang diganti (Get.off) halaman
/// ini, sehingga pengguna tidak bisa kembali ke halaman checkout.
class CheckoutPage extends StatelessWidget {
  const CheckoutPage({super.key});

  CartController get cartController => Get.find<CartController>();

  void _finishOrder() {
    // Pesanan selesai: keranjang dikosongkan lalu kembali ke halaman
    // utama dengan Get.off() — halaman checkout tidak bisa dibuka lagi.
    cartController.clearCart();
    Get.off(() => const MainPage());

    showToast('Pesanan berhasil dibuat. Terima kasih!');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('Checkout', style: theme.textTheme.titleMedium),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Obx(() {
        final items = cartController.cartItems;

        return Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(12),
                children: [
                  // ── Ringkasan pesanan ──────────────────────────────────
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Ringkasan Pesanan',
                            style: theme.textTheme.titleSmall),
                        const SizedBox(height: 12),
                        for (final item in items)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    '${item.product.name} (x${item.quantity})',
                                    style: theme.textTheme.bodyMedium,
                                  ),
                                ),
                                Text(
                                  PriceLabel.formatRupiah(
                                    item.getCartItemPrice(),
                                  ),
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // ── Info pengiriman (dummy) ────────────────────────────
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Alamat Pengiriman',
                            style: theme.textTheme.titleSmall),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.location_on_outlined,
                                size: 18, color: Colors.grey),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Jl. Jalan-jalan No. 123, Kota Contoh, Provinsi Contoh',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: Colors.grey[700],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.payment_outlined,
                                size: 18, color: Colors.grey),
                            const SizedBox(width: 8),
                            Text(
                              'Transfer Bank / COD',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ── Total pembayaran ─────────────────────────────────────────
            Container(
              color: Colors.white,
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Pembayaran (${cartController.totalItem} item)',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[700],
                        ),
                      ),
                      Text(
                        PriceLabel.formatRupiah(cartController.totalHarga),
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  FilledButton.icon(
                    onPressed: items.isEmpty ? null : _finishOrder,
                    icon: const Icon(Icons.check_circle_outline, size: 18),
                    label: const Text('Buat Pesanan'),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton(
                    // Get.off() juga dipakai untuk batal: pengguna tidak
                    // bisa kembali ke halaman checkout.
                    onPressed: () => Get.off(() => const MainPage()),
                    child: const Text('Batalkan Pesanan'),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
