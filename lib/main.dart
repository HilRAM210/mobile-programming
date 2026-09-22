import 'package:flutter/material.dart';
import 'widgets/product_card.dart';
import 'data/seeders/product_seeder.dart';
import 'data/seeders/favorite_item_seeder.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TokoKamu',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const ProductListPage(),
    );
  }
}

class ProductListPage extends StatelessWidget {
  const ProductListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TokoKamu'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // 2 kolom
          mainAxisExtent: 310,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: dummyProducts.length,
        itemBuilder: (context, index) {
          return ProductCard(
            product: dummyProducts[index],
            favorites: dummyFavoriteItems,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Dipilih: ${dummyProducts[index].name}')),
              );
            },
          );
        },
      ),
    );
  }
}
