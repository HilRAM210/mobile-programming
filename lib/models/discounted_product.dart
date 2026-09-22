import 'product.dart';

class DiscountedProduct extends Product {
  final double discountPercentage;

  DiscountedProduct({
    required super.id,
    required super.name,
    required super.price,
    required super.stock,
    required super.category,
    this.discountPercentage = 0.0,
    super.description,
    super.imageUrl,
  });

  double getDiscountedPrice() {
    return price - (price * discountPercentage / 100);
  }
}