class Extra {
  final int id;
  final String name;
  final double price;

  Extra({
    required this.id,
    required this.name,
    required this.price,
  });

  factory Extra.fromJson(Map<String, dynamic> json) {
    return Extra(
      id: json['id'],
      name: json['name'],
      price: (json['price'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
    };
  }
}
