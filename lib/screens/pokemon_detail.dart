// pokemon_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:pokedex/data/pokemon.dart';
import 'package:pokedex/helpers/helpers.dart';
import 'package:pokedex/helpers/shared_preferences_manager.dart';

class PokemonDetailScreen extends StatefulWidget {
  const PokemonDetailScreen({Key? key, required this.pokemon})
      : super(key: key);

  final Pokemon pokemon;

  @override
  State<StatefulWidget> createState() {
    return _PokemonDetailScreenState();
  }
}

class _PokemonDetailScreenState extends State<PokemonDetailScreen> {
  late bool isFavorite;

  Helper helper = Helper.instance;
  SharedPreferencesManager prefsManager = SharedPreferencesManager();

  @override
  void initState() {
    super.initState();
    final key = 'favorite_${widget.pokemon.index}';
    isFavorite = prefsManager.getBool(key);
  }

  void _toggleFavoriteStatus() {
    final key = 'favorite_${widget.pokemon.index}';
    setState(() {
      isFavorite = !isFavorite;
    });
    prefsManager.setBool(key, isFavorite);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Datos Pokémon',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
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
        padding: const EdgeInsets.all(16.0),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 70, left: 14),
              // Pokemon index container
              child: Container(
                alignment: Alignment.center,
                width: 110.0,
                height: 50.0,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: const BorderRadius.all(Radius.circular(25)),
                  border: Border.all(
                    color: const Color.fromARGB(246, 236, 170, 137),
                    width: 2.0,
                  ),
                ),
                child: Text(
                  widget.pokemon.index.toString(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 22,
                    color: Color.fromARGB(255, 92, 92, 92),
                  ),
                ),
              ),
              // End pokemon index container
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Pokemon image and circle
                Padding(
                  padding: const EdgeInsets.only(top: 100),
                  child: Container(
                    width: 150.0,
                    height: 150.0,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color.fromARGB(246, 236, 170, 137),
                          width: 6.0,
                        )),
                    child: ClipOval(
                      child: Image.network(
                        widget.pokemon.image,
                        height: 300.0,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                // End pokemon image and circle
                const SizedBox(height: 16.0),
                // Pokemon name and favorite button
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      helper.capitalize(widget.pokemon.name),
                      style: const TextStyle(
                        fontSize: 27.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        isFavorite ? Icons.star : Icons.star_border,
                        color: Colors.yellow,
                        size: 35.0,
                      ),
                      onPressed: _toggleFavoriteStatus,
                    ),
                  ],
                ),
                // End pokemon name and favorite button
                const SizedBox(height: 8.0),
                // Type and weight info
                Container(
                  padding: const EdgeInsets.all(14),
                  width: 300,
                  height: 95,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                        color: const Color.fromARGB(255, 156, 156, 156),
                        width: 2),
                  ),
                  child: IntrinsicHeight(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            const Text(
                              'Tipo',
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Color.fromARGB(255, 145, 144, 144),
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Text(
                              helper.capitalize(widget.pokemon.type),
                              style: const TextStyle(
                                  fontSize: 19, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const VerticalDivider(
                          color: Color.fromARGB(255, 156, 156, 156),
                          thickness: 2,
                        ),
                        Column(
                          children: [
                            const Text(
                              'Peso',
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Color.fromARGB(255, 145, 144, 144),
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Text(
                              '${widget.pokemon.weight.toString()} kg',
                              style: const TextStyle(
                                  fontSize: 19, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                // end type and weight info
              ],
            ),
          ],
        ),
      ),
    );
  }
}
