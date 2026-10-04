import 'package:flutter/material.dart';
import 'screens/main_page.dart';
import 'screens/product_detail_page.dart';
import 'models/product.dart';
import 'utils/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TokoKamu',
      theme: AppTheme.light,

      home: const MainPage(),

      routes: {
        '/detail': (context) {
          final product =
              ModalRoute.of(context)!.settings.arguments as Product;
          return ProductDetailPage(product: product);
        },
      },
    );
  }
}
