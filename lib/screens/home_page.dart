import 'package:flutter/material.dart';
import 'package:flutter_supabase_store/models/product.dart';
import 'package:flutter_supabase_store/screens/product_datails_page.dart';
import 'package:flutter_supabase_store/widgets/product_card.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final Future<List<Map<String, dynamic>>> _future;

  @override
  void initState() {
    super.initState();
    _future = Supabase.instance.client.from('products').select().then((value) => List<Map<String, dynamic>>.from(value));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Главная'),
      ),
      body: SafeArea(
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Ошибка: ${snapshot.error}'));
            }

            final products = snapshot.data ?? [];

            return GridView.builder(
              padding: const EdgeInsets.all(16.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1, // You can adjust this for different layouts
                mainAxisSpacing: 16.0,
                crossAxisSpacing: 16.0,
                childAspectRatio: 0.75,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = Product.fromJson(products[index]);
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetailsPage(product: product), 
                      ),
                    );
                  },
                  child: ProductCard(
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
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}