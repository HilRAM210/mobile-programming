import 'package:flutter/material.dart';
import '../models/product.dart';
import '../models/favorite_item.dart';
import 'category_badge.dart';

class ProductCard extends StatefulWidget {
  final Product product;
  final VoidCallback? onTap;
  final List<FavoriteItem> favorites;

  const ProductCard({
    super.key,
    required this.product,
    required this.favorites,
    this.onTap,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  late bool _isLiked;

  @override
  void initState() {
    super.initState();
    // cek apakah produk ini sudah ada di daftar favorit
    _isLiked = widget.favorites.any((f) => f.product.id == widget.product.id);
  }

  void _toggleLike() {
    setState(() {
      if (_isLiked) {
        widget.favorites.removeWhere((f) => f.product.id == widget.product.id);
      } else {
        widget.favorites.add(FavoriteItem(product: widget.product));
      }
      _isLiked = !_isLiked;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isOutOfStock = widget.product.stock == 0;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: widget.onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Gambar produk + tombol like
            Stack(
              children: [
                SizedBox(
                  height: 130,
                  width: double.infinity,
                  child: widget.product.imageUrl != null
                      ? Image.network(
                          widget.product.imageUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _placeholder(),
                        )
                      : _placeholder(),
                ),
                // Tombol like di sudut kanan atas
                Positioned(
                  top: 4,
                  right: 4,
                  child: GestureDetector(
                    onTap: _toggleLike,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.85),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _isLiked ? Icons.favorite : Icons.favorite_border,
                        size: 18,
                        color: _isLiked ? Colors.red : Colors.grey,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Info produk
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Badge kategori
                  CategoryBadge(category: widget.product.category),
                  const SizedBox(height: 6),

                  // Nama produk
                  Text(
                    widget.product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),

                  // Harga
                  Text(
                    'Rp ${widget.product.price.toStringAsFixed(0).replaceAllMapped(
                          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                          (m) => '${m[1]}.',
                        )}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Status stok
                  Text(
                    widget.product.getStockStatus(),
                    style: TextStyle(
                      fontSize: 11,
                      color: isOutOfStock ? Colors.red : Colors.green,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      color: Colors.grey[200],
      child: const Icon(Icons.image_outlined, size: 48, color: Colors.grey),
    );
  }
}
