import 'category_model.dart';

class ProductModel {
  final int id;
  final String title;
  final String slug;
  final double price;
  final String description;
  final CategoryModel category;
  final List<String> images;
  final String creationAt;
  final String updatedAt;

  ProductModel({
    required this.id,
    required this.title,
    required this.slug,
    required this.price,
    required this.description,
    required this.category,
    required this.images,
    required this.creationAt,
    required this.updatedAt,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      slug: json['slug'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      description: json['description'] ?? '',
      category: CategoryModel.fromJson(json['category'] ?? {}),
      images: List<String>.from(
        (json['images'] ?? []).map((img) {
          String url = img.toString();
          url =
              url
                  .replaceAll('[', '')
                  .replaceAll(']', '')
                  .replaceAll('"', '')
                  .trim();
          return url;
        }),
      ),
      creationAt: json['creationAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }

  String get validImageUrl {
    if (images.isEmpty)
      return 'https://placehold.co/400x400/6C63FF/FFFFFF?text=Product';
    final url = images.first.trim();
    if (url.isEmpty || !url.startsWith('http')) {
      return 'https://placehold.co/400x400/6C63FF/FFFFFF?text=Product';
    }
    return url;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'slug': slug,
      'price': price,
      'description': description,
      'category': category.toJson(),
      'images': images,
      'creationAt': creationAt,
      'updatedAt': updatedAt,
    };
  }
}
