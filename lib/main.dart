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
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => CookieRequest(),
      child: MaterialApp(
        title: 'Flutter App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          // ... other theme settings
        ),
        home: const App(), // or your initial route
      ),
    );
  }
}
