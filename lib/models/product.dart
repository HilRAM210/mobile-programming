import 'category.dart';

class Product {
  final String id;
  final String name;
  final double price;
  final int stock;
  final Category category;
  final String? description;
  final String? imageUrl;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.stock,
    required this.category,
    this.description,
    this.imageUrl,
  });

  String getStockStatus() {
    if (stock > 0) {
      return 'In Stock';
    } else {
      return 'Out of Stock';
    }
  }
}
