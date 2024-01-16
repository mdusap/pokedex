import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pokedex/data/pokemon.dart';
import 'package:pokedex/helpers/shared_preferences_manager.dart';
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

  SharedPreferencesManager prefsManager = SharedPreferencesManager();

  @override
  void initState() {
    super.initState();
    _loadPokemonData();
  }

  // Get the pokemon data from the json and isFavorite
  void _loadPokemonData() {
    rootBundle.loadString('lib/data/pokemon.json').then((jsonString) {
      final List<dynamic> jsonList = json.decode(jsonString);
      List<Pokemon> pokemonList = jsonList.map((json) {
        Pokemon pokemon = Pokemon.fromJson(json);
        final key = 'favorite_${pokemon.index}';
        pokemon.isFavorite = prefsManager.getBool(key);
        return pokemon;
      }).toList();
      pokemonList.sort((a, b) => a.index.compareTo(b.index));

      setState(() {
        pokemons = pokemonList;
        displayedPokemons = pokemons;
      });
    });
  }

  // Search pokemon method
  void _filterPokemons(String query) {
    query = query.replaceAll(' ', '');
    setState(() {
      displayedPokemons = pokemons
          .where((pokemon) =>
              pokemon.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  // Navigate to detail pokemon screen
  void _navigateToDetailScreen(Pokemon pokemon) async {
    await Navigator.push<bool?>(
      context,
      MaterialPageRoute(
        builder: (context) => PokemonDetailScreen(pokemon: pokemon),
      ),
    );
  }

  // Navigate to filter screen
  void _navigateToFilterScreen() async {
    final Map<String, List<String>>? filters =
        await Navigator.push<Map<String, List<String>>?>(
      context,
      MaterialPageRoute(builder: (context) => const PokemonFilterScreen()),
    );
    if (filters != null) {
      _applyFilters(filters);
    }
  }

  // Apply filters 
  void _applyFilters(Map<String, List<String>> filters) {
    setState(() {
      final List<String> selectedTypes = filters['selectedTypes'] ?? [];
      final List<String> selectedFavorites = filters['selectedFavorites'] ?? [];
      final List<String> selectedWeights = filters['selectedWeights'] ?? [];

      if (selectedTypes.isNotEmpty ||
          selectedFavorites.isNotEmpty ||
          selectedWeights.isNotEmpty) {
        displayedPokemons = pokemons.where((pokemon) {
          final condition = selectedTypes.isEmpty ||
              (pokemon.type.isNotEmpty &&
                  selectedTypes.contains(pokemon.type.toLowerCase()));

          final favoritesCondition = selectedFavorites.isEmpty ||
              (selectedFavorites.contains('favorites') && pokemon.isFavorite) ||
              (selectedFavorites.contains('all'));

          final weightCondition = _checkWeightRange(
            pokemon.weight,
            selectedWeights,
          );

          return condition && favoritesCondition && weightCondition;
        }).toList();
      } else {
        displayedPokemons = pokemons;
      }
    });
  }

  // Check weight method
  bool _checkWeightRange(double weight, List<String> selectedWeights) {
    if (selectedWeights.isEmpty) {
      return true;
    }

    for (String range in selectedWeights) {
      switch (range.toLowerCase()) {
        case '100 o superior':
          if (weight >= 100.0) {
            return true;
          }
          break;
        case '75-100 kg':
          if (weight >= 75.0 && weight < 100.0) {
            return true;
          }
          break;
        case '35-75 kg':
          if (weight >= 35.0 && weight < 75.0) {
            return true;
          }
          break;
        case '10-35 kg':
          if (weight >= 10.0 && weight < 35.0) {
            return true;
          }
          break;
        case '0-10 kg':
          if (weight >= 0.0 && weight < 10.0) {
            return true;
          }
          break;
      }
    }

    return false;
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
                      onChanged: _filterPokemons,
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
