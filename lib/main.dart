import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; 
import 'package:superbank/screens/splashscreen.dart';




void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if(kIsWeb) {
  await Firebase.initializeApp(
    options:  const FirebaseOptions(
              apiKey: "AIzaSyDQs7v9FNZ_FMBQVH5FYHAGXjDK9e95dwY",
              authDomain: "superbank-20.firebaseapp.com",
              projectId: "superbank-20",
              storageBucket: "superbank-20.firebasestorage.app",
              messagingSenderId: "698853456796",
              appId: "1:698853456796:web:522529b1fb7d8324762659",
    
  ));
  } else {
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SuperBank Services',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home:  const Splashscreen(), // Use the Splashscreen widget as the home
      debugShowCheckedModeBanner: false,
    );
  }
}
  @override
  Widget buildNormalIcons() => GridView(
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 4,
    childAspectRatio: 1.0,
    mainAxisSpacing: 8.0,
    crossAxisSpacing: 8.0,
    ),
    children: [
      Icon(Icons.home, size: 50),
      Icon(Icons.search, size: 50),
      Icon(Icons.notifications, size: 50),
      Icon(Icons.settings, size: 50),
      Icon(Icons.add_card, size: 50),
      Icon(Icons.account_balance, size: 50),
      Icon(Icons.history, size: 50),
      Icon(Icons.help, size: 50),
      Icon(Icons.contact_support, size: 50),
    ],

  );
   