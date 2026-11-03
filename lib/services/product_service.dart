import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/product.dart';

/// Service yang menampung seluruh fungsi pengambilan data produk
/// TokoKamu dari REST API (Fake Store API).
///
/// Seluruh request bersifat asynchronous ([Future]) karena melibatkan
/// jaringan, sehingga dipanggil dengan async/await atau ditampilkan
/// menggunakan widget seperti FutureBuilder.
class ProductService {
  /// Alamat dasar REST API.
  ///
  /// Ubah nilai ini (misalnya menjadi URL yang salah) untuk
  /// mensimulasikan kegagalan pengambilan data.
  static const String baseUrl = 'https://fakestoreapi.com';

  /// Mengambil seluruh daftar produk dari endpoint `/products`.
  ///
  /// Melempar [Exception] bila request gagal, baik karena status code
  /// bukan 200 maupun terjadi kesalahan jaringan.
  static Future<List<Product>> fetchProducts() async {
    try {
      final uri = Uri.parse('$baseUrl/products');
      final response = await http.get(uri);

      // Cetak status code dan body ke console untuk memastikan
      // data benar-benar diterima dari server.
      debugPrint('[ProductService] GET $uri → ${response.statusCode}');
      debugPrint('[ProductService] body: ${response.body}');

      // Pengecekan statusCode tetap diperlukan: respons 404/500 tidak
      // otomatis memicu exception, padahal body-nya bukan daftar produk.
      if (response.statusCode != 200) {
        throw Exception('Server mengembalikan status ${response.statusCode}');
      }

      // Parsing JSON: String body → List of Map → List<Product>.
      final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
      return data
          .map((item) => Product.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('[ProductService] gagal memuat daftar produk: $e');
      throw Exception('Gagal memuat produk, coba lagi');
    }
  }

  /// Mengambil detail satu produk dari endpoint `/products/{id}`.
  ///
  /// Melempar [Exception] bila request gagal.
  static Future<Product> fetchProductDetail(int id) async {
    try {
      final uri = Uri.parse('$baseUrl/products/$id');
      final response = await http.get(uri);

      debugPrint('[ProductService] GET $uri → ${response.statusCode}');
      debugPrint('[ProductService] body: ${response.body}');

      if (response.statusCode != 200) {
        throw Exception('Server mengembalikan status ${response.statusCode}');
      }

      final Map<String, dynamic> data =
          jsonDecode(response.body) as Map<String, dynamic>;
      return Product.fromJson(data);
    } catch (e) {
      debugPrint('[ProductService] gagal memuat detail produk: $e');
      throw Exception('Gagal memuat detail produk, coba lagi');
    }
  }
}
