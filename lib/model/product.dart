class Product {
  final int id;
  final String name;
  final double price;
  final int stock;
  final String? description;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.stock,
    this.description,
  });

  String getStockStatus() {
    if (stock > 0) {
      return 'In Stock';
    } else {
      return 'Out of Stock';
    }
  }
}
