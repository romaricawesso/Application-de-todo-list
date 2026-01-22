import 'package:flutter/material.dart';

class ListeNotesPage extends StatelessWidget {
  const ListeNotesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 5, 
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.all(8.0),
          child: ListTile(
            leading: const Icon(Icons.note, color: Colors.blue),
            title: Text('Note ${index + 1}'), 
            subtitle: Text('Cette note est un exemple.'), 
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.grey), 
                  onPressed: () {
                    _showEditNoteDialog(context, index);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red), 
                  onPressed: () {
                    _deleteNoteDialog(context, index);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }


  Future<void> _showEditNoteDialog(BuildContext context, int index) async {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  // Charger les valeurs existantes pour le titre et la description
  _titleController.text = "Note ${index + 1}";
  _descriptionController.text = "Description ${index + 1}";

  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Modifier la note'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              // Champ : Modifier le titre de la note
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Titre',
                  hintText: 'Entrez le nouveau titre',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              
              // Champ : Modifier la description de la note
              TextFormField(
                controller: _descriptionController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  hintText: 'Entrez la description mise à jour',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          // Bouton Annuler
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Fermer la boîte de dialogue
            },
            child: const Text('Annuler', style: TextStyle(color: Colors.red)),
          ),
          // Bouton Enregistrer
          TextButton(
            onPressed: () {
              String updatedTitle = _titleController.text;
              String updatedDescription = _descriptionController.text;

              if (updatedTitle.isNotEmpty && updatedDescription.isNotEmpty) {
                // Met à jour la note avec le titre et la description
                // TODO : Implémente la logique pour sauvegarder les modifications

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Note mise à jour avec succès !'),
                    backgroundColor: Colors.green,
                  ),
                );
                Navigator.of(context).pop(); // Fermer la boîte de dialogue
              } else {
                // Message d'erreur si les champs sont vides
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Les champs ne peuvent pas être vides'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: const Text('Enregistrer'),
          ),
        ],
      );
    },
  );
}

  Future<void> _deleteNoteDialog(BuildContext context, int index) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Supprimer la note'),
          content: Text('Voulez-vous vraiment supprimer cette note ?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); 
              },
              child: const Text('Non'),
            ),
            TextButton(
              onPressed: () {
                print('Note $index supprimée');
                Navigator.of(context).pop(); 
              },
              child: const Text('Oui'),
            ),
          ],
        );
      },
    );
  }
}