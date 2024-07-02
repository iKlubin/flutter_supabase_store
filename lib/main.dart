import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_supabase_store/models/cart.dart';
import 'package:flutter_supabase_store/screens/add_product_page.dart';
import 'package:flutter_supabase_store/screens/cart_page.dart';
import 'package:flutter_supabase_store/screens/categories_page.dart';
import 'package:flutter_supabase_store/screens/home_page.dart';
import 'package:flutter_supabase_store/screens/login_page.dart';
import 'package:flutter_supabase_store/screens/profile_page.dart';
import 'package:flutter_supabase_store/screens/registration_page.dart';
import 'package:flutter_supabase_store/screens/search_page.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const supabaseKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImltZW1pbWtkdXNsbHhwbnJ3eWhzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTk0MTkzNTEsImV4cCI6MjAzNDk5NTM1MX0.d-nvrxTdftpcIAVAeWwns6aaM_wtHbFBD4OKGEHmPXk';
  const supabaseUrl = 'https://imemimkdusllxpnrwyhs.supabase.co';

  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseKey,
  );

  runApp(
    ChangeNotifierProvider(
      create: (_) => CartModel(),
      child: const MyApp(),
    ),
  );
}

final supabase = Supabase.instance.client;
final session = supabase.auth.currentSession;
final isSessionExpired = session?.isExpired;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shop',
      home: const MyHomePage(),
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        '/search': (context) => const SearchPage(),
        '/profile': (context) => const ProfilePage(),
        '/login': (context) => const LoginPage(),
        '/registration': (context) => const RegistrationPage(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    SearchPage(),
    CategoriesPage(),
    AddProductPage(),
    CartPage(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        unselectedIconTheme: const CupertinoIconThemeData(),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.home),
            label: 'Главная',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.search),
            label: 'Поиск',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.square_list),
            label: 'Категории',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.add),
            label: 'Добавить товар',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.cart),
            label: 'Корзина',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.person),
            label: 'Профиль',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: CupertinoColors.activeBlue,
        unselectedItemColor: CupertinoColors.systemGrey,
        onTap: _onItemTapped,
      ),
    );
  }
}
