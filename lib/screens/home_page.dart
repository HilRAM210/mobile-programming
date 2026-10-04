import 'package:flutter/material.dart';
import '../data/seeders/product_seeder.dart';
import '../data/seeders/favorite_item_seeder.dart';
import '../widgets/product_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<void> _navigateToDetail(int index) async {
    final product = dummyProducts[index];

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
        title: Text('Beranda', style: theme.textTheme.titleMedium),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Text(
              'Daftar Produk (${dummyProducts.length})',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: dummyProducts.length,
              itemBuilder: (context, index) {
                final product = dummyProducts[index];
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
}
