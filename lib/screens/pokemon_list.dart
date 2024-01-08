import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pokedex/data/pokemon.dart';
import 'package:pokedex/widgets/pokemon_card.dart';

class PokemonListScreen extends StatelessWidget {
  const PokemonListScreen({super.key});

  Future<List<Pokemon>> loadPokemonData() async {
    final String jsonString =
        await rootBundle.loadString('lib/data/pokemon.json');
    final List<dynamic> jsonList = json.decode(jsonString);

    return jsonList.map((json) => Pokemon.fromJson(json)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 228, 227, 227),
      appBar: AppBar(
        title: const Text('Pokèdex', style: TextStyle(fontWeight: FontWeight.bold),),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 228, 227, 227),
      ),
      body: FutureBuilder<List<Pokemon>>(
        future: loadPokemonData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<Pokemon> pokemonList = snapshot.data!;
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
              ),
              itemCount: pokemonList.length,
              itemBuilder: (context, index) {
                Pokemon pokemon = pokemonList[index];
                return PokemonCard(pokemon: pokemon);
              },
            );
          }
        },
      ),
    );
  }
}
