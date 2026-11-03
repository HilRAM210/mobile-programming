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

  /// Membuat objek [Product] dari map JSON — baik response REST API
  /// (misalnya Fake Store API) maupun hasil [toJson] sendiri.
  ///
  /// Penyesuaian struktur JSON API → properti [Product]:
  /// - `id` numerik diubah menjadi [String].
  /// - `title` dipetakan ke `name`.
  /// - `image` dipetakan ke `imageUrl`.
  /// - `category` berupa teks dipetakan menjadi objek [Category].
  /// - `stock` tidak tersedia di API, sehingga dipakai nilai default 10.
  factory Product.fromJson(Map<String, dynamic> json) {
    final category = json['category'];

    return Product(
      id: json['id'].toString(),
      name: (json['title'] ?? json['name'] ?? '') as String,
      price: (json['price'] as num).toDouble(),
      stock: (json['stock'] as num?)?.toInt() ?? 10,
      category: category is Map<String, dynamic>
          ? Category.fromJson(category)
          : Category(
              id: category?.toString() ?? '',
              name: category?.toString() ?? 'Tanpa Kategori',
            ),
      description: json['description'] as String?,
      imageUrl: (json['image'] ?? json['imageUrl']) as String?,
    );
  }

  /// Mengubah objek [Product] menjadi map JSON dengan struktur milik
  /// Fake Store API, misalnya untuk dikirim lewat request POST/PUT.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': name,
      'price': price,
      'stock': stock,
      'category': category.name,
      'description': description,
      'image': imageUrl,
    };
  }

  String getStockStatus() {
    if (stock > 0) {
      return 'In Stock';
    } else {
      return 'Out of Stock';
    }
  }
}
