import 'package:get/get.dart';

import '../models/favorite_item.dart';

/// Controller GetX yang mengelola daftar produk favorit (wishlist)
/// TokoKamu secara terpusat, sehingga bisa diakses dari halaman mana pun
/// melalui Get.find().
///
/// Daftar ini menggantikan data dummy `dummyFavoriteItems` yang dulu
/// disimpan pada berkas seeder.
class FavoriteController extends GetxController {
  /// Daftar produk favorit dalam bentuk reaktif (RxList).
  ///
  /// Diubah langsung oleh FavoriteButton (tambah/hapus), lalu
  /// perubahan-nya otomatis membangun ulang halaman Favorit lewat Obx.
  final RxList<FavoriteItem> favorites = <FavoriteItem>[].obs;

  /// Apakah sebuah produk sudah ada di daftar favorit.
  bool isFavorite(String productId) =>
      favorites.any((item) => item.product.id == productId);

  /// Menambahkan produk ke daftar favorit (diabaikan bila sudah ada).
  void addFavorite(FavoriteItem item) {
    if (!isFavorite(item.product.id)) {
      favorites.add(item);
    }
  }

  /// Menghapus produk dari daftar favorit berdasarkan ID-nya.
  void removeFavorite(String productId) {
    favorites.removeWhere((item) => item.product.id == productId);
  }
}
