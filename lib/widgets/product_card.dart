import 'package:flutter/material.dart';
import '../models/product.dart';
import '../models/discounted_product.dart';
import '../models/favorite_item.dart';
import 'category_badge.dart';
import 'discount_badge.dart';
import 'favorite_button.dart';
import 'price_label.dart';
import 'stock_badge.dart';

class ProductCard extends StatefulWidget {
  final Product product;
  final VoidCallback? onTap;
  final List<FavoriteItem> favorites;
  final VoidCallback? onFavoriteChanged;

  const ProductCard({
    super.key,
    required this.product,
    required this.favorites,
    this.onTap,
    this.onFavoriteChanged,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool get _hasDiscount {
    if (widget.product is! DiscountedProduct) return false;
    return (widget.product as DiscountedProduct).discountPercentage > 0;
  }

  @override
  void dispose() {
    debugPrint('[ProductCard:${widget.product.id}] dispose');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('[ProductCard:${widget.product.id}] build');

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            spreadRadius: 1,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: widget.onTap,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  SizedBox(
                    height: 132,
                    width: 112,
                    child: widget.product.imageUrl != null
                        ? Image.network(
                            widget.product.imageUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) => _placeholder(),
                          )
                        : _placeholder(),
                  ),
                  Positioned(
                    top: 6,
                    left: 6,
                    child: FavoriteButton(
                      product: widget.product,
                      favorites: widget.favorites,
                      onChanged: widget.onFavoriteChanged,
                      size: 16,
                      withBackground: true,
                    ),
                  ),
                  if (_hasDiscount)
                    Positioned(
                      top: 6,
                      right: 6,
                      child: DiscountBadge(
                        discountPercentage:
                            (widget.product as DiscountedProduct)
                                .discountPercentage,
                      ),
                    ),
                  Positioned(
                    bottom: 6,
                    left: 6,
                    child: StockBadge(stock: widget.product.stock),
                  ),
                ],
              ),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CategoryBadge(category: widget.product.category),
                      const SizedBox(height: 6),

                      Flexible(
                        child: Text(
                          widget.product.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),

                      _buildPrice(),
                      const SizedBox(height: 6),

                      Text(
                        'Stok: ${widget.product.stock} • ${widget.product.getStockStatus()}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPrice() {
    if (widget.product is DiscountedProduct) {
      final d = widget.product as DiscountedProduct;
      if (d.discountPercentage > 0) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              PriceLabel.formatRupiah(widget.product.price),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey[500],
                decoration: TextDecoration.lineThrough,
              ),
            ),
            PriceLabel(price: d.getDiscountedPrice()),
          ],
        );
      }
    }
    return PriceLabel(price: widget.product.price);
  }

  Widget _placeholder() {
    return Container(
      color: Colors.grey[200],
      child: const Icon(Icons.image_outlined, size: 40, color: Colors.grey),
    );
  }
}
