import 'package:flutter/material.dart';
import 'package:projetfinal/data/datahelper.dart';
import 'package:projetfinal/models/note.dart';

class ListeNotesPage extends StatefulWidget {
  const ListeNotesPage({super.key});

  @override
  State<ListeNotesPage> createState() => _ListeNotesPageState();
}

class _ListeNotesPageState extends State<ListeNotesPage> {
  late Future<List<Note>> _notesFuture;

  @override
  void initState() {
    super.initState();
    _loadNotes(); 
  }

  void _loadNotes() {
    _notesFuture = DatabaseHelper.instance.fetchNotes(); 
  }

  Future<void> _refreshNotes() async {
    setState(() {
      _loadNotes(); 
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Note>>(
        future: _notesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text("Erreur lors du chargement des notes."),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text("Vous n'avez pas encore ajouté de notes."),
            );
          }

          final notes = snapshot.data!;
          return ListView.builder(
            itemCount: notes.length,
            itemBuilder: (context, index) {
              final note = notes[index];
              return Card(
                margin: const EdgeInsets.all(8.0),
                child: ListTile(
                  leading: const Icon(Icons.note, color: Colors.blue),
                  title: Text(note.title), 
                  subtitle: Text(
                    note.description, 
                    maxLines: 2, 
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.grey),
                        onPressed: () {
                          _showEditNoteDialog(context, note);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          _deleteNoteDialog(note);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _showEditNoteDialog(BuildContext context, Note note) async {
    final TextEditingController _titleController =
        TextEditingController(text: note.title);
    final TextEditingController _descriptionController =
        TextEditingController(text: note.description);

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Modifier la note'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Titre',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Annuler', style: TextStyle(color: Colors.red)),
            ),
            TextButton(
              onPressed: () async {
                final updatedTitle = _titleController.text.trim();
                final updatedDescription = _descriptionController.text.trim();

                if (updatedTitle.isNotEmpty && updatedDescription.isNotEmpty) {
                  // Mise à jour de la note
                  final updatedNote = Note(
                    id: note.id,
                    title: updatedTitle,
                    description: updatedDescription,
                  );
                  await DatabaseHelper.instance.updateNote(updatedNote);
                  Navigator.of(context).pop();

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Note mise à jour avec succès !'),
                      backgroundColor: Colors.green,
                    ),
                  );

                  _refreshNotes(); 
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Les champs ne peuvent pas être vides."),
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

  Future<void> _deleteNoteDialog(Note note) async {
  if (note.id == null) return; 

  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Supprimer la note'),
        content: const Text('Voulez-vous vraiment supprimer cette note ?'),
        actions: <Widget>[
          // Bouton "Annuler"
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Annuler',
              style: TextStyle(color: Colors.red),
            ),
          ),
          
          // Bouton "Supprimer"
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop(); 
              await DatabaseHelper.instance.deleteNote(note.id!);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Note supprimée avec succès !'),
                  backgroundColor: Colors.green,
                ),
              );
              await _refreshNotes(); 
            },
            child: const Text(
              'Supprimer',
              style: TextStyle(color: Colors.blue),
            ),
          ),
        ],
      );
    },
  );
}
}