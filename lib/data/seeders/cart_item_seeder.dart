import '../../models/cart_item.dart';
import 'product_seeder.dart';

final List<CartItem> dummyCartItems = [
  CartItem(
    product: dummyProducts[0],
    quantity: 2,
  ),
  CartItem(
    product: dummyProducts[6],
    quantity: 1,
  ),
  CartItem(
    product: dummyProducts[7],
    quantity: 3,
  ),
];