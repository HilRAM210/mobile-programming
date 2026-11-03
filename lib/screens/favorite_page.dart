import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/favorite_controller.dart';
import '../models/favorite_item.dart';
import '../models/product.dart';
import '../widgets/product_card.dart';
import 'product_detail_page.dart';

/// Halaman daftar produk favorit. Sumber datanya adalah [FavoriteController]
/// (produk hasil fetch dari REST API yang di-favorit-kan pengguna),
/// dan tampilannya reaktif lewat Obx.
class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  void _navigateToDetail(Product product) {
    // Routing dengan GetX — konsisten dengan HomePage.
    Get.to(() => ProductDetailPage(product: product));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final favoriteController = Get.find<FavoriteController>();

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('Favorit', style: theme.textTheme.titleMedium),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      // Obx membangun ulang bagian ini setiap daftar favorit berubah —
      // tanpa setState.
      body: Obx(() {
        final List<FavoriteItem> favorites = favoriteController.favorites;

        return favorites.isEmpty
            ? _buildEmpty(theme)
            : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                    child: Row(
                      children: [
                        Text(
                          '${favorites.length} produk favorit',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: favorites.length,
                      itemBuilder: (context, index) {
                        final product = favorites[index].product;
                        return ProductCard(
                          key: ValueKey(product.id),
                          product: product,
                          favorites: favorites,
                          onTap: () => _navigateToDetail(product),
                        );
                      },
                    ),
                  ),
                ],
              );
      }),
    );
  }

  Widget _buildEmpty(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.favorite_border, size: 72, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text('Belum ada favorit', style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(
            'Tekan ikon hati pada produk\nuntuk menambahkannya ke sini.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
          ),
        ],
      ),
    );
  }
}
