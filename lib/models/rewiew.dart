class Review {
  final String id;
  final String productId;
  final String userId;
  final String username;
  final int rating;
  final String comment;
  final DateTime createdAt;

  Review({
    required this.id,
    required this.productId,
    required this.userId,
    required this.username,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });

  factory Review.fromMap(Map<String, dynamic> map) {
    return Review(
      id: map['id'] as String,
      productId: map['product_id'] as String,
      userId: map['user_id'] as String,
      username: map['users']['name'] as String,
      rating: map['rating'] as int,
      comment: map['comment'] as String,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }
}