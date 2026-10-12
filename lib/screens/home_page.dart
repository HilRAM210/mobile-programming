import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/cart_controller.dart';
import '../data/seeders/product_seeder.dart';
import '../data/seeders/favorite_item_seeder.dart';
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

  void _navigateToDetail(int index) {
    final product = dummyProducts[index];

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
