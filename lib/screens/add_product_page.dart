import 'package:flutter/material.dart';
import 'package:flutter_supabase_store/main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _extendedDescriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _tagsController = TextEditingController();
  String? _imageUrl;
  File? _imageFile;
  bool _isLoading = false;
  String? _errorMessage;
  List<Map<String, dynamic>> _categories = [];
  String? _selectedCategoryId;

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    try {
      final response = await supabase.from('categories').select();
      setState(() {
        _categories = List<Map<String, dynamic>>.from(response as List);
        if (_categories.isNotEmpty) {
          _selectedCategoryId = _categories[0]['id'].toString();
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка загрузки категорий: $e')),
      );
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final compressedImage = await _compressImage(pickedFile.path);
      setState(() {
        _imageFile = File(compressedImage.path);
      });
    }
  }

  Future<XFile> _compressImage(String imagePath) async {
    final compressedImage = await FlutterImageCompress.compressAndGetFile(
      imagePath,
      imagePath.replaceAll(RegExp(r'\.[^.]+$'), '_compressed.jpg'), // Новое имя для сжатого изображения
      quality: 80, // Качество сжатия (0-100)
    );
    return compressedImage!;
  }

  Future<void> _addProduct() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final name = _nameController.text;
    final description = _descriptionController.text;
    final extendedDescription = _extendedDescriptionController.text;
    final price = double.tryParse(_priceController.text) ?? 0.0;
    final tags = _tagsController.text.split(',').map((tag) => tag.trim()).toList();

    try {
      if (_imageFile != null) {
        final imageName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
        await supabase.storage
            .from('products_images')
            .upload(imageName, _imageFile!, fileOptions: const FileOptions(upsert: true));
        
        final res = supabase.storage.from('products_images').getPublicUrl(imageName);
        _imageUrl = res;
      }

      final response = await supabase.from('products').insert({
        'name': name,
        'description': description,
        'extended_description': extendedDescription,
        'price': price,
        'image_url': _imageUrl,
        'category_id': _selectedCategoryId,
        'tags': tags,
      });

      if (response.error != null) {
        throw response.error!;
      }

      _formKey.currentState!.reset();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Товар успешно добавлен!')),
      );
      Navigator.of(context).pop();
    } catch (e) {
      setState(() {
        _errorMessage = 'Ошибка: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Добавить товар'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Название товара',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Пожалуйста, введите название товара';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Краткое описание',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Пожалуйста, введите краткое описание товара';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _extendedDescriptionController,
                decoration: const InputDecoration(
                  labelText: 'Расширенное описание',
                  border: OutlineInputBorder(),
                ),
                maxLines: 4,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(
                  labelText: 'Цена',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Пожалуйста, введите цену товара';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Пожалуйста, введите корректное число';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _tagsController,
                decoration: const InputDecoration(
                  labelText: 'Теги (через запятую)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              _imageFile != null
                  ? Image.file(_imageFile!, height: 200)
                  : const SizedBox(height: 200),
              ElevatedButton(
                onPressed: _pickImage,
                child: const Text('Выбрать изображение'),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedCategoryId,
                decoration: const InputDecoration(
                  labelText: 'Категория',
                  border: OutlineInputBorder(),
                ),
                items: _categories.map((category) {
                  return DropdownMenuItem<String>(
                    value: category['id'].toString(),
                    child: Text(category['name']),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedCategoryId = newValue;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Пожалуйста, выберите категорию';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              if (_isLoading)
                const Center(child: CircularProgressIndicator())
              else
                ElevatedButton(
                  onPressed: _addProduct,
                  child: const Text('Добавить товар'),
                ),
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _extendedDescriptionController.dispose();
    _priceController.dispose();
    _tagsController.dispose();
    super.dispose();
  }
}
