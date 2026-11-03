class Category {
  final String id;
  final String name;

  Category({
    required this.id,
    required this.name,
  });

  /// Membuat objek [Category] dari map JSON, misalnya dari REST API.
  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id']?.toString() ?? '',
      name: json['name'] as String? ?? '',
    );
  }

  /// Mengubah objek [Category] menjadi map JSON.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}