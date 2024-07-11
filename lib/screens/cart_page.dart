import 'package:flutter/material.dart';
import 'package:flutter_supabase_store/models/cart.dart';
import 'package:provider/provider.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Корзина'),
      ),
      body: SafeArea(
        child: cart.items.isEmpty
          ? const Center(child: Text('Ваша корзина пуста'))
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: cart.items.length,
              itemBuilder: (context, index) {
                final product = cart.items[index];
                return ProductCard(
                  id: product.id,
                  name: product.name,
                  description: product.description,
                  imageUrl: product.imageUrl,
                  price: product.price,
                  categoryID: product.categoryID,
                  tags: product.tags,
                  rating: product.rating,
                  purchaseCount: product.purchaseCount,
                  viewCount: product.viewCount,
                  discount: product.discount,
                  userId: product.userId,
                  extendedDescription: '',
                );
              },
            ),
      ),
    );
  }
}
