import 'package:flutter/material.dart';
import 'package:tp4/modeles/evenement.dart';
import 'package:tp4/services/gestion_firestore.dart';

class DialogueEvenement extends StatefulWidget {
  final Evenement? evenement;

  const DialogueEvenement({super.key, this.evenement});

  @override
  State<DialogueEvenement> createState() => _DialogueEvenementState();
}

class _DialogueEvenementState extends State<DialogueEvenement> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _dateController = TextEditingController();
  final _heureDebutController = TextEditingController();
  final _heureFinController = TextEditingController();
  final _animateurController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.evenement != null) {
      _descriptionController.text = widget.evenement!.description;
      _dateController.text = widget.evenement!.date;
      _heureDebutController.text = widget.evenement!.heureDebut;
      _heureFinController.text = widget.evenement!.heureFin;
      _animateurController.text = widget.evenement!.animateur;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.evenement == null ? 'Ajouter un événement' : 'Modifier un événement'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer une description';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _dateController,
                decoration: const InputDecoration(labelText: 'Date (AAAA-MM-JJ)'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer une date';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _heureDebutController,
                decoration: const InputDecoration(labelText: 'Heure de début (HH:MM)'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer une heure de début';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _heureFinController,
                decoration: const InputDecoration(labelText: 'Heure de fin (HH:MM)'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer une heure de fin';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _animateurController,
                decoration: const InputDecoration(labelText: 'Animateur'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un animateur';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Annuler'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text(widget.evenement == null ? 'Ajouter' : 'Modifier'),
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              final evenementModifie = Evenement(
                id: widget.evenement?.id,
                description: _descriptionController.text,
                date: _dateController.text,
                heureDebut: _heureDebutController.text,
                heureFin: _heureFinController.text,
                animateur: _animateurController.text,
                estFavori: widget.evenement?.estFavori ?? false,
              );

              if (widget.evenement == null) {
                await GestionFirestore.ajouterEvenement(evenementModifie);
              } else {
                await GestionFirestore.modifierEvenementDansFirebase(evenementModifie);
              }

              if (mounted) {
                Navigator.of(context).pop(true);
              }
            }
          },
        ),
      ],
    );
  }
}