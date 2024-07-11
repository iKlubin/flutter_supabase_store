import 'package:flutter/material.dart';
import 'package:flutter_supabase_store/models/product.dart';

class CartModel extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  void addItem(Product product) {
    final existingItem = _items.firstWhere(
      (item) => item.product.id == product.id,
      orElse: () => CartItem(product: product, quantity: 0),
    );
    if (existingItem.quantity == 0) {
      _items.add(existingItem);
    }
    existingItem.quantity++;
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.removeWhere((item) => item.product.id == productId);
    notifyListeners();
  }

  void updateQuantity(String productId, int quantity) {
    final item = _items.firstWhere((item) => item.product.id == productId);
    item.quantity = quantity;
    if (item.quantity <= 0) {
      _items.remove(item);
    }
    notifyListeners();
  }

  int get totalItems => _items.fold(0, (total, item) => total + item.quantity);

  double get totalPrice => _items.fold(0.0, (total, item) => total + item.product.price * item.quantity);
}

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, required this.quantity});
}
