import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'page_connexion.dart';  // Importez votre page de connexion
import 'page_evenements.dart';  // Importez votre page des événements

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Application',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: _determineHomePage(),
    );
  }

  // Vérifie si un utilisateur est connecté ou non et redirige en conséquence
  Widget _determineHomePage() {
    // Vérifiez si l'utilisateur est connecté
    print(FirebaseAuth.instance);
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Si l'utilisateur est connecté, on le redirige vers la page des événements
      return PageEvenements(uid: user.uid);
    } else {
      // Si l'utilisateur n'est pas connecté, on le redirige vers la page de connexion
      return const PageConnexion();
    }
  }
}
