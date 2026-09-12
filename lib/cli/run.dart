// file ini hanya sementara saja untuk melakukan test di console sebelum melakukan implementasi di widget flutter

import '../model/product.dart';
import '../model/discounted_product.dart';
import '../model/cart_item.dart';
import '../data/seeder.dart';

void main() {
  print('Available Products:');
  for (final p in dummyProducts) {
    print('${p.id}. ${p.name} - Rp${p.price} (${p.getStockStatus()})');

    if (p is DiscountedProduct) {
      print('   Discount: ${p.discountPercentage}%');
      print('   Discounted Price: Rp${p.getDiscountedPrice()}');
    }
  }

  print('\nCart Items:');
  for (final item in dummyCartItems) {
    print('${item.product.name} x${item.quantity} - Total: Rp${item.getCartItemPrice()}');
  }

  print('\nTotal Cart Price: Rp${dummyCartItems.fold(0.0, (sum, item) => sum + item.getCartItemPrice())}');
}