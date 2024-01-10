import 'package:flutter/material.dart';
import 'package:pokedex/data/pokemon.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PokemonFilterScreen extends StatefulWidget {
    const PokemonFilterScreen({Key? key}) : super(key: key);


  @override
  State<PokemonFilterScreen> createState() {
    return _PokemonFilterScreenState();
  }
}

class _PokemonFilterScreenState extends State<PokemonFilterScreen> {
  late List<Pokemon> pokemonList;

  List<String> pokemonTypes = [
    'Fire',
    'Water',
    'Grass',
    'Poison',
    'Bug',
    'Dragon'
  ];

  // Using set instead of list to not allow duplicated (When user presses the same item multiple times it gets the same value multiple times and that was an error)
  Set<String> selectedTypes = {};

  @override
  void initState() {
    super.initState();
    _loadSelectedTypes();
  }

  Future<void> _loadSelectedTypes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedTypes = (prefs.getStringList('selectedTypes') ?? []).toSet();
    });
  }

  // Using shared_preferences to save the selected item so when we go back to the filter screen mantain the selected item/s
  Future<void> _saveSelectedTypes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('selectedTypes', selectedTypes.toList());
  }

  @override
  Widget build(context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 228, 227, 227),
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: () async {
              await _saveSelectedTypes();
              Navigator.pop(context, selectedTypes.toSet());
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
            ],
          ),
        ),
      ),
    );
  }
}
