import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Future<void> _signOut() async {
    try {
      await Supabase.instance.client.auth.signOut();
      // After signing out, navigate to login or another appropriate screen
      Navigator.pushReplacementNamed(context, '/login'); 
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Произошла ошибка при выходе из аккаунта.'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Профиль'),
      ),
      body: Center(
        child: StreamBuilder<AuthState>(
          stream: Supabase.instance.client.auth.onAuthStateChange,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }
            if (snapshot.hasData) {
              final AuthChangeEvent data = snapshot.data!.event;
              final Session? session = snapshot.data!.session;

              if (data == AuthChangeEvent.signedIn && session != null) {
                // User is authenticated
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Email: ${session.user.email}'),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _signOut, 
                      child: const Text('Выйти из аккаунта'),
                    ),
                  ],
                );
              } else {
                // User is not authenticated
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/login');
                      },
                      child: const Text('Войти'),
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/registration');
                      },
                      child: const Text('Зарегистрироваться'),
                    ),
                  ],
                );
              }
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}