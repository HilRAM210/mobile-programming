import 'package:flutter/material.dart';
import '../data/seeders/favorite_item_seeder.dart';
import '../widgets/product_card.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  Future<void> _navigateToDetail(int index) async {
    final product = dummyFavoriteItems[index].product;

    final result = await Navigator.pushNamed(
      context,
      '/detail',
      arguments: product,
    );

    if (!mounted) return;
    if (result != null && result is int) {
      final messenger = ScaffoldMessenger.of(context);
      final primaryColor = Theme.of(context).colorScheme.primary;
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            '${product.name} (x$result) ditambahkan ke keranjang!',
          ),
          backgroundColor: primaryColor,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('Favorit', style: theme.textTheme.titleMedium),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: dummyFavoriteItems.isEmpty
          ? _buildEmpty(theme)
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                  child: Row(
                    children: [
                      Text(
                        '${dummyFavoriteItems.length} produk favorit',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: dummyFavoriteItems.length,
                    itemBuilder: (context, index) {
                      final product = dummyFavoriteItems[index].product;
                      return ProductCard(
                        product: product,
                        favorites: dummyFavoriteItems,
                        onTap: () => _navigateToDetail(index),
                        onFavoriteChanged: () => setState(() {}),
                      );
                    },
                  ),
                ),
              ],
            ),
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
