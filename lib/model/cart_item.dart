import 'product.dart';
import 'discounted_product.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({
    required this.product,
    this.quantity = 1,
  });

  double getCartItemPrice() {
    if (product is DiscountedProduct) {
      return (product as DiscountedProduct).getDiscountedPrice() * quantity;
    } else {
      return product.price * quantity;
    }
  }

  double getTotalCartPrice() {
    return getCartItemPrice();
  }
}
