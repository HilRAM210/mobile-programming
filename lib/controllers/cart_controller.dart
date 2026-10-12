import 'package:get/get.dart';

import '../models/cart_item.dart';
import '../models/product.dart';

/// Controller GetX yang mengelola state keranjang belanja TokoKamu
/// secara terpusat, sehingga bisa diakses dari halaman mana pun
/// melalui Get.find().
class CartController extends GetxController {
  /// Daftar item keranjang dalam bentuk reaktif (RxList).
  final RxList<CartItem> cartItems = <CartItem>[].obs;

  /// Total jumlah unit dari semua item di keranjang (reaktif).
  int get totalItem => cartItems.fold(0, (sum, item) => sum + item.quantity);

  /// Total harga seluruh isi keranjang (reaktif, sudah memperhitungkan diskon).
  double get totalHarga =>
      cartItems.fold(0.0, (sum, item) => sum + item.getCartItemPrice());

  /// Apakah keranjang kosong (reaktif).
  bool get isEmpty => cartItems.isEmpty;

  /// Menambahkan produk ke keranjang. Jika produk sudah ada,
  /// quantity-nya ditambahkan (dibatasi stok tersedia).
  void addToCart(Product product, {int quantity = 1}) {
    final index =
        cartItems.indexWhere((item) => item.product.id == product.id);

    if (index >= 0) {
      final item = cartItems[index];
      final newQuantity = (item.quantity + quantity).clamp(1, product.stock);
      item.quantity = newQuantity;
      cartItems.refresh();
    } else {
      cartItems.add(
        CartItem(product: product, quantity: quantity.clamp(1, product.stock)),
      );
    }
  }

  /// Menghapus satu item keranjang.
  void removeFromCart(CartItem item) {
    cartItems.remove(item);
  }

  /// Menambah quantity satu item (dibatasi stok tersedia).
  void incrementQuantity(CartItem item) {
    if (item.quantity < item.product.stock) {
      item.quantity++;
      cartItems.refresh();
    }
  }

  /// Mengurangi quantity satu item (minimal 1).
  void decrementQuantity(CartItem item) {
    if (item.quantity > 1) {
      item.quantity--;
      cartItems.refresh();
    }
  }

  /// Mengosongkan seluruh isi keranjang.
  void clearCart() {
    cartItems.clear();
  }
}
