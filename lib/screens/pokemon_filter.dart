import 'package:flutter/material.dart';
import 'package:pokedex/data/pokemon.dart';
import 'package:pokedex/helpers/shared_preferences_manager.dart';

class PokemonFilterScreen extends StatefulWidget {
  const PokemonFilterScreen({Key? key}) : super(key: key);

  @override
  State<PokemonFilterScreen> createState() {
    return _PokemonFilterScreenState();
  }
}

class _PokemonFilterScreenState extends State<PokemonFilterScreen> {
  late List<Pokemon> pokemonList;

  SharedPreferencesManager prefsManager = SharedPreferencesManager();

  List<String> pokemonTypes = [
    'Fire',
    'Water',
    'Grass',
    'Poison',
    'Bug',
    'Dragon',
    'Ghost'
  ];

  List<String> weightRanges = [
    '0-10 kg',
    '10-35 kg',
    '35-75 kg',
    '75-100 kg',
    '100 o superior'
  ];

  // Using set instead of list to not allow duplicated (When user presses the same item multiple times it gets the same value multiple times and that was an error)
  Set<String> selectedTypes = {};
  Set<String> selectedFavorites = {};
  Set<String> selectedWeights = {};

  @override
  void initState() {
    super.initState();
    _getFilters();
  }

  void _getFilters() {
     selectedTypes = prefsManager.getStringList('selectedTypes')?.toSet() ?? {};
    selectedFavorites = prefsManager.getStringList('selectedFavorites')?.toSet() ?? {};
    selectedWeights = prefsManager.getStringList('selectedWeights')?.toSet() ?? {};
  }

  // Using shared_preferences to save the selected item so when we go back to the filter screen mantain the selected item/s
  Future<Map<String, List<String>>> _saveFilters() async {
    final filters = {
      'selectedTypes': selectedTypes.toList(),
      'selectedFavorites': selectedFavorites.toList(),
      'selectedWeights': selectedWeights.toList(),
    };

    if (selectedTypes.isEmpty) {
      prefsManager.setEmptyStringList('selectedTypes');
    } else {
      prefsManager.setStringList('selectedTypes', selectedTypes.toList());
    }

    if (selectedFavorites.isEmpty) {
      prefsManager.setEmptyStringList('selectedFavorites');
    } else {
      prefsManager.setStringList('selectedFavorites', selectedFavorites.toList());
    }

    if (selectedWeights.isEmpty) {
      prefsManager.setEmptyStringList('selectedWeights');
    } else {
      prefsManager.setStringList('selectedWeights', selectedWeights.toList());
    }

    // Map filters
    return filters;
  }

  @override
  Widget build(context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 228, 227, 227),
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: () async {
              // To send all filters to list screen
              Map<String, List<String>> filters = await _saveFilters();
              Navigator.of(context).pop(filters);
            },
            child: const Text(
              'OK',
              style: TextStyle(color: Colors.blue, fontSize: 20),
            ),
          ),
        ],
        title: const Text(
          'Filtrar elementos',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 228, 227, 227),
        leading: IconButton(
          padding: const EdgeInsets.all(8),
          icon: const Row(
            children: [
              Icon(
                Icons.arrow_back_ios,
                color: Colors.blue,
              ),
            ],
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 15),
                // Favorite pokemons part 
                child: Text(
                  'FAVORITE POKEMONS',
                  style: TextStyle(color: Color.fromARGB(255, 160, 160, 160)),
                ),
              ),
              Card(
                elevation: 3,
                child: Column(
                  children: [
                    _buildNotPredefinedOption('Select Favorites', 'favorites'),
                    _buildNotPredefinedOption('Select All', 'all'),
                  ],
                ),
              ),
              // End favorite pokemons part 
              const SizedBox(
                height: 15,
              ),
              // Select type part 
              const Padding(
                padding: EdgeInsets.only(left: 15),
                child: Text(
                  'SELECT TYPE',
                  style: TextStyle(color: Color.fromARGB(255, 160, 160, 160)),
                ),
              ),
              Card(
                elevation: 3,
                child: SizedBox(
                  height: pokemonTypes.length * 60.0,
                  child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: pokemonTypes.length,
                    itemBuilder: (BuildContext context, int index) {
                      String type = pokemonTypes[index];
                      bool isSelected =
                          selectedTypes.contains(type.toLowerCase());
                      return ListTile(
                        title: Text(type),
                        onTap: () {
                          setState(() {
                            isSelected
                                ? selectedTypes.remove(type.toLowerCase())
                                : selectedTypes.add(type.toLowerCase());
                          });
                        },
                        trailing: isSelected
                            ? const Icon(
                                Icons.check,
                                color: Colors.blue,
                              )
                            : null,
                      );
                    },
                  ),
                ),
              ),
              // End select type part
              const SizedBox(
                height: 15,
              ),
              // Select weight part 
              const Padding(
                padding: EdgeInsets.only(left: 15),
                child: Text(
                  'SELECT WEIGHT',
                  style: TextStyle(color: Color.fromARGB(255, 160, 160, 160)),
                ),
              ),
              Card(
                elevation: 3,
                child: SizedBox(
                  height: weightRanges.length * 60.0,
                  child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: weightRanges.length,
                    itemBuilder: (BuildContext context, int index) {
                      String weightRange = weightRanges[index];
                      bool isSelected =
                          selectedWeights.contains(weightRange.toLowerCase());
                      return ListTile(
                        title: Text(weightRange),
                        onTap: () {
                          setState(() {
                            isSelected
                                ? selectedWeights
                                    .remove(weightRange.toLowerCase())
                                : selectedWeights
                                    .add(weightRange.toLowerCase());
                          });
                        },
                        trailing: isSelected
                            ? const Icon(
                                Icons.check,
                                color: Colors.blue,
                              )
                            : null,
                      );
                    },
                  ),
                ),
              ),
              // End select weight part
            ],
          ),
        ),
      ),
    );
  }

  // Widget for favorite pokemon
  Widget _buildNotPredefinedOption(String title, String value) {
    bool isSelected = selectedFavorites.contains(value);

    return ListTile(
      title: Text(title),
      onTap: () {
        setState(() {
          isSelected ? selectedFavorites.remove(value) : selectedFavorites.add(value);
        });
      },
      trailing: isSelected ? const Icon( Icons.check, color: Colors.blue,) : null,
    );
  }
}
