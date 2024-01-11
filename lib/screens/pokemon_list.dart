import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pokedex/data/pokemon.dart';
import 'package:pokedex/screens/pokemon_detail.dart';
import 'package:pokedex/screens/pokemon_filter.dart';
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
  late List<Pokemon> displayedPokemons = [];

  @override
  void initState() {
    super.initState();
    _loadPokemonData().then((pokemonList) {
      setState(() {
        pokemons = pokemonList;
        displayedPokemons = pokemons;
      });
    });
  }

  // Retrieving pokemon data from json to display it
  Future<List<Pokemon>> _loadPokemonData() async {
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
  void _searchPokemons(String query) {
    query = query.replaceAll(' ', '');
    setState(() {
      displayedPokemons = pokemons
          .where((pokemon) =>
              pokemon.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  // Navigate to detail pokemon screen
  void _navigateToDetailScreen(Pokemon pokemon) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PokemonDetailScreen(pokemon: pokemon),
      ),
    );
  }

  // Navigate to filter screen
  void _navigateToFilterScreen() async {
    final Set<String>? selectedTypes = await Navigator.push<Set<String>?>(
      context,
      MaterialPageRoute(builder: (context) => const PokemonFilterScreen()),
    );
    if (selectedTypes != null) {
      _applyFilters(selectedTypes);
    }
  }

  // Apply type filter to displayedPokemons
  void _applyFilters(Set<String> selectedTypes) {
    setState(() {
      if (selectedTypes.isNotEmpty) {
        displayedPokemons = pokemons
            .where((pokemon) =>
                pokemon.type.isNotEmpty &&
                selectedTypes.contains(pokemon.type.toLowerCase()))
            .toList();
      } else {
        displayedPokemons = pokemons;
      }
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
                'Pokédex',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              centerTitle: true,
              backgroundColor: const Color.fromARGB(255, 228, 227, 227),
              actions: [
                IconButton(
                  icon: const Icon(
                    Icons.tune,
                    size: 24.0,
                    color: Color.fromARGB(255, 53, 123, 242),
                  ),
                  onPressed: _navigateToFilterScreen,
                ),
              ],
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
                    padding:
                        EdgeInsets.only(top: 8, left: 8, bottom: 8, right: 20),
                    child: Icon(
                      Icons.search,
                      size: 24.0,
                      color: Color.fromARGB(255, 160, 160, 160),
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      onChanged: _searchPokemons,
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
                return GestureDetector(
                  onTap: () {
                    _navigateToDetailScreen(pokemon);
                  },
                  child: PokemonCard(pokemon: pokemon),
                );
              },
            ),
    );
  }
}
