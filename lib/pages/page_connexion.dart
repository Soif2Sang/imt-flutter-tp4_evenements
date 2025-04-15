import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'page_evenements.dart'; // Assurez-vous de remplacer cela par le bon chemin de votre page des événements

class PageConnexion extends StatefulWidget {
  const PageConnexion({Key? key}) : super(key: key);

  @override
  State<PageConnexion> createState() => _PageConnexionState();
}

class _PageConnexionState extends State<PageConnexion> {
  // Variables d'état
  String? _idUtilisateur;
  String? _mdpUtilisateur;
  String? _emailUtilisateur;
  bool _estConnectable = true;  // True pour connexion, False pour inscription
  String? _message;

  // Contrôleurs de texte pour email et mot de passe
  final TextEditingController txtEmail = TextEditingController();
  final TextEditingController txtMdp = TextEditingController();

  // Clé du formulaire pour valider les champs
  final _formKey = GlobalKey<FormState>();

  // Méthode pour saisir l'email
  Widget saisirEmail() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: TextFormField(
        controller: txtEmail,
        decoration: const InputDecoration(
          hintText: 'Adresse mail',
          icon: Icon(Icons.mail),
        ),
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Veuillez entrer votre adresse mail';
          }
          return null;
        },
      ),
    );
  }

  // Méthode pour saisir le mot de passe
  Widget saisirMotDePasse() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: TextFormField(
        controller: txtMdp,
        obscureText: true,
        decoration: const InputDecoration(
          hintText: 'Mot de passe',
          icon: Icon(Icons.lock),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Veuillez entrer votre mot de passe';
          }
          return null;
        },
      ),
    );
  }

  // Méthode pour soumettre le formulaire (connexion ou inscription)
  Future soumettre() async {
    setState(() {
      _message = "";  // Réinitialise le message avant de commencer
    });

    try {
      if (_estConnectable) {
        // Connexion
        _emailUtilisateur = txtEmail.text;
        _mdpUtilisateur = txtMdp.text;
        UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailUtilisateur ?? "",
          password: _mdpUtilisateur ?? "",
        );
        _idUtilisateur = userCredential.user?.uid;
      } else {
        // Inscription
        _emailUtilisateur = txtEmail.text;
        _mdpUtilisateur = txtMdp.text;
        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailUtilisateur ?? "",
          password: _mdpUtilisateur ?? "",
        );
        _idUtilisateur = userCredential.user?.uid;
      }

      if (_idUtilisateur != null) {
        // Redirige vers la page des événements en cas de succès
        // ignore: use_build_context_synchronously
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PageEvenements(uid: _idUtilisateur as String)),
        );
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        _message = e.message;  // Affiche le message d'erreur de Firebase
      });
    }
  }

  // Méthode pour afficher le bouton principal
  Widget boutonPrincipal() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: ElevatedButton(
        onPressed: soumettre,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 3,
        ),
        child: Text(_estConnectable ? 'Se connecter' : 'S\'inscrire'),
      ),
    );
  }

  // Méthode pour afficher le bouton secondaire (connexion/inscription)
  Widget boutonSecondaire() {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: TextButton(
        onPressed: () {
          setState(() {
            _estConnectable = !_estConnectable;
            _message = null;  // Réinitialiser le message
          });
        },
        child: Text(
          _estConnectable
              ? "Pas encore de compte ? Créez-en un"
              : "Déjà un compte ? Connectez-vous",
          style: TextStyle(color: Colors.blue),
        ),
      ),
    );
  }

  // Méthode pour afficher le message d'erreur ou de succès
  Widget messageValidation() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Text(
        _message ?? '',
        style: TextStyle(
          color: _message == null
              ? Colors.transparent
              : (_message!.contains('réussi') ? Colors.green : Colors.red),
          fontSize: 16.0,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Page de Connexion'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'Veuillez vous connecter ou vous inscrire',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30),
                saisirEmail(),
                saisirMotDePasse(),
                boutonPrincipal(),
                boutonSecondaire(),
                messageValidation(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
