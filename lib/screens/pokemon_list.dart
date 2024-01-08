import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pokedex/data/pokemon.dart';
import 'package:pokedex/widgets/pokemon_card.dart';

class PokemonListScreen extends StatefulWidget {
  const PokemonListScreen({Key? key}) : super(key: key);

  @override
  State<PokemonListScreen> createState() {
    return _PokemonListScreenState();
  }
}

class _PokemonListScreenState extends State<PokemonListScreen> {
  late List<Pokemon> pokemons;
  late List<Pokemon> displayedPokemons;

  @override
  void initState() {
    super.initState();
    loadPokemonData().then((pokemonList) {
      setState(() {
        pokemons = pokemonList;
        displayedPokemons = pokemons;
      });
    });
  }

  // Retrieving pokemon data from json to display it
  Future<List<Pokemon>> loadPokemonData() async {
    // Decoding pokemon list
    final String jsonString =
        await rootBundle.loadString('lib/data/pokemon.json');
    final List<dynamic> jsonList = json.decode(jsonString);

    // Pokemon list from json converted to list
    List<Pokemon> pokemonList =
        jsonList.map((json) => Pokemon.fromJson(json)).toList();
    // Sorting the pokemon list 
    pokemonList.sort((a, b) => a.index.compareTo(b.index));

    return pokemonList;
  }

  // Search pokemon method
  void _search(String query) {
    setState(() {
      displayedPokemons = pokemons
          .where((pokemon) =>
              pokemon.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 228, 227, 227),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight + 60),
        child: Column(
          children: [
            AppBar(
              title: const Text(
                'Pokèdex',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              centerTitle: true,
              backgroundColor: const Color.fromARGB(255, 228, 227, 227),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 12.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                color: const Color.fromARGB(255, 216, 216, 216),
              ),
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(7),
                    child: Icon(
                      Icons.search,
                      size: 24.0,
                      color: Color.fromARGB(255, 160, 160, 160),
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      onChanged: _search,
                      decoration: const InputDecoration(
                        hintText: 'Buscar por nombre',
                        hintStyle: TextStyle(fontWeight: FontWeight.w300),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: displayedPokemons.isEmpty
          ? const Center(child: Text('No hay resultados.'))
          : GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
              ),
              itemCount: displayedPokemons.length,
              itemBuilder: (context, index) {
                Pokemon pokemon = displayedPokemons[index];
                return PokemonCard(pokemon: pokemon);
              },
            ),
    );
  }
}
