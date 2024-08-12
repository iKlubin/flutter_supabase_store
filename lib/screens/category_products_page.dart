import 'package:flutter/material.dart';
import 'package:flutter_supabase_store/models/product.dart';
import 'package:flutter_supabase_store/widgets/product_card.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CategoryProductsPage extends StatefulWidget {
  final String categoryId;
  final String categoryName;

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
                          id: product.id,
                          name: product.name,
                          description: product.description,
                          extendedDescription: product.extendedDescription,
                          imageUrl: product.imageUrl,
                          price: product.price,
                          categoryID: product.categoryID,
                          tags: product.tags,
                          rating: product.rating,
                          purchaseCount: product.purchaseCount,
                          viewCount: product.viewCount,
                          discount: product.discount,
                          userId: product.userId,
                        );
            },
          );
        },
      ),
    );
  }
}
