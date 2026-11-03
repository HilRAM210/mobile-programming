import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/cart_controller.dart';
import '../controllers/favorite_controller.dart';
import '../models/product.dart';
import '../services/product_service.dart';
import '../widgets/product_card.dart';
import 'product_detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Diambil dari "memori global" GetX — satu instance yang sama
  // dengan yang dipakai di ProductDetailPage dan CartPage.
  late final CartController cartController = Get.find<CartController>();
  late final FavoriteController favoriteController =
      Get.find<FavoriteController>();

  // Future yang menampung hasil pengambilan data produk dari REST API.
  // Disimpan pada state agar bisa dipanggil ulang oleh tombol "Coba Lagi"
  // dan pull-to-refresh.
  late Future<List<Product>> _productsFuture;

  @override
  void initState() {
    super.initState();
    _productsFuture = ProductService.fetchProducts();
  }

  /// Memuat ulang daftar produk dari API.
  Future<void> _refreshProducts() async {
    setState(() {
      _productsFuture = ProductService.fetchProducts();
    });
    // Tunggu selesai agar RefreshIndicator berhenti berputar
    // bersamaan dengan selesainya request.
    await _productsFuture;
  }

  void _navigateToDetail(Product product) {
    // Routing dengan GetX: tanpa Navigator.pushNamed maupun BuildContext.
    Get.to(() => ProductDetailPage(product: product));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('Beranda', style: theme.textTheme.titleMedium),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          // Badge keranjang reaktif: Obx membangun ulang ikon ini
          // setiap totalItem berubah — tanpa setState.
          Obx(
            () => Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Badge(
                isLabelVisible: cartController.totalItem > 0,
                label: Text('${cartController.totalItem}'),
                child: const Icon(Icons.shopping_cart_outlined, size: 22),
              ),
            ),
          ),
        ],
      ),
      body: FutureBuilder<List<Product>>(
        future: _productsFuture,
        builder: (context, snapshot) {
          // ── Loading: data masih dimuat dari API ─────────────────────
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // ── Error: request gagal (misalnya tanpa koneksi) ───────────
          if (snapshot.hasError) {
            return _buildError(theme);
          }

          // ── Data berhasil dimuat ────────────────────────────────────
          final products = snapshot.data ?? [];
          return _buildProductList(theme, products);
        },
      ),
    );
  }

  Widget _buildProductList(ThemeData theme, List<Product> products) {
    return RefreshIndicator(
      onRefresh: _refreshProducts,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Text(
              'Daftar Produk (${products.length})',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              // Selalu bisa di-scroll agar pull-to-refresh tetap jalan
              // meski daftar produk masih sedikit.
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return ProductCard(
                  key: ValueKey(product.id),
                  product: product,
                  favorites: favoriteController.favorites,
                  onTap: () => _navigateToDetail(product),
                  onFavoriteChanged: () => setState(() {}),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildError(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.cloud_off_outlined, size: 72, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'Gagal memuat produk, coba lagi',
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Periksa koneksi internet Anda,\nlalu muat ulang halaman.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: _refreshProducts,
            icon: const Icon(Icons.refresh, size: 18),
            label: const Text('Coba Lagi'),
          ),
        ],
      ),
    );
  }
}
