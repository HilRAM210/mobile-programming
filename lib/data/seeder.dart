import '../model/product.dart';
import '../model/discounted_product.dart';
import '../model/cart_item.dart';

final List<Product> dummyProducts = [
  Product(
    id: 1,
    name: 'Kaos Polos Hitam',
    price: 75000,
    stock: 20,
    description: 'Kaos cotton combed 30s, adem dan nyaman.',
  ),
  Product(
    id: 2,
    name: 'Kemeja Flanel',
    price: 150000,
    stock: 10,
    description: 'Kemeja flanel motif kotak, cocok untuk santai.',
  ),
  Product(
    id: 3,
    name: 'Celana Jeans Slim Fit',
    price: 200000,
    stock: 15,
    description: 'Jeans slim fit stretch, warna dark blue.',
  ),
  Product(
    id: 4,
    name: 'Sepatu Sneakers Putih',
    price: 350000,
    stock: 8,
    description: 'Sneakers casual putih, ringan dan stylish.',
  ),
  Product(
    id: 5,
    name: 'Tas Ransel Laptop',
    price: 275000,
    stock: 0,
    description: 'Ransel waterproof muat laptop 14 inch.',
  ),
  Product(
    id: 6,
    name: 'Topi Baseball',
    price: 60000,
    stock: 0,
    description: 'Topi baseball adjustable, bahan twill premium.',
  ),
  DiscountedProduct(
    id: 7,
    name: 'Jaket Hoodie Fleece',
    price: 225000,
    stock: 12,
    discountPercentage: 20,
    description: 'Hoodie fleece tebal, hangat untuk musim hujan.',
  ),
  DiscountedProduct(
    id: 8,
    name: 'Jam Tangan Analog',
    price: 500000,
    stock: 5,
    discountPercentage: 10,
    description: 'Jam tangan analog strap kulit sintetis.',
  ),
];

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