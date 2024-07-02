import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_supabase_store/models/cart.dart';
import 'package:flutter_supabase_store/models/product.dart';

class ProductCard extends StatelessWidget {
  final String id;
  final String name;
  final String description;
  final String extendedDescription;
  final String imageUrl;
  final double price;
  final String categoryID;
  final List<String> tags;
  final int rating;
  final int purchaseCount;
  final int viewCount;
  final double discount;
  final String userId;

  const ProductCard({
    super.key,
    required this.id,
    required this.name,
    required this.description,
    required this.extendedDescription,
    required this.imageUrl,
    required this.price,
    required this.categoryID,
    required this.tags,
    required this.rating,
    required this.purchaseCount,
    required this.viewCount,
    required this.discount,
    required this.userId,
  });

  void _addToCart(BuildContext context) {
    final cart = Provider.of<CartModel>(context, listen: false);
    final product = Product(
      id: id,
      name: name,
      description: description,
      extendedDescription: extendedDescription,
      imageUrl: imageUrl,
      price: price,
      categoryID: categoryID,
      tags: tags,
      rating: rating,
      purchaseCount: purchaseCount,
      viewCount: viewCount,
      discount: discount,
      userId: userId,
    );
    cart.addItem(product);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$name добавлен в корзину')),
    );
  }

   @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: IntrinsicHeight(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12.0),
                  topRight: Radius.circular(12.0),
                ),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 300, // Ограничьте высоту изображения
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                name,
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 14.0),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '₽$price',
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.yellow, size: 16.0),
                      const SizedBox(width: 4.0),
                      Text(rating != 0 ? rating.toString() : 'Нет рейтинга'),
                    ],
                  ),
                  Text('Просмотров: $viewCount'),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () => _addToCart(context),
                child: const Text('В корзину'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
