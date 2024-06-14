import 'package:flutter/material.dart';
import 'package:phone_book_app/screens/entree_master.dart';

class PhoneBookApp extends StatefulWidget {
  const PhoneBookApp({super.key});

  @override
  State<PhoneBookApp> createState() => _PhoneBookAppState();
}

class _PhoneBookAppState extends State<PhoneBookApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // ! Titre de l'application
      title: 'Phone Book App',
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(3, 148, 222, 1),
          title: const Text(
            'Phone Book App',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          
         
        ),
        body: const EntreeMaster(),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
  
}
