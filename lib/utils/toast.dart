import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Menampilkan toast sederhana (ala Android Toast) di bagian bawah layar
/// sebagai penanda singkat, misalnya "item berhasil ditambahkan".
///
/// Toast otomatis hilang setelah beberapa detik dan tidak menghalangi
/// interaksi pengguna.
void showToast(
  String message, {
  IconData icon = Icons.check_circle_outline,
  Duration duration = const Duration(seconds: 2),
}) {
  final overlayContext = Get.overlayContext;
  if (overlayContext == null) return;

  final entry = OverlayEntry(
    builder: (_) => _ToastWidget(message: message, icon: icon),
  );

  Overlay.of(overlayContext).insert(entry);

  Future.delayed(duration, () {
    if (entry.mounted) entry.remove();
  });
}

class _ToastWidget extends StatelessWidget {
  const _ToastWidget({required this.message, required this.icon});

  final String message;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: SafeArea(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: 1),
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOut,
              builder: (context, value, child) => Opacity(
                opacity: value,
                child: Transform.translate(
                  offset: Offset(0, 16 * (1 - value)),
                  child: child,
                ),
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 320),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(icon, color: Colors.white, size: 18),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          message,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
