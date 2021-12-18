import 'dart:developer';

import 'package:bdaej/data/api/api.dart';
import 'package:bdaej/data/model/product.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({Key? key, required this.product}) : super(key: key);

  final Product? product;

  @override
  _FormScreenState createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _nameTextEditingController = TextEditingController();
  final _categoryTextEditingController = TextEditingController();

  final _descriptionTextEditingController = TextEditingController();
  final _averageSellTextEditingController = TextEditingController();

  final api = Api();
  bool isLoading = false;
  late bool shouldAddProduct;
  @override
  void initState() {
    shouldAddProduct = widget.product == null;
    _nameTextEditingController.text = widget.product?.name ?? '';
    _categoryTextEditingController.text = widget.product?.category[0] ?? '';
    _descriptionTextEditingController.text = widget.product?.description ?? '';
    _averageSellTextEditingController.text = widget.product?.averageSell ?? '';
    super.initState();
  }

  Future<void> addProduct() async {
    setState(() {
      isLoading = true;
    });
    FormData form = FormData.fromMap({
      "product_name": _nameTextEditingController.text,
      "description": _descriptionTextEditingController.text,
      "value": _averageSellTextEditingController.text,
      "categories": _categoryTextEditingController.text,
    });

    final res =
        await api.method.post(Api.url + 'products?action=add', data: form);
    log(res.data.toString());
    setState(() {
      isLoading = false;
    });
    Navigator.pop(context);
  }

  Future<void> editProduct() async {
    setState(() {
      isLoading = true;
    });
    FormData form = FormData.fromMap({
      "product_id": widget.product!.id,
      "product_name": _nameTextEditingController.text,
      "description": _descriptionTextEditingController.text,
      "value": _averageSellTextEditingController.text,
      "categories": _categoryTextEditingController.text,
    });
    final res =
        await api.method.post(Api.url + 'products?action=edit', data: form);
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
        title: Text(
            shouldAddProduct ? "Cadastro de Produto" : "Edição de Produto"),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  TextField(
                    controller: _nameTextEditingController,
                    decoration: const InputDecoration(
                      labelText: "Nome",
                    ),
                  ),
                  TextField(
                    controller: _categoryTextEditingController,
                    decoration: const InputDecoration(
                      labelText: "Categoria",
                    ),
                  ),
                  TextField(
                    controller: _descriptionTextEditingController,
                    decoration: const InputDecoration(
                      labelText: "Descrição",
                    ),
                  ),
                  TextField(
                    controller: _averageSellTextEditingController,
                    decoration: const InputDecoration(
                      labelText: "Valor médio",
                    ),
                  ),
                  TextButton(
                      onPressed: () async => shouldAddProduct
                          ? await addProduct()
                          : await editProduct(),
                      child: Text(shouldAddProduct ? "Adicionar" : "Atualizar"))
                ],
              ),
            ),
    );
  }
}
