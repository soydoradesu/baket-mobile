import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    
    return MaterialApp(
      title: "BaKet",
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                child: const Text('Beranda'),
                onPressed: () {},
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                ),
              ElevatedButton(
                child: const Text('Katalog'),
                onPressed: () {},
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                ),
              ElevatedButton(
                child: const Text('Forum'),
                onPressed: () {},
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                ),
              ElevatedButton(
                child: const Text('Artikel'),
                onPressed: () {},
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                ),
              ElevatedButton(
                child: const Text('Profile'),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );

  }
}