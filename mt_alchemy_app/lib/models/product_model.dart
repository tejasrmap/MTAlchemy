enum ProductType {
  digital,
  physical,
}

class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String category;
  final ProductType type;
  final double rating;
  final int reviewCount;
  final String imageUrl;
  final String? digitalDownloadUrl;
  final int stockQuantity;
  final String badge;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.type,
    this.rating = 4.8,
    this.reviewCount = 45,
    required this.imageUrl,
    this.digitalDownloadUrl,
    this.stockQuantity = 50,
    this.badge = 'Staff Pick',
  });

  bool get isDigital => type == ProductType.digital;
  bool get isPhysical => type == ProductType.physical;

  Product copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    String? category,
    ProductType? type,
    double? rating,
    int? reviewCount,
    String? imageUrl,
    String? digitalDownloadUrl,
    int? stockQuantity,
    String? badge,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      category: category ?? this.category,
      type: type ?? this.type,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      imageUrl: imageUrl ?? this.imageUrl,
      digitalDownloadUrl: digitalDownloadUrl ?? this.digitalDownloadUrl,
      stockQuantity: stockQuantity ?? this.stockQuantity,
      badge: badge ?? this.badge,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'description': description,
        'price': price,
        'category': category,
        'type': type.name,
        'rating': rating,
        'reviewCount': reviewCount,
        'imageUrl': imageUrl,
        'digitalDownloadUrl': digitalDownloadUrl,
        'stockQuantity': stockQuantity,
        'badge': badge,
      };

  factory Product.fromMap(Map<String, dynamic> map) => Product(
        id: map['id'],
        name: map['name'],
        description: map['description'] ?? '',
        price: (map['price'] as num).toDouble(),
        category: map['category'] ?? 'General',
        type: ProductType.values.firstWhere(
          (t) => t.name == map['type'],
          orElse: () => ProductType.digital,
        ),
        rating: (map['rating'] as num?)?.toDouble() ?? 4.8,
        reviewCount: map['reviewCount'] ?? 20,
        imageUrl: map['imageUrl'] ?? '',
        digitalDownloadUrl: map['digitalDownloadUrl'],
        stockQuantity: map['stockQuantity'] ?? 10,
        badge: map['badge'] ?? 'Featured',
      );
}

