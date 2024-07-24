import 'package:flutter/material.dart';
import 'package:flutter_supabase_store/models/product.dart';
import 'package:flutter_supabase_store/screens/product_details_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _searchController = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];

  Future<void> _searchProducts(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults = []; // Clear results if the query is empty
      });
      return;
    }

    final response = await Supabase.instance.client
        .from('products')
        .select()
        .textSearch('name', query); // Adjust 'name' to your actual column name if needed

    setState(() {
      _searchResults = List<Map<String, dynamic>>.from(response as List);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Поиск товаров'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Поиск...',
                suffixIcon: IconButton(
                  onPressed: () => _searchProducts(_searchController.text),
                  icon: const Icon(Icons.search),
                ),
              ),
              onChanged: (query) {
                _searchProducts(query);
              },
            ),
          ),
          Expanded(
            child: _searchResults.isEmpty
                ? const Center(
                    child: Text('Начните вводить запрос для поиска'),
                  )
                : ListView.builder(
                    itemCount: _searchResults.length,
                    itemBuilder: (context, index) {
                      final product = _searchResults[index];
                      return ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ProductDetailsPage(product: Product.fromJson(product)), 
                            ),
                          );
                        },
                        leading: product['image_url'] != null
                            ? Image.network(product['image_url'])
                            : const Icon(Icons.image),
                        title: Text(product['name']),
                        subtitle: Text('\$${product['price'].toStringAsFixed(2)}'),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}