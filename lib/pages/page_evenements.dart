import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tp4/services/gestion_firestore.dart';
import 'package:tp4/modeles/evenement.dart';
import '../widgets/dialogue_evenement.dart'; // Importez le nouveau fichier

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

  void _afficherDialogueAjoutEvenement() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return const DialogueEvenement();
      },
    );

    if (result == true) {
      // Si l'événement a été ajouté, rechargez la liste des événements
      setState(() {
        _evenementsFuture = _chargerEvenements();
      });
    }
  }

  void _afficherDialogueModificationEvenement(Evenement evenement) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return DialogueEvenement(evenement: evenement);
      },
    );

    if (result == true) {
      setState(() {
        _evenementsFuture = _chargerEvenements();
      });
    }
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
          // ... (votre code existant pour la gestion des états de FutureBuilder)
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
            print('Snapshot: ${snapshot}');
            print('Erreur lors de la récupération des données: ${snapshot.error}');
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
              return Dismissible(
                key: Key(evenement.id ?? index.toString()), // Utilisez l'ID de l'événement comme clé
                direction: DismissDirection.endToStart,
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (direction) async {
                  await GestionFirestore.supprimerEvenementDansFirebase(evenement);
                  setState(() {
                    _evenementsFuture = _chargerEvenements();
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Événement supprimé')),
                  );
                },
                child: ListTile(
                  title: Text(evenement.description),
                  subtitle: Text('${evenement.date} • ${evenement.heureDebut} - ${evenement.heureFin}'),
                  trailing: IconButton(
                    icon: Icon(
                      evenement.estFavori ? Icons.star : Icons.star_border,
                      color: evenement.estFavori ? Colors.amber : Colors.grey,
                    ),
                    onPressed: () => _basculerEtatFavori(evenement),
                  ),
                  onLongPress: () {
                    _afficherDialogueModificationEvenement(evenement);
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _afficherDialogueAjoutEvenement,
        child: const Icon(Icons.add),
      ),
    );
  }
}