import 'package:flutter/material.dart';
import 'package:pokedex/data/pokemon.dart';

class PokemonCard extends StatelessWidget {
  const PokemonCard({super.key, required this.pokemon});

  final Pokemon pokemon;

  @override
  Widget build(BuildContext context) {

    String capitalize(String s) {
      if (s.isEmpty) {
        return '';
      }
      return s[0].toUpperCase() + s.substring(1);
    }

    return Padding(
      padding: const EdgeInsets.all(8),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
              color: const Color.fromARGB(255, 99, 98, 98), width: 1.5),
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Card(
          margin: const EdgeInsets.all(0),
          elevation: 0.0,
          color: Colors.white,
          child: ListView(
            children: [
              Column(
                children: [
                  Image.network(pokemon.image, height: 80.0),
                  Text(
                   capitalize(pokemon.name),
                   style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
