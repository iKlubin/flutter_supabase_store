import 'package:flutter/material.dart';
import 'package:flutter_supabase_store/models/product.dart';

class ProductDetailsPage extends StatelessWidget {
  final Product product;

  const ProductDetailsPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
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
                    '\$${product.price.toStringAsFixed(2)}', 
                    style: const TextStyle(
                      fontSize: 18.0,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  // Ratings Row
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
                  // Tags Section
                  if ((product.tags as List).isNotEmpty)
                    ...[
                      const Text(
                        'Теги:',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8.0, // space between chips
                        runSpacing: 4.0, // space between lines of chips
                        children: (product.tags as List<dynamic>).map((tag) => Chip(
                          label: Text(tag),
                        )).toList(),
                      ),
                      const SizedBox(height: 16.0),
                    ],
                  // Description
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
                    onPressed: () {
                      // TODO: Implement add to cart functionality
                    },
                    child: const Text(
                      'Добавить в корзину',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
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