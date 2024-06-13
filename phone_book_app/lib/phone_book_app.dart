import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
      title: 'Phone Book App',
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(3, 148, 222, 1),
          title: const Text(
            'Phone Book App',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          actions: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.search,
                color: Colors.white,
              ),
              onPressed: () {
                // Action à effectuer lors du clic sur l'icône de recherche
              },
            ),
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: IconButton(
                  icon: const Icon(
                    Icons.sort_by_alpha,
                    color: Colors.white,
                  ),
                  onPressed: () {}),
            ),
          ],
        ),
        body: const EntreeMaster(),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
