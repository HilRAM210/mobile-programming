import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/cart_controller.dart';
import '../models/cart_item.dart';
import '../models/discounted_product.dart';
import '../utils/toast.dart';
import '../widgets/price_label.dart';
import 'checkout_page.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  // Lookup dilakukan secara lazy saat dipakai, sehingga aman meskipun
  // widget ini dibuat sebelum Get.put(CartController()) dijalankan.
  CartController get cartController => Get.find<CartController>();

  void _confirmClearCart() {
    Get.dialog(
      AlertDialog(
        title: const Text('Kosongkan Keranjang?'),
        content: const Text(
          'Seluruh item di keranjang akan dihapus. Tindakan ini tidak bisa dibatalkan.',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () {
              cartController.clearCart();
              Get.back();
              showToast(
                'Keranjang dikosongkan',
                icon: Icons.delete_sweep_outlined,
              );
            },
            child: const Text('Kosongkan'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Keranjang',
          style: theme.textTheme.titleMedium,
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          Obx(
            () => cartController.isEmpty
                ? const SizedBox.shrink()
                : TextButton.icon(
                    onPressed: _confirmClearCart,
                    icon: const Icon(Icons.delete_sweep_outlined, size: 20),
                    label: const Text('Kosongkan'),
                  ),
          ),
        ],
      ),
      backgroundColor: Colors.grey[100],

      // Obx membangun ulang seluruh isi halaman setiap cartItems berubah.
      body: Obx(() {
        if (cartController.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.shopping_cart_outlined,
                  size: 72,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'Keranjang Belanja',
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  'Belum ada produk di keranjang.\nYuk mulai belanja!',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
                itemCount: cartController.cartItems.length,
                itemBuilder: (context, index) {
                  final item = cartController.cartItems[index];
                  return _CartItemCard(
                    item: item,
                    controller: cartController,
                  );
                },
              ),
            ),

            // ── Total harga + tombol Checkout ────────────────────────────
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
                        'Total (${cartController.totalItem} item)',
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
                    // Get.off(): halaman keranjang diganti halaman Checkout,
                    // sehingga tidak bisa kembali dengan tombol back.
                    onPressed: () => Get.off(() => const CheckoutPage()),
                    icon: const Icon(Icons.payment_outlined, size: 18),
                    label: const Text('Checkout'),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
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

// ── Kartu item keranjang (quantity bisa diubah, bisa dihapus) ─────────────────
class _CartItemCard extends StatelessWidget {
  final CartItem item;
  final CartController controller;

  const _CartItemCard({required this.item, required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final product = item.product;
    final discounted = product is DiscountedProduct ? product : null;
    final unitPrice = discounted?.getDiscountedPrice() ?? product.price;

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Info produk
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: theme.textTheme.titleSmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  if (discounted != null) ...[
                    Text(
                      PriceLabel.formatRupiah(product.price),
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[500],
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  ],
                  Text(
                    '${PriceLabel.formatRupiah(unitPrice)} / unit',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Quantity control (Tugas Mandiri 1)
                  Row(
                    children: [
                      _QuantityButton(
                        icon: Icons.remove,
                        enabled: item.quantity > 1,
                        onTap: () => controller.decrementQuantity(item),
                      ),
                      SizedBox(
                        width: 36,
                        child: Text(
                          '${item.quantity}',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.titleSmall,
                        ),
                      ),
                      _QuantityButton(
                        icon: Icons.add,
                        enabled: item.quantity < product.stock,
                        onTap: () => controller.incrementQuantity(item),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Subtotal + tombol hapus
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () => controller.removeFromCart(item),
                  icon: const Icon(Icons.delete_outline, size: 20),
                  color: Colors.grey[500],
                  tooltip: 'Hapus item',
                ),
                Text(
                  PriceLabel.formatRupiah(item.getCartItemPrice()),
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── Helper widget tombol quantity ─────────────────────────────────────────────
class _QuantityButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final bool enabled;

  const _QuantityButton({
    required this.icon,
    required this.onTap,
    required this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          border: Border.all(
            color: enabled ? Colors.grey[300]! : Colors.grey[200]!,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          size: 16,
          color: enabled
              ? Theme.of(context).colorScheme.primary
              : Colors.grey[400],
        ),
      ),
    );
  }
}
