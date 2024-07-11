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
            : Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16.0),
                      itemCount: cart.items.length,
                      itemBuilder: (context, index) {
                        final cartItem = cart.items[index];
                        final product = cartItem.product;
                        return Card(
                          elevation: 4.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12.0),
                                  child: Image.network(
                                    product.imageUrl,
                                    fit: BoxFit.cover,
                                    width: 100,
                                    height: 100,
                                  ),
                                ),
                                const SizedBox(width: 16.0),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product.name,
                                        style: const TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 8.0),
                                      Text(
                                        '₽${product.price}',
                                        style: const TextStyle(
                                          fontSize: 16.0,
                                          color: Colors.green,
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              IconButton(
                                                icon: const Icon(Icons.remove),
                                                onPressed: () {
                                                  cart.updateQuantity(product.id, cartItem.quantity - 1);
                                                },
                                              ),
                                              Text('${cartItem.quantity}'),
                                              IconButton(
                                                icon: const Icon(Icons.add),
                                                onPressed: () {
                                                  cart.updateQuantity(product.id, cartItem.quantity + 1);
                                                },
                                              ),
                                            ],
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.delete, color: Colors.red),
                                            onPressed: () {
                                              cart.removeItem(product.id);
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Всего товаров: ${cart.totalItems}',
                          style: const TextStyle(fontSize: 18.0),
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          'Общая сумма: ₽${cart.totalPrice}',
                          style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16.0),
                        ElevatedButton(
                          onPressed: () {
                            // Обработка оформления заказа
                          },
                          child: const Text('Оформить заказ'),
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
