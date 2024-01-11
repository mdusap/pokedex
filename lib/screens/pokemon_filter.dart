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
    'Dragon'
  ];

  List<String> pokemonWeights = [
    '0 to 10 kg',
    '10 to 35 kg',
    '35 to 75 kg',
    '75 to 100 kg',
    '100 o superior',
  ];

  List<String> favoritePokemons = [
    'Select Favorites',
    'Select All',
  ];

  // Using set instead of list to not allow duplicated (When user presses the same item multiple times it gets the same value multiple times and that was an error)
  Set<String> selectedTypes = {};
  Set<String> selectedWeights = {};

  @override
  void initState() {
    super.initState();
    if (selectedTypes.isNotEmpty) {
      selectedTypes = (prefsManager.getStringList('selectedTypes')).toSet();
    } else {
      selectedTypes =
          (prefsManager.getEmptyStringList('selectedTypes')).toSet();
    }
  }

  // Using shared_preferences to save the selected item so when we go back to the filter screen mantain the selected item/s
  Future<void> _saveFilters() async {
    if (selectedTypes.isEmpty) {
      prefsManager.setEmptyStringList('selectedTypes');
    } else {
      prefsManager.setStringList('selectedTypes', selectedTypes.toList());
    }
  }

  @override
  Widget build(context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 228, 227, 227),
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: () {
              _saveFilters();
              //final data = {"types":selectedTypes.toSet(), "weights":selectedWeights.toSet()};
              Navigator.of(context).pop(selectedTypes.toSet());
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
                child: Text(
                  'FAVORITE POKEMONS',
                  style: TextStyle(color: Color.fromARGB(255, 160, 160, 160)),
                ),
              ),
              Card(
                elevation: 3,
                child: SizedBox(
                  height: 60.0,
                  child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: favoritePokemons.length,
                    itemBuilder: (BuildContext context, int index) {
                      String favorites = favoritePokemons[index];
                      bool isSelected = favoritePokemons.contains(favorites);
                      return ListTile(
                        title: Text(favorites),
                        onTap: () {
                          setState(() {
                            if (isSelected) {
                              selectedTypes.remove(favorites);
                            } else {
                              selectedTypes.add(favorites);
                            }
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
              const SizedBox(
                height: 15,
              ),
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
                            if (isSelected) {
                              selectedTypes.remove(type.toLowerCase());
                            } else {
                              selectedTypes.add(type.toLowerCase());
                            }
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
              const SizedBox(
                height: 15,
              ),
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
                  height: pokemonWeights.length * 60.0,
                  child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: pokemonWeights.length,
                    itemBuilder: (BuildContext context, int index) {
                      String weight = pokemonWeights[index];
                      bool isSelected = selectedWeights.contains(weight);
                      return ListTile(
                        title: Text(weight),
                        onTap: () {
                          setState(() {
                            if (isSelected) {
                              selectedWeights.remove(weight);
                            } else {
                              selectedWeights.add(weight);
                            }
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
            ],
          ),
        ),
      ),
    );
  }
}
