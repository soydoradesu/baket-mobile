import 'package:baket_mobile/core/constants/_constants.dart';
import 'package:baket_mobile/features/auth/pages/login.dart';
import 'package:baket_mobile/navbar.dart';
import 'package:baket_mobile/services/pref_service.dart';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class AppWrapper extends StatefulWidget {
  const AppWrapper({super.key});

  @override
  State<AppWrapper> createState() => _AppWrapperState();
}

class _AppWrapperState extends State<AppWrapper> {
  Future<Widget> checkLogin() async {
    try {
      final request = context.watch<CookieRequest>();

      final username = PrefService.getString('username');
      final password = PrefService.getString('password');

      if (username == null || password == null) {
        return const LoginApp();
      }

      await request.login(
        Endpoints.login,
        {
          'username': username,
          'password': password,
        },
      );

      if (request.loggedIn) {
        return const NavigationMenu();
      } else {
        return const LoginApp();
      }
    } catch (e) {
      return const LoginApp();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: checkLogin(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return snapshot.data ??
              Scaffold(
                body: Center(
                  child: Image.asset(
                    Assets.svg.logoPanjang,
                  ),
                ),
              );
        }

        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
