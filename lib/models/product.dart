class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final List<String> images;
  final String category;
  final String brand;
  final Map<String, String> specifications;
  final bool isTrending;
  final double rating;
  final int reviewCount;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.images,
    required this.category,
    required this.brand,
    required this.specifications,
    this.isTrending = false,
    this.rating = 0.0,
    this.reviewCount = 0,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price'].toDouble(),
      images: List<String>.from(json['images']),
      category: json['category'],
      brand: json['brand'],
      specifications: Map<String, String>.from(json['specifications']),
      isTrending: json['isTrending'] ?? false,
      rating: json['rating']?.toDouble() ?? 0.0,
      reviewCount: json['reviewCount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'images': images,
      'category': category,
      'brand': brand,
      'specifications': specifications,
      'isTrending': isTrending,
      'rating': rating,
      'reviewCount': reviewCount,
    };
  }
}