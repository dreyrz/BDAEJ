import 'dart:developer';

import 'package:bdaej/data/api/api.dart';
import 'package:bdaej/data/model/category.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class CategoryList extends StatefulWidget {
  const CategoryList({Key? key}) : super(key: key);

  @override
  _CategoryListState createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  List<Category> categories = [];
  bool isLoading = false;
  final api = Api();
  final _categoryTextEditingController = TextEditingController();
  final _editCategoryTextEditingController = TextEditingController();
  Future<void> listCategories() async {
    setState(() {
      isLoading = true;
    });
    final res = await api.method.get(Api.url + 'category?action=list');
    categories = res.data['categories']
        .map<Category>((c) => Category.fromJson(c))
        .toList();
    setState(() {
      isLoading = false;
    });
  }

  Future<void> addCategory() async {
    setState(() {
      isLoading = true;
    });
    FormData form = FormData.fromMap({
      "category_name": _categoryTextEditingController.text,
    });
    await api.method.post(Api.url + 'category?action=add', data: form);
    setState(() {
      isLoading = false;
    });
  }

  Future<void> editCategory(String id) async {
    setState(() {
      isLoading = true;
    });
    FormData form = FormData.fromMap({
      "category_id": id,
      "category_name": _editCategoryTextEditingController.text,
    });
    final res =
        await api.method.post(Api.url + 'category?action=edit', data: form);
    log(res.data.toString());
    setState(() {
      isLoading = false;
    });
  }

  Future<void> deleteCategory(String id) async {
    setState(() {
      isLoading = true;
    });
    FormData form = FormData.fromMap({
      "category_id": id.toString(),
    });
    final res =
        await api.method.post(Api.url + 'category?action=delete', data: form);
    log(res.data.toString());
    categories.removeWhere((element) => element.id == id);
    setState(() {
      isLoading = false;
    });
  }

  String idByText(String name) {
    final x = categories.firstWhere((element) => element.name == name);
    return x.id;
  }

  void _showModal(context, Category category) {
    _editCategoryTextEditingController.text = category.name;
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SizedBox(
            height: 400,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  TextField(
                    controller: _editCategoryTextEditingController,
                    decoration: const InputDecoration(
                      labelText: "Editar categoria",
                    ),
                  ),
                  TextButton(
                      onPressed: () async => editCategory(category.id),
                      child: const Text("Atualizar"))
                ],
              ),
            ),
          );
        });
  }

  @override
  void initState() {
    listCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          SizedBox(
            width: 250,
            height: 100,
            child: TextField(
              controller: _categoryTextEditingController,
              style: const TextStyle(
                color: Colors.white,
              ),
              decoration: const InputDecoration(
                  labelText: "Adicione uma categoria",
                  filled: true,
                  fillColor: Colors.transparent,
                  labelStyle: TextStyle(
                    color: Colors.white,
                  )),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async => addCategory(),
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async =>
                editCategory(idByText(_categoryTextEditingController.text)),
          ),
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: categories.length,
              itemBuilder: (context, index) => ListTile(
                title: Text(categories[index].name),
                onTap: () => _showModal(context, categories[index]),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () =>
                      deleteCategory(categories[index].id.toString()),
                ),
              ),
            ),
    );
  }
}
