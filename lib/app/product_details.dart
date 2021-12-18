import 'dart:developer';

import 'package:bdaej/data/api/api.dart';
import 'package:bdaej/data/model/product.dart';
import 'package:dio/dio.dart';

import 'package:flutter/material.dart';

import '../../widgets/info_row.dart';
import 'form.dart';

class ProductDetails extends StatefulWidget {
  const ProductDetails({
    Key? key,
    required this.product,
  }) : super(key: key);

  final Product product;

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  final api = Api();
  bool isLoading = false;
  Future<void> deleteProduct() async {
    setState(() {
      isLoading = true;
    });
    FormData form = FormData.fromMap({"product_id": widget.product.id});
    final res =
        await api.method.post(Api.url + 'products?action=delete', data: form);
    log(res.data.toString());
    setState(() {
      isLoading = false;
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FormScreen(product: widget.product),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async => deleteProduct(),
          ),
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InfoRow(
                    title: "Categorias",
                    value: widget.product.category[0],
                  ),
                  InfoRow(
                    title: "ID",
                    value: widget.product.id.toString(),
                  ),
                  InfoRow(
                    title: "Valor médio",
                    value: widget.product.averageSell,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  const Text(
                    "Descrição",
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(widget.product.description),
                  const SizedBox(
                    height: 8,
                  ),
                ],
              ),
            ),
    );
  }
}
