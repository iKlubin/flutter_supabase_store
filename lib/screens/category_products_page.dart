import 'package:flutter/material.dart';
import 'package:flutter_supabase_store/models/product.dart';
import 'package:flutter_supabase_store/screens/product_datails_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CategoryProductsPage extends StatefulWidget {
  final String categoryId;
  final String categoryName; // Добавим имя категории для AppBar

  const CategoryProductsPage({super.key, required this.categoryId, required this.categoryName});

  @override
  State<CategoryProductsPage> createState() => _CategoryProductsPageState();
}

class _CategoryProductsPageState extends State<CategoryProductsPage> {
  late final Future<List<Map<String, dynamic>>> _future;

  @override
  void initState() {
    super.initState();
    _future = Supabase.instance.client
        .from('products')
        .select()
        .eq('category_id', widget.categoryId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoryName), // Используем имя категории
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      extendBodyBehindAppBar: true,
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Ошибка: ${snapshot.error}'));
          }

          final products = snapshot.data ?? [];

          if (products.isEmpty) {
            return const Center(child: Text('В этой категории пока нет товаров'));
          }

          return GridView.builder(
            padding: const EdgeInsets.all(16.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1, 
              mainAxisSpacing: 16.0,
              crossAxisSpacing: 16.0,
              childAspectRatio: 0.75, // Отношение сторон карточки товара
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = Product.fromJson(products[index]);
              return ProductCard(
                product: product, // Передаем объект Product в ProductCard
              );
            },
          );
        },
      ),
    );
  }
}

// Пример виджета ProductCard (вы можете настроить его по своему усмотрению)
class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias, // Обрезаем контент по краям карточки
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0), // Закругленные углы карточки
      ),
      child: InkWell( // Добавляем InkWell для эффекта нажатия
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductDetailsPage(product: product),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    '\$${product.price.toStringAsFixed(2)}', 
                    style: const TextStyle(
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}