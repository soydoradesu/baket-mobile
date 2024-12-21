import 'package:baket_mobile/core/constants/_constants.dart';
import 'package:baket_mobile/features/auth/pages/register.dart';
import 'package:baket_mobile/services/pref_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';

import '../../../navbar.dart';

void main() {
  runApp(const LoginApp());
}

class LoginApp extends StatelessWidget {
  const LoginApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login Screen',
      theme: ThemeData(
        fontFamily: GoogleFonts.raleway().fontFamily,
        primarySwatch: Colors.blue,
        primaryColor: const Color(0xFF01AAE8),
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF01AAE8),
          onPrimary: Colors.white,
          secondary: Color(0xFF01AAE8),
        ),
        buttonTheme: const ButtonThemeData(textTheme: ButtonTextTheme.primary),
      ),
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  static const String baseUrl = Endpoints.baseUrl;
  static const String loginUrl = '$baseUrl/auth/login/';

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                Image.asset(
                  'assets/images/BaKet_Logo.png',
                  height: 100,
                ),
                const SizedBox(height: 24),
                // Title
                const Text(
                  'Masuk ke Akun Kamu!',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF01AAE8),
                  ),
                ),
                const SizedBox(height: 32),
                // Username Field
                TextFormField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    hintText: 'Masukin usernamemu',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: const BorderSide(color: Color(0xFF01AAE8)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: const BorderSide(color: Color(0xFF01AAE8)),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Password Field
                TextFormField(
                  obscureText: true,
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: 'Masukin passwordmu',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: const BorderSide(color: Color(0xFF01AAE8)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: const BorderSide(color: Color(0xFF01AAE8)),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                // Forgot Password
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      // Forgot password logic
                    },
                    child: const Text(
                      'Lupa Password?',
                      style: TextStyle(color: Color(0xFF01AAE8)),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Login Button
                ElevatedButton(
                  onPressed: () async {
                    // TODO: Login logic
                    String username = _usernameController.text;
                    String password = _passwordController.text;
                    final response = await request.login(loginUrl, {
                      'username': username,
                      'password': password,
                    });

                    if (request.loggedIn) {
                      PrefService.saveString(
                        "profile_picture",
                        response['profile_picture'],
                      );
                      PrefService.saveString(
                        "username",
                        response['username'],
                      );
                      String message = response['message'];
                      String uname = response['username'];
                      if (context.mounted) {
                        Get.offAll(() =>
                            const NavigationMenu()); // Replaces the current route stack entirely.
                        // Navigator.pushReplacement(
                        //   context,
                        //   MaterialPageRoute(
                        //       builder: (context) => const App()),
                        // );
                        ScaffoldMessenger.of(context)
                          ..hideCurrentSnackBar()
                          ..showSnackBar(
                            SnackBar(
                                content:
                                    Text("$message Selamat datang, $uname.")),
                          );
                      }
                    } else {
                      if (context.mounted) {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Login Gagal'),
                            content: Text(response['message']),
                            actions: [
                              TextButton(
                                child: const Text('OK'),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          ),
                        );
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF01AAE8),
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: const Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFFFFFFFF),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Sign Up
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Belum punya akun?"),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const RegisterApp()),
                        );
                      },
                      child: const Text(
                        'Daftar',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
