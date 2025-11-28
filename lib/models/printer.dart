class Printer {
  final String id;
  final String name;
  final String brand;
  final double price;
  final String category;
  final List<String> images;
  final Map<String, String> specifications;
  final String description;
  final double rating;
  final int reviewCount;
  final bool isTrending;

  Printer({
    required this.id,
    required this.name,
    required this.brand,
    required this.price,
    required this.category,
    required this.images,
    required this.specifications,
    required this.description,
    this.rating = 4.0,
    this.reviewCount = 0,
    this.isTrending = false,
  });

  factory Printer.fromJson(Map<String, dynamic> json) {
    return Printer(
      id: json['id'],
      name: json['name'],
      brand: json['brand'],
      price: json['price'].toDouble(),
      category: json['category'],
      images: List<String>.from(json['images']),
      specifications: Map<String, String>.from(json['specifications']),
      description: json['description'],
      rating: json['rating']?.toDouble() ?? 4.0,
      reviewCount: json['reviewCount'] ?? 0,
      isTrending: json['isTrending'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'brand': brand,
      'price': price,
      'category': category,
      'images': images,
      'specifications': specifications,
      'description': description,
      'rating': rating,
      'reviewCount': reviewCount,
      'isTrending': isTrending,
    };
  }
}