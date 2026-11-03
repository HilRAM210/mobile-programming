// Unit test parsing JSON REST API (Fake Store API) ke model Product
// (Product.fromJson) dan sebaliknya (Product.toJson).

import 'package:flutter_test/flutter_test.dart';

import 'package:tokokamu/models/category.dart';
import 'package:tokokamu/models/product.dart';

void main() {
  // Contoh potongan response nyata dari https://fakestoreapi.com/products/1
  final Map<String, dynamic> fakeStoreJson = {
    'id': 1,
    'title': 'Fjallraven Foldsack No. 1 Backpack, Fits 15 Laptops',
    'price': 109.95,
    'description': 'Your perfect pack for everyday use.',
    'category': "men's clothing",
    'image': 'https://fakestoreapi.com/img/81fPKd-2AYL._AC_SL1500_.jpg',
  };

  group('Product.fromJson', () {
    test('memetakan field Fake Store API ke properti Product', () {
      final product = Product.fromJson(fakeStoreJson);

      expect(product.id, '1'); // id numerik API diubah menjadi String
      expect(
        product.name,
        'Fjallraven Foldsack No. 1 Backpack, Fits 15 Laptops',
      ); // 'title' → name
      expect(product.price, 109.95); // num → double
      expect(product.description, 'Your perfect pack for everyday use.');
      expect(
        product.imageUrl,
        'https://fakestoreapi.com/img/81fPKd-2AYL._AC_SL1500_.jpg',
      ); // 'image' → imageUrl
      expect(product.category.name, "men's clothing"); // teks → Category
    });

    test('field stok yang tidak tersedia di API memakai nilai default', () {
      final product = Product.fromJson(fakeStoreJson);

      expect(product.stock, 10);
    });

    test('field stok dari JSON tetap dipakai bila tersedia', () {
      final product = Product.fromJson({...fakeStoreJson, 'stock': 7});

      expect(product.stock, 7);
    });
  });

  group('Product.toJson', () {
    test('menghasilkan map JSON yang bisa dibaca kembali oleh fromJson', () {
      final product = Product(
        id: 'p1',
        name: 'Kumbang Badak',
        price: 24999,
        stock: 5,
        category: Category(id: 'c1', name: 'Serangga'),
        description: 'Kumbang badak bercula satu.',
        imageUrl: 'https://contoh.com/gambar.png',
      );

      final result = Product.fromJson(product.toJson());

      expect(result.id, product.id);
      expect(result.name, product.name);
      expect(result.price, product.price);
      expect(result.stock, product.stock);
      expect(result.category.name, product.category.name);
      expect(result.description, product.description);
      expect(result.imageUrl, product.imageUrl);
    });
  });
}
