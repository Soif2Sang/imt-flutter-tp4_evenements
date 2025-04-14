import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tp4/gestion_firestore.dart';
import 'package:tp4/evenement.dart';

class PageEvenements extends StatefulWidget {
  final String uid;

  const PageEvenements({super.key, required this.uid});

  @override
  State<PageEvenements> createState() => _PageEvenementsState();
}

class _PageEvenementsState extends State<PageEvenements> {
  late Future<List<Evenement>> _evenementsFuture;

  @override
  void initState() {
    super.initState();
    _evenementsFuture = _chargerEvenements();
  }

  Future<List<Evenement>> _chargerEvenements() async {
    return await GestionFirestore.lireListeEvenements(
      await GestionFirestore.chargerDonneesDepuisFirebase(),
    );
  }

  void _basculerEtatFavori(Evenement evenement) async {
    setState(() {
      evenement.estFavori = !evenement.estFavori;
    });

    await GestionFirestore.modifierEvenementDansFirebase(evenement);
  }

  void _deconnexion() async {
    await FirebaseAuth.instance.signOut();
    if (!mounted) return;
    Navigator.of(context).pushReplacementNamed('/connexion');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes événements à venir'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Déconnexion',
            onPressed: _deconnexion,
          ),
        ],
      ),
      body: FutureBuilder<List<Evenement>>(
        future: _evenementsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text(
                    'Récupération des données en cours...',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text(
                'Erreur lors de la récupération des données.',
                style: TextStyle(color: Colors.red, fontSize: 18),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'Aucun événement trouvé.',
                style: TextStyle(color: Colors.grey, fontSize: 18),
              ),
            );
          }

          final evenements = snapshot.data!;

          return ListView.builder(
            itemCount: evenements.length,
            itemBuilder: (context, index) {
              final evenement = evenements[index];
              return ListTile(
                title: Text(evenement.description),
                subtitle: Text('${evenement.date} • ${evenement.heureDebut} - ${evenement.heureFin}'),
                trailing: IconButton(
                  icon: Icon(
                    evenement.estFavori ? Icons.star : Icons.star_border,
                    color: evenement.estFavori ? Colors.amber : Colors.grey,
                  ),
                  onPressed: () => _basculerEtatFavori(evenement),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
