class Product {
  final String id;
  final String? categoryID;
  final String name;
  final List<String> category;
  final String description;

  final String averageSell;

  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.averageSell,
    required this.description,
    this.categoryID,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      category: [json['categorias']].map((e) => e.toString()).toList(),
      categoryID: [json['categorias']].map((e) => e.toString()).toList()[0],
      description: json['descricao'],
      id: json['ID'],
      name: json['nome_produto'],
      averageSell: json['valor'],
    );
  }

  Product copyWith({
    String? id,
    String? name,
    List<String>? category,
    String? description,
    String? averageSell,
  }) {
    return Product(
        category: category ?? this.category,
        description: description ?? this.description,
        id: id ?? this.id,
        name: name ?? this.name,
        averageSell: averageSell ?? this.averageSell);
  }

  @override
  String toString() {
    return ("Product id $id name $name category $category description $description");
  }
}
