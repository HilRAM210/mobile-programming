// file ini hanya sementara saja untuk melakukan test di console sebelum melakukan implementasi di widget flutter
import '../models/discounted_product.dart';
import '../data/seeders/product_seeder.dart';
import '../data/seeders/cart_item_seeder.dart';
import '../data/seeders/favorite_item_seeder.dart';

void productList() {
  print('Daftar Produk:');
  for (var product in dummyProducts) {
    print(
      'ID: ${product.id}, Nama: ${product.name}, Harga: ${product.price}, Stok: ${product.stock}, Kategori: ${product.category.name}'
    );
    print('Deskripsi: ${product.description}');
  }

  for (var product in dummyProducts) {
    if (product is DiscountedProduct) {
      print(
        'ID: ${product.id}, Nama: ${product.name}, Harga Asli: ${product.price}, Harga Diskon: ${product.getDiscountedPrice()}, Stok: ${product.stock}, Kategori: ${product.category.name}, Diskon: ${product.discountPercentage}%'
      );
      print('Deskripsi: ${product.description}');
    }
  }
}

void cartItemList() {
  double totalPrice = 0;
  print('Daftar Item di Keranjang:');
  for (var cartItem in dummyCartItems) {
    print(
      'Produk: ${cartItem.product.name}, Jumlah: ${cartItem.quantity}, Harga Total: ${cartItem.product.price * cartItem.quantity}'
    );
  }

  print('Total Harga Keranjang:');
  for (var cartItem in dummyCartItems) {
    totalPrice += cartItem.product.price * cartItem.quantity;
  }
  print('Rp$totalPrice');
}

void favoriteItemList() {
  print('Daftar Item Favorit:');
  for (var favoriteItem in dummyFavoriteItems) {
    print(
      'Produk: ${favoriteItem.product.name}, Harga: ${favoriteItem.product.price}'
    );
  }
}

void main() {
  productList();
  print('\n');
  cartItemList();
  print('\n');
  favoriteItemList();
}
