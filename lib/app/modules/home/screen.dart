import 'dart:math';
import 'package:bdaej/app/modules/data/model/product.dart';
import 'package:bdaej/app/modules/product/screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

//TODO: Alterar os valores estáticos para os valores recebidos pela api
  static const List<String> products = [
    "Celta",
    "Fiat Marea",
    "Gol bola",
    "Polo",
    "Citroen Picasso",
    "Citroen C3",
    "Agile",
    "Renegade",
    "Elantra",
    "Eco Sport"
  ];

  static const List<String> descriptions = [
    "Carro para viagens",
    "Carro de garagem",
    "Usado somente aos sábados",
    "Carro roubado",
    "vendese",
    "semf reio",
    "Pneu furado",
    "Só precisa ajeitar os vidros",
    "Para família",
    "Carro de passeio"
  ];

  static const List<String> categories = [
    "Carro",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Produtos"),
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = Product(
              name: products[index],
              category: categories[Random().nextInt(categories.length)],
              description: descriptions[Random().nextInt(descriptions.length)],
              id: index,
              averageSell: Random().nextInt(50000),
              quantity: Random().nextInt(100));

          return ListTile(
            title: Text(product.name),
            subtitle: Text(product.category),
            trailing: Text(product.id.toString()),
            leading: const Icon(Icons.shopping_bag_outlined),
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ProductScreen(product: product))),
          );
        },
      ),
    );
  }
}
