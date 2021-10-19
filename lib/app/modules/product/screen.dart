import 'package:bdaej/app/modules/data/model/product.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'widgets/info_row.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({Key? key, required this.product}) : super(key: key);

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InfoRow(
              title: "Categoria",
              value: product.category,
            ),
            InfoRow(
              title: "ID",
              value: product.id.toString(),
            ),
            InfoRow(
              title: "Quantidade",
              value: product.quantity.toString(),
            ),
            InfoRow(
              title: "Valor médio de vendas",
              value: product.averageSell.toString(),
            ),
            const SizedBox(
              height: 16,
            ),
            const Text(
              "Descrição",
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(product.description)
          ],
        ),
      ),
    );
  }
}
