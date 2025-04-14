class Evenement {
  String? id;
  late String _description;
  late String _date;
  late String _heureDebut;
  late String _heureFin;
  late String _animateur;
  late bool _estFavori;

  // 🔒 Constantes pour Firestore
  static const String collectionName = 'evenements';
  static const String fieldDescription = 'description';
  static const String fieldDate = 'date';
  static const String fieldHeureDebut = 'heureDebut';
  static const String fieldHeureFin = 'heureFin';
  static const String fieldAnimateur = 'animateur';
  static const String fieldEstFavori = 'estFavori';

  // ✅ Constructeur principal
  Evenement({
    this.id,
    required String description,
    required String date,
    required String heureDebut,
    required String heureFin,
    required String animateur,
    required bool estFavori,
  })  : _description = description,
        _date = date,
        _heureDebut = heureDebut,
        _heureFin = heureFin,
        _animateur = animateur,
        _estFavori = estFavori;

  // 📥 Constructeur nommé fromMap
  factory Evenement.fromMap(Map<String, dynamic> map, {String? id}) {
    return Evenement(
      id: id,
      description: map[fieldDescription],
      date: map[fieldDate],
      heureDebut: map[fieldHeureDebut],
      heureFin: map[fieldHeureFin],
      animateur: map[fieldAnimateur],
      estFavori: map[fieldEstFavori] ?? false,
    );
  }

  // 📤 Méthode toMap
  Map<String, dynamic> toMap() {
    return {
      fieldDescription: _description,
      fieldDate: _date,
      fieldHeureDebut: _heureDebut,
      fieldHeureFin: _heureFin,
      fieldAnimateur: _animateur,
      fieldEstFavori: _estFavori,
    };
  }

  // 🧾 Getters
  String get description => _description;
  String get date => _date;
  String get heureDebut => _heureDebut;
  String get heureFin => _heureFin;
  String get animateur => _animateur;
  bool get estFavori => _estFavori;

  // ✏️ Setters (si tu veux permettre les modifications)
  set description(String value) => _description = value;
  set date(String value) => _date = value;
  set heureDebut(String value) => _heureDebut = value;
  set heureFin(String value) => _heureFin = value;
  set animateur(String value) => _animateur = value;
  set estFavori(bool value) => _estFavori = value;
}
