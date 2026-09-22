import 'package:flutter/material.dart';
import '../models/product.dart';
import '../models/favorite_item.dart';
import 'category_badge.dart';
import 'price_label.dart';
import 'stock_badge.dart';

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
    debugPrint('[ProductCard:${widget.product.id}] initState isLiked=$_isLiked');
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
  void dispose() {
    debugPrint('[ProductCard:${widget.product.id}] dispose');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('[ProductCard:${widget.product.id}] build isLiked=$_isLiked');

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: widget.onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.max,
          children: [
            Stack(
              children: [
                SizedBox(
                  height: 110,
                  width: double.infinity,
                  child: widget.product.imageUrl != null
                      ? Image.network(
                          widget.product.imageUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _placeholder(),
                        )
                      : _placeholder(),
                ),
                Positioned(
                  top: 4,
                  right: 4,
                  child: GestureDetector(
                    onTap: _toggleLike,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.85),
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

            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CategoryBadge(category: widget.product.category),
                    const SizedBox(height: 4),

                    Text(
                      widget.product.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),

                    PriceLabel(price: widget.product.price),
                    const SizedBox(height: 4),

                    StockBadge(stock: widget.product.stock),
                  ],
                ),
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
