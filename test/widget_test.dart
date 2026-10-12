// Widget test halaman Keranjang: memastikan tampilan reaktif dengan Obx
// terhadap perubahan state CartController.

import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import 'package:tokokamu/controllers/cart_controller.dart';
import 'package:tokokamu/models/category.dart';
import 'package:tokokamu/models/product.dart';
import 'package:tokokamu/screens/cart_page.dart';

void main() {
  setUp(() {
    Get.reset();
    Get.put(CartController());
  });

  tearDown(Get.reset);

  testWidgets('menampilkan empty state saat keranjang kosong',
      (WidgetTester tester) async {
    await tester.pumpWidget(const GetMaterialApp(home: CartPage()));

    expect(find.text('Keranjang Belanja'), findsOneWidget);
    expect(find.text('Belum ada produk di keranjang.\nYuk mulai belanja!'),
        findsOneWidget);
  });

  testWidgets('tampilan berubah otomatis saat item ditambahkan (Obx)',
      (WidgetTester tester) async {
    await tester.pumpWidget(const GetMaterialApp(home: CartPage()));

    final controller = Get.find<CartController>();
    controller.addToCart(
      Product(
        id: 'p1',
        name: 'Kumbang Badak',
        price: 24999,
        stock: 5,
        category: Category(id: 'c1', name: 'Serangga'),
      ),
      quantity: 2,
    );
    await tester.pump();

    // Item muncul tanpa setState pada widget.
    expect(find.text('Kumbang Badak'), findsOneWidget);
    expect(find.text('Total (2 item)'), findsOneWidget);
    expect(find.text('Rp 49.998'), findsNWidgets(2)); // subtotal item + total
    expect(find.text('Checkout'), findsOneWidget);
  });
}
