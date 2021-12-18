import 'package:bdaej/app/product_details.dart';
import 'package:bdaej/data/api/api.dart';
import 'package:bdaej/data/model/category.dart';
import 'package:bdaej/data/model/product.dart';
import 'package:flutter/material.dart';

import 'category_list.dart';
import 'form.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Product> products = [];
  List<Category> categories = [];
  String categoriaID = '';
  bool isLoading = false;
  final api = Api();
  @override
  void initState() {
    listProducts();
    super.initState();
  }

  Future<void> listProducts() async {
    setState(() {
      isLoading = true;
    });
    final res = await api.method.get(Api.url + 'products?action=list');
    await listCategories();
    setState(() {
      products = res.data['products']
          .map<Product>((p) => Product.fromJson(p)
              .copyWith(category: [convertToCategory(p['categorias'])!]))
          .toList();
      isLoading = false;
    });
  }

  Future<void> listCategories() async {
    final res = await api.method.get(Api.url + 'category?action=list');
    categories = res.data['categories']
        .map<Category>((c) => Category.fromJson(c))
        .toList();
  }

  String? convertToCategory(String id) {
    String value = 'Categoria desconhecida';
    for (var element in categories) {
      if (element.id ==
          id.replaceAll("\"", "").replaceAll("[", "").replaceAll("]", "")) {
        value = element.name;
        categoriaID = value;
      }
    }
    return value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Produtos"),
        actions: [
          TextButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CategoryList(),
              ),
            ),
            child: const Text(
              "Categorias",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const FormScreen(
                  product: null,
                ),
              ),
            ),
          ),
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(products[index].name),
                  subtitle: Text(products[index].category[0]),
                  trailing: Text(products[index].id.toString()),
                  leading: const Icon(Icons.shopping_bag_outlined),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductDetails(
                        product: products[index],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
