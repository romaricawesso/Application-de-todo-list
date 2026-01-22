import 'package:flutter/material.dart';
import 'package:projetfinal/presentation/incription.dart';
import 'package:projetfinal/presentation/notes.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _login() {
    // Ici on pourrait vérifier les identifiants
    final email = _emailController.text;
    final password = _passwordController.text;

    if (email == 'Daniel' && password == 'password') {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Connexion réussie !'),
        backgroundColor: Colors.green,
      ),
    );
    // Rediriger vers la page "Mes Notes"
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MesNotesPage()),
    );
  } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("L'email ou mot de passe incorrect !")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Connexion',
        ),
        backgroundColor: Colors.blue, 
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
          child: Center( 
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center, 
            children: [
              ClipOval(
                child: const Image(
                  image: AssetImage('assets/images/note.jpg'),
                  height: 170,
                  width: 170,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 24),

              // Champ 1 : E-mail
              SizedBox(
                width: 280, 
                child: TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress, 
                  decoration: const InputDecoration(
                    labelText: 'E-mail',
                    border: OutlineInputBorder(), 
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer votre e-mail';
                    }
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(value)) {
                      return 'Veuillez entrer une adresse e-mail valide';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 16),

              // Champ 2 : Mot de passe
              SizedBox(
                width: 280, 
                child: TextFormField(
                  controller: _passwordController,
                  obscureText: true, 
                  decoration: const InputDecoration(
                    labelText: 'Mot de passe',
                    border: OutlineInputBorder(), 
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer votre mot de passe';
                    }
                    if (value.length < 6) {
                      return 'Le mot de passe doit contenir au moins 6 caractères';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 24),

              // Bouton Connexion
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  onPressed: _login, 
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue, 
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12), 
                    ),
                  ),
                  child: const Text(
                    'Connexion',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold, 
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Lien pour revenir à l'inscription
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SignupPage(), 
                    ),
                  );
                },
                child: const Text(
                  'Pas encore inscrit ? Créez un compte',
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 16,
                    decoration: TextDecoration.underline, 
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}