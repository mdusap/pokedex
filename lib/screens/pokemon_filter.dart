import 'package:flutter/material.dart';

class PokemonFilterScreen extends StatelessWidget {
  const PokemonFilterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Filtrar'),
        
      ),
      body: const Center(
        child: Text('This is Screen 2'),
      ),
    );
  }
}
