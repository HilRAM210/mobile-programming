import 'package:flutter/material.dart';
import '../models/favorite_item.dart';
import '../models/product.dart';

class FavoriteButton extends StatefulWidget {
  final Product product;
  final List<FavoriteItem> favorites;
  final VoidCallback? onChanged;
  final double size;
  final bool withBackground;

  const FavoriteButton({
    super.key,
    required this.product,
    required this.favorites,
    this.onChanged,
    this.size = 20,
    this.withBackground = false,
  });

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  late bool _isLiked;

  @override
  void initState() {
    super.initState();
    _isLiked = _checkLiked();
  }

  bool _checkLiked() =>
      widget.favorites.any((f) => f.product.id == widget.product.id);

  void _toggle() {
    setState(() {
      if (_isLiked) {
        widget.favorites
            .removeWhere((f) => f.product.id == widget.product.id);
      } else {
        widget.favorites.add(FavoriteItem(product: widget.product));
      }
      _isLiked = !_isLiked;
    });
    widget.onChanged?.call();
  }

  @override
  Widget build(BuildContext context) {
    final icon = Icon(
      _isLiked ? Icons.favorite : Icons.favorite_border,
      size: widget.size,
      color: _isLiked ? Colors.red : Colors.grey,
    );

    if (widget.withBackground) {
      return GestureDetector(
        onTap: _toggle,
        child: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.9),
            shape: BoxShape.circle,
          ),
          child: icon,
        ),
      );
    }

    // Versi tanpa background — cocok untuk AppBar actions
    return IconButton(
      onPressed: _toggle,
      icon: icon,
      tooltip: _isLiked ? 'Hapus dari favorit' : 'Tambah ke favorit',
    );
  }
}
