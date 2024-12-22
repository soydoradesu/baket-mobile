import 'dart:convert';

import 'package:baket_mobile/core/constants/_constants.dart';
import 'package:baket_mobile/core/themes/_themes.dart';
import 'package:baket_mobile/features/auth/pages/login.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart'; // For formatting the selected date

void main() {
  runApp(const RegisterApp());
}

class RegisterApp extends StatelessWidget {
  const RegisterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Register Screen',
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
      home: const RegisterPage(),
    );
  }
}

// Change RegisterPage to a StatefulWidget to manage date and gender states
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  DateTime? _selectedDate;
  String? _selectedGender;
  final labelStyleTheme = FontTheme.raleway14w500black();
  final hintStyleTheme = FontTheme.raleway14w600black2();

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1920, 1, 1),
      lastDate: DateTime.now(),
      helpText: 'Pilih tanggal lahir kamu',
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

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
                Text(
                  'Buat Akun Kamu!',
                  style: FontTheme.raleway22w700blue1()
                ),
                const SizedBox(height: 32),
                // First Name and Last Name Fields
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _firstNameController,
                        decoration: InputDecoration(
                          labelText: 'Nama Depan',
                          labelStyle: labelStyleTheme,
                          hintText: 'Masukin nama depanmu',
                          hintStyle: hintStyleTheme,
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
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _lastNameController,
                        decoration: InputDecoration(
                          labelText: 'Nama Belakang',
                          labelStyle: labelStyleTheme,
                          hintText: 'Masukin nama belakangmu',
                          hintStyle: hintStyleTheme,
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
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Username Field
                TextFormField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    labelStyle: labelStyleTheme,
                    hintText: 'Masukin usernamemu',
                    hintStyle: hintStyleTheme,
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
                    labelStyle: labelStyleTheme,
                    hintText: 'Masukin passwordmu',
                    hintStyle: hintStyleTheme,
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
                // Confirm Password Field
                TextFormField(
                  obscureText: true,
                  controller: _confirmPasswordController,
                  decoration: InputDecoration(
                    labelText: 'Konfirmasi Password',
                    labelStyle: labelStyleTheme,
                    hintText: 'Masukkan ulang passwordmu',
                    hintStyle: hintStyleTheme,
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
                // Birth Date and Gender Fields
                Row(
                  children: [
                    // Birth Date Field
                    Expanded(
                      child: InkWell(
                        onTap: _pickDate,
                        child: InputDecorator(
                          decoration: InputDecoration(
                            labelText: 'Tanggal Lahir',
                            labelStyle: labelStyleTheme,
                            hintText: 'dd/mm/yyyy',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: const BorderSide(color: Color(0xFF01AAE8)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: const BorderSide(color: Color(0xFF01AAE8)),
                            ),
                          ),
                          child: Text(
                            _selectedDate == null
                                ? 'yyy-MM-dd'
                                : DateFormat('yyyy-MM-dd').format(_selectedDate!),
                            style: labelStyleTheme,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Gender Choice Field
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: 'Jenis Kelamin',
                          labelStyle: labelStyleTheme,
                          hintText: 'Pria/Wanita',
                          hintStyle: hintStyleTheme,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: const BorderSide(color: Color(0xFF01AAE8)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: const BorderSide(color: Color(0xFF01AAE8)),
                          ),
                        ),
                        value: _selectedGender,
                        items: [
                          DropdownMenuItem(
                            value: 'Pria',
                            child: Text(
                              'Pria',
                              style: hintStyleTheme,
                            ),
                          ),
                          DropdownMenuItem(
                            value: 'Wanita',
                            child: Text(
                              'Wanita',
                              style: hintStyleTheme,
                            ),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedGender = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Register Button
                ElevatedButton(
                  onPressed: () async {
                    // TODO: Register logic
                    String username = _usernameController.text;
                    String password1 = _passwordController.text;
                    String password2 = _confirmPasswordController.text;
                    String firstName = _firstNameController.text;
                    String lastName = _lastNameController.text;
                    String birthDate = '';
                    if (_selectedDate != null) {
                      birthDate = DateFormat('yyyy-MM-dd').format(_selectedDate!);
                    }
                    String gender = _selectedGender ?? '';

                    final response = await request.postJson(
                      Endpoints.register,
                      jsonEncode({
                        "username": username,
                        "password1": password1,
                        "password2": password2,
                        "first_name": firstName,
                        "last_name": lastName,
                        "birth_date": birthDate,
                        "gender": gender,
                      }));
                    
                    if (context.mounted) {
                      if (response['status'] == 'success') {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Successfully registered!'),
                          ),
                        );
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginPage()),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(response['message'] ?? 'Failed to register!'),
                          ),
                        );
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: BaseColors.blue1,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: Text(
                    'Register',
                    style: FontTheme.raleway16w500white(),
                  ),
                ),
                const SizedBox(height: 16),
                // Sign Up
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Sudah punya akun?",
                      style: FontTheme.raleway14w500black(),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginApp()),
                        );
                      },
                      child: Text(
                        'Sign In',
                        style: FontTheme.raleway14w500blue1(),
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
