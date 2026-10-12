import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import 'package:tokokamu/controllers/cart_controller.dart';
import 'package:tokokamu/models/category.dart';
import 'package:tokokamu/models/discounted_product.dart';
import 'package:tokokamu/models/product.dart';

void main() {
  late CartController controller;

  final category = Category(id: 'c1', name: 'Serangga');
  final product = Product(
    id: 'p1',
    name: 'Kumbang Badak',
    price: 24999,
    stock: 5,
    category: category,
  );
  final discounted = DiscountedProduct(
    id: 'p2',
    name: 'Kalajengking',
    price: 100000,
    stock: 3,
    category: category,
    discountPercentage: 10,
  );

  setUp(() {
    Get.reset();
    controller = Get.put(CartController());
  });

  test('addToCart menambahkan item baru ke keranjang', () {
    controller.addToCart(product, quantity: 2);

    expect(controller.cartItems.length, 1);
    expect(controller.cartItems.first.quantity, 2);
    expect(controller.totalItem, 2);
    expect(controller.totalHarga, 24999 * 2);
  });

  test('addToCart untuk produk yang sama menaikkan quantity', () {
    controller.addToCart(product, quantity: 2);
    controller.addToCart(product, quantity: 1);

    expect(controller.cartItems.length, 1);
    expect(controller.cartItems.first.quantity, 3);
  });

  test('quantity tidak melebihi stok tersedia', () {
    controller.addToCart(product, quantity: 5);
    controller.addToCart(product, quantity: 3);

    expect(controller.cartItems.first.quantity, 5);
  });

  test('totalHarga memperhitungkan harga diskon', () {
    controller.addToCart(discounted, quantity: 2);

    // Diskon 10%: (100000 - 10000) * 2 = 180000
    expect(controller.totalHarga, 180000);
  });

  test('incrementQuantity & decrementQuantity dengan batasan', () {
    controller.addToCart(product, quantity: 1);
    final item = controller.cartItems.first;

    controller.decrementQuantity(item);
    expect(item.quantity, 1); // tidak bisa kurang dari 1

    controller.incrementQuantity(item);
    expect(item.quantity, 2);

    for (var i = 0; i < 10; i++) {
      controller.incrementQuantity(item);
    }
    expect(item.quantity, 5); // dibatasi stok
  });

  test('removeFromCart menghapus item', () {
    controller.addToCart(product);
    controller.addToCart(discounted);
    controller.removeFromCart(controller.cartItems.first);

    expect(controller.cartItems.length, 1);
    expect(controller.cartItems.first.product.id, 'p2');
  });

  test('clearCart mengosongkan keranjang', () {
    controller.addToCart(product);
    controller.addToCart(discounted);
    controller.clearCart();

    expect(controller.cartItems, isEmpty);
    expect(controller.totalItem, 0);
    expect(controller.totalHarga, 0);
  });
}
