import 'package:baket_mobile/features/auth/pages/login.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'app.dart';

Future<void> main() async {
  // Ensuring Flutter is properly initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Running the app
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) {
        CookieRequest request = CookieRequest();
        return request;
      },
      child: MaterialApp(
        title: 'Flutter App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          // ... other theme settings
        ),
        home: const LoginApp(), // or your initial route
      ),
    );
  }
}
