import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tp4/modeles/evenement.dart';

class GestionFirestore {
  static final FirebaseFirestore bdd = FirebaseFirestore.instance;
  static const String COLLECTION_EVENEMENT = 'details_evenement';

  // 🔍 Méthode de test pour imprimer les IDs des documents
  Future<void> testDonnees() async {
    var donnees = await bdd.collection(COLLECTION_EVENEMENT).get();
    for (var detail in donnees.docs) {
      print('===> ID : ${detail.id}');
    }
  }

  // 📥 Récupération des données Firestore
  static Future<QuerySnapshot> chargerDonneesDepuisFirebase() async {
    return await bdd.collection(COLLECTION_EVENEMENT).get();
  }

  // 🔁 Transformation des données Firestore en objets Evenement
  static List<Evenement> lireListeEvenements(QuerySnapshot snapshot) {
    print('===> Lecture des données Firestore'); print(snapshot.docs);
    return snapshot.docs
        .map((doc) => Evenement.fromMap(doc.data() as Map<String, dynamic>, id: doc.id))
        .toList();
  }

  static Future ajouterEvenement(Evenement evenement) {
    return bdd
        .collection(COLLECTION_EVENEMENT)
        .add(evenement.toMap())
        .then((valeur) => print(valeur))
        .catchError((error) => print(error));
  }

  static Future modifierEvenementDansFirebase(Evenement evenement) {
     return bdd
        .collection(COLLECTION_EVENEMENT)
        .doc(evenement.id)
        .update(evenement.toMap());
  }

  static supprimerEvenementDansFirebase(Evenement evenement) {
    return bdd
        .collection(COLLECTION_EVENEMENT)
        .doc(evenement.id)
        .delete();
  }
}
