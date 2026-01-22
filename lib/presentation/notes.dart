import 'package:flutter/material.dart';
import 'package:projetfinal/presentation/widget/ajoutpagenote.dart';
import 'package:projetfinal/presentation/widget/listepagenote.dart';

class MesNotesPage extends StatefulWidget {
  const MesNotesPage({super.key});

  @override
  _MesNotesPageState createState() => _MesNotesPageState();
}

class _MesNotesPageState extends State<MesNotesPage> {
  int _selectedIndex = 0; 
  static const List<Widget> _pages = <Widget>[
    ListeNotesPage(), 
    AjouterNotePage(), 
  ];


  static const List<String> _pageTitles = <String>[
    'Liste des Notes',
    'Ajouter une Note',
  ];


  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(_pageTitles[_selectedIndex]),
        centerTitle: true,
      ),
      body: _pages.elementAt(_selectedIndex), 
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color.fromARGB(255, 217, 227, 231),
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue, 
        unselectedItemColor: Colors.grey, 
        onTap: _onItemTapped, 
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Liste des Notes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle),
            label: 'Ajouter',
          ),
        ],
      ),
    );
  }
}