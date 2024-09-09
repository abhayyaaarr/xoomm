import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:xoomm/resources/auth_method.dart';
import 'package:xoomm/screens/home_screen.dart';
import 'package:xoomm/screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Xoomm',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color.fromARGB(255, 45, 45, 45),
      ),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
      },
      home: StreamBuilder(
        stream: AuthMethods().authChanges,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            print('Waiting for auth state...');
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            print('Error in auth stream: ${snapshot.error}');
            return Center(child: Text('An error occurred: ${snapshot.error}'));
          }

          if (snapshot.hasData && snapshot.data != null) {
            print('User is signed in: ${snapshot.data!.uid}');
            return const HomeScreen();
          } else {
            print('User is signed out');
            return const HomeScreen(); // Assuming you have a LoginScreen
          }
        },
      ),
    );
  }
}
