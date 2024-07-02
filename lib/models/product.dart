class Product {
  final String id;
  final String name;
  final String description;
  final String extendedDescription;
  final double price;
  final String categoryID;
  final List<String> tags;
  final int rating;
  final String imageUrl;
  final int purchaseCount;
  final int viewCount;
  final double discount;
  final String userId;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.extendedDescription,
    required this.price,
    required this.categoryID,
    required this.tags,
    required this.rating,
    required this.imageUrl,
    required this.purchaseCount,
    required this.viewCount,
    required this.discount,
    required this.userId,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? '',
      name: json['name'] ?? 'Без названия',
      description: json['description'] ?? '',
      extendedDescription: json['extended_description'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      categoryID: json['category_id'] ?? '',
      tags: json['tags'] != null ? List<String>.from(json['tags']) : [],
      rating: json['rating'] ?? 0,
      imageUrl: json['image_url'] ?? '',
      purchaseCount: json['purchase_count'] ?? 0,
      viewCount: json['view_count'] ?? 0,
      discount: (json['discount'] ?? 0).toDouble(),
      userId: json['user_id'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'extended_description': extendedDescription,
      'price': price,
      'category_id': categoryID,
      'tags': tags,
      'rating': rating,
      'image_url': imageUrl,
      'purchase_count': purchaseCount,
      'view_count': viewCount,
      'discount': discount,
      'user_id': userId,
    };
  }
}
