import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/cart_controller.dart';
import '../controllers/favorite_controller.dart';
import '../models/product.dart';
import '../services/product_service.dart';
import '../utils/toast.dart';
import '../models/discounted_product.dart';
import '../widgets/category_badge.dart';
import '../widgets/discount_badge.dart';
import '../widgets/favorite_button.dart';
import '../widgets/price_label.dart';
import '../widgets/stock_badge.dart';

class ProductDetailPage extends StatefulWidget {
  final Product product;

  const ProductDetailPage({super.key, required this.product});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  // Instance yang sama dengan yang terdaftar di MainPage (Get.put).
  final CartController cartController = Get.find<CartController>();
  final FavoriteController favoriteController = Get.find<FavoriteController>();

  int _quantity = 1;

  /// Future yang menampung hasil pengambilan detail produk dari REST API
  /// sebagai alternatif data yang dikirim lewat navigasi.
  late final Future<Product> _detailFuture;

  @override
  void initState() {
    super.initState();
    // Ambil detail produk terbaru dari API berdasarkan ID-nya. Bila ID
    // bukan angka (data dummy lama) atau request gagal, data navigasi
    // (widget.product) tetap dipakai sebagai fallback.
    final id = int.tryParse(widget.product.id);
    _detailFuture = id == null
        ? Future.value(widget.product)
        : ProductService.fetchProductDetail(id);
  }

  bool _hasDiscount(Product product) {
    if (product is! DiscountedProduct) return false;
    return product.discountPercentage > 0;
  }

  double _effectivePrice(Product product) {
    if (product is DiscountedProduct && product.discountPercentage > 0) {
      return product.getDiscountedPrice();
    }
    return product.price;
  }

  bool _isOutOfStock(Product product) => product.stock == 0;

  void _decrement() {
    if (_quantity > 1) setState(() => _quantity--);
  }

  void _increment(Product product) {
    if (_quantity < product.stock) setState(() => _quantity++);
  }

  void _addToCart(Product product) {
    // State keranjang dikelola GetX — tidak ada setState di sini.
    // Cukup panggil method controller, badge di HomePage ikut berubah.
    cartController.addToCart(product, quantity: _quantity);

    showToast('${product.name} (x$_quantity) ditambahkan ke keranjang!');

    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    // Data navigasi (widget.product) tampil lebih dulu lewat initialData,
    // lalu diganti oleh data terbaru dari API bila request-nya berhasil.
    return FutureBuilder<Product>(
      future: _detailFuture,
      initialData: widget.product,
      builder: (context, snapshot) {
        final product = snapshot.data ?? widget.product;
        return _buildPage(context, product);
      },
    );
  }

  Widget _buildPage(BuildContext context, Product product) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Detail Produk',
          style: theme.textTheme.titleMedium,
        ),
        centerTitle: true,
        actions: [
          FavoriteButton(
            product: product,
            favorites: favoriteController.favorites,
            size: 22,
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Gambar produk ──────────────────────────────────────────────
            Stack(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 280,
                  child: product.imageUrl != null
                      ? Image.network(
                          product.imageUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => _imagePlaceholder(),
                        )
                      : _imagePlaceholder(),
                ),
                if (_hasDiscount(product))
                  Positioned(
                    top: 12,
                    right: 12,
                    child: DiscountBadge(
                      discountPercentage:
                          (product as DiscountedProduct).discountPercentage,
                    ),
                  ),
                Positioned(
                  bottom: 12,
                  left: 12,
                  child: StockBadge(stock: product.stock),
                ),
              ],
            ),

            // ── Info produk ────────────────────────────────────────────────
            Container(
              color: Colors.white,
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CategoryBadge(category: product.category),
                  const SizedBox(height: 8),
                  Text(
                    product.name,
                    style: theme.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 10),

                  // Harga
                  if (_hasDiscount(product)) ...[
                    Text(
                      PriceLabel.formatRupiah(product.price),
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[500],
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                    const SizedBox(height: 2),
                  ],
                  PriceLabel(price: _effectivePrice(product)),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // ── Deskripsi ──────────────────────────────────────────────────
            Container(
              color: Colors.white,
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Deskripsi', style: theme.textTheme.titleSmall),
                  const SizedBox(height: 8),
                  Text(
                    product.description?.isNotEmpty == true
                        ? product.description!
                        : 'Tidak ada deskripsi.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[700],
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // ── Info stok ──────────────────────────────────────────────────
            Container(
              color: Colors.white,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  const Icon(Icons.inventory_2_outlined, size: 18, color: Colors.grey),
                  const SizedBox(width: 8),
                  Text(
                    'Stok tersedia: ',
                    style: theme.textTheme.bodyMedium,
                  ),
                  Text(
                    '${product.stock} unit',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 80), // padding bawah untuk floating bar
          ],
        ),
      ),

      // ── Quantity + tombol Add to Cart ─────────────────────────────────
      bottomNavigationBar: Container(
        color: Colors.white,
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        child: Row(
          children: [
            // Quantity control
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  _QuantityButton(
                    icon: Icons.remove,
                    onTap: _isOutOfStock(product) ? null : _decrement,
                    enabled: _quantity > 1 && !_isOutOfStock(product),
                  ),
                  SizedBox(
                    width: 40,
                    child: Text(
                      '$_quantity',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.titleSmall,
                    ),
                  ),
                  _QuantityButton(
                    icon: Icons.add,
                    onTap: _isOutOfStock(product)
                        ? null
                        : () => _increment(product),
                    enabled: _quantity < product.stock && !_isOutOfStock(product),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),

            // Add to Cart button
            Expanded(
              child: FilledButton.icon(
                onPressed: _isOutOfStock(product) ? null : () => _addToCart(product),
                icon: const Icon(Icons.shopping_cart_outlined, size: 18),
                label: Text(
                  _isOutOfStock(product) ? 'Stok Habis' : 'Tambah ke Keranjang',
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: Colors.white,
                  ),
                ),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _imagePlaceholder() {
    return Container(
      color: Colors.grey[200],
      child: const Center(
        child: Icon(Icons.image_outlined, size: 64, color: Colors.grey),
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
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Icon(
          icon,
          size: 18,
          color: enabled
              ? Theme.of(context).colorScheme.primary
              : Colors.grey[400],
        ),
      ),
    );
  }
}
