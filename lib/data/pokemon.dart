class Pokemon {
  final int index;
  final String image;
  final String name;
  final String type;
  final double weight;

  Pokemon({
    required this.index,
    required this.image,
    required this.name,
    required this.type,
    required this.weight,
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    return Pokemon(
      index: json['index'],
      image: json['image'],
      name: json['name'],
      type: json['type'],
      weight: json['weight'].toDouble(),
    );
  }
}