import 'package:baket_mobile/features/auth/pages/login.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:google_fonts/google_fonts.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) {
        CookieRequest request = CookieRequest();
        return request;
      },
      child: GetMaterialApp(
        title: 'Flutter App',
        theme: ThemeData(
          textTheme: GoogleFonts.ralewayTextTheme(
            Theme.of(context).textTheme,
          ),
          primarySwatch: Colors.blue,
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue),
          // ... other theme settings
        ),
        home: const LoginApp(),
      ),
    );
  }
}
