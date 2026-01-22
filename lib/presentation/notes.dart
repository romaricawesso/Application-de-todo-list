import 'package:flutter/material.dart';

class MesNotesPage extends StatefulWidget {
  const MesNotesPage({super.key});

  @override
  State<MesNotesPage> createState() => _MesNotesPageState();
}

class _MesNotesPageState extends State<MesNotesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: const Text(
          'Mes Notes',
        ),
      ),
      body: const Center(
        child: Text(
          'Bienvenue sur Mes Notes',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}