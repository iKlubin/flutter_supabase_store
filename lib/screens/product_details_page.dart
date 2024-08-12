import 'package:flutter/material.dart';
import 'package:flutter_supabase_store/main.dart';
import 'package:flutter_supabase_store/models/cart.dart';
import 'package:flutter_supabase_store/models/product.dart';
import 'package:flutter_supabase_store/models/rewiew.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class ProductDetailsPage extends StatefulWidget {
  final Product product;

  const ProductDetailsPage({super.key, required this.product});

  @override
  _ProductDetailsPageState createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  late Product product;
  List<Review> reviews = [];
  bool isLoading = true;
  final TextEditingController _commentController = TextEditingController();
  int _rating = 0;

  @override
  void initState() {
    super.initState();
    product = widget.product;
    _incrementViewCount();
    _fetchReviews();
  }

  Future<void> _incrementViewCount() async {
    await supabase
        .from('products')
        .update({'view_count': product.viewCount + 1})
        .eq('id', product.id);
  }

  Future<void> _fetchReviews() async {
  final response = await supabase
      .from('reviews')
      .select('id, product_id, user_id, rating, comment, created_at, users(name)')
      .eq('product_id', product.id)
      .order('created_at', ascending: false);

  final data = response as List<dynamic>;

  setState(() {
    reviews = data.map((reviewData) {
      final reviewMap = reviewData as Map<String, dynamic>;
      return Review(
        id: reviewMap['id'],
        productId: reviewMap['product_id'],
        userId: reviewMap['user_id'],
        username: reviewMap['users']['name'],
        rating: reviewMap['rating'],
        comment: reviewMap['comment'],
        createdAt: DateTime.parse(reviewMap['created_at']),
      );
    }).toList();
    isLoading = false;
  });
}

  Future<void> _submitReview() async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    final comment = _commentController.text;

    if (_rating == 0 || comment.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Пожалуйста, поставьте оценку и напишите комментарий.')),
      );
      return;
    }

    await supabase.from('reviews').insert({
      'product_id': product.id,
      'user_id': user.id,
      'rating': _rating,
      'comment': comment,
    });

    _commentController.clear();
    _rating = 0;
    _fetchReviews(); // Refresh reviews after submission

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Спасибо за ваш отзыв!')),
    );
  }

  void _addToCart(BuildContext context) {
    final cart = Provider.of<CartModel>(context, listen: false);
    cart.addItem(product);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${product.name} добавлен в корзину')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = supabase.auth.currentUser; // Get current user

    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 100),
            Hero(
              tag: product.id,
              child: Image.network(
                product.imageUrl,
                height: 400.0,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    '₽${product.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 18.0,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.yellow, size: 20),
                      const SizedBox(width: 4),
                      Text(
                        product.rating != 0
                            ? '${product.rating.toStringAsFixed(1)} / 5'
                            : 'Нет оценок',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  if ((product.tags as List).isNotEmpty) ...[
                    const Text(
                      'Теги:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 4.0,
                      children: (product.tags as List<dynamic>)
                          .map((tag) => Chip(
                                label: Text(tag),
                              ))
                          .toList(),
                    ),
                    const SizedBox(height: 16.0),
                  ],
                  const Text(
                    'Описание:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    product.extendedDescription,
                    style: const TextStyle(fontSize: 16.0),
                  ),
                  const SizedBox(height: 32.0),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                      backgroundColor: Colors.blue,
                      textStyle: const TextStyle(fontSize: 18.0),
                    ),
                    onPressed: () => _addToCart(context),
                    child: const Text(
                      'Добавить в корзину',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  const Text(
                    'Отзывы:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8.0),
                  isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : reviews.isEmpty
                          ? const Text('Пока нет отзывов.')
                          : Column(
                              children: reviews.map((review) {
                                return Card(
                                  elevation: 2.0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: List.generate(
                                                5,
                                                (index) => Icon(
                                                  Icons.star,
                                                  color: index < review.rating
                                                      ? Colors.amber
                                                      : Colors.grey[300],
                                                  size: 20,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              review.username,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14.0,
                                                color: Colors.black87,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8.0), // Spacing between rating and comment
                                        Text(
                                          review.comment,
                                          style: const TextStyle(
                                            fontSize: 16.0,
                                            color: Colors.black87,
                                            height: 1.5, // Better readability
                                          ),
                                        ),
                                        const SizedBox(height: 12.0), // Spacing between comment and timestamp
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                                              decoration: BoxDecoration(
                                                color: Colors.blue[50], // Soft background color
                                                borderRadius: BorderRadius.circular(8.0),
                                              ),
                                              child: Text(
                                                timeago.format(review.createdAt),
                                                style: const TextStyle(
                                                  fontSize: 12.0,
                                                  color: Colors.blueGrey,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                  const SizedBox(height: 16.0),
                  if (user != null) ...[
                    const Text(
                      'Оставить отзыв:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8.0),
                    Row(
                      children: List.generate(5, (index) {
                        return IconButton(
                          icon: Icon(
                            Icons.star,
                            color: _rating > index ? Colors.yellow : Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              _rating = index + 1;
                            });
                          },
                        );
                      }),
                    ),
                    TextField(
                      controller: _commentController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Напишите ваш отзыв',
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: _submitReview,
                      child: const Text('Отправить отзыв'),
                    ),
                  ] else ...[
                    const Text(
                      'Войдите, чтобы оставить отзыв.',
                      style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                    ),
                    const SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: () {
                        // Navigate to the login page
                        Navigator.pushNamed(context, '/login');
                      },
                      child: const Text('Войти'),
                    ),
                  ],
                  const SizedBox(height: 16.0),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
