import 'package:flutter/material.dart';
import 'package:app_clubess/views/homepage.dart';
import 'package:app_clubess/views/loginpage.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Inicializar App
void main() {
  runApp(const AppClubes());
}

// Clase Clubes
class AppClubes extends StatelessWidget {
  const AppClubes({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Clubes',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // Token Login
      home: FutureBuilder<bool>(
        future: _checkLoginStatus(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data == true) {
              return Homepage();
            } else {
              return const PageStart();
            }
          }
          return const CircularProgressIndicator();
        },
      ),
    );
  }

  Future<bool> _checkLoginStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }
}

// Page Init
class PageStart extends StatelessWidget {
  const PageStart({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(height: 110),
              const Text(
                'Clubes ASD',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 35,
                    fontFamily: 'Montserrat'),
              ),
              const SizedBox(height: 100),
              SizedBox(
                height: 180,
                child: Image.asset('assets/Clubes.png'),
              ),
              const SizedBox(height: 100),
              ElevatedButton(
                child: const Text(
                  'Iniciar',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 27,
                    fontFamily: 'Montserrat',
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  primary: const Color.fromARGB(255, 255, 187, 14),
                  onPrimary: const Color.fromARGB(255, 9, 9, 9),
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 70, vertical: 20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
