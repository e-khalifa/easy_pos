import 'package:easy_pos_app/widgets/app_search_field.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:route_transitions/route_transitions.dart';

import '../../helpers/sql_helper.dart';
import '../../models/product.dart';
import '../../widgets/products_card.dart';
import 'products_ops.dart';

/*
Products:
        1- Name
        2- Description
        3- Category Name
        4- Price
        5- In Stock
        6- Barcode
        7- isAvailable
*/
class ProductsListPage extends StatefulWidget {
  const ProductsListPage({super.key});

  @override
  _ProductsListPageState createState() => _ProductsListPageState();
}

class _ProductsListPageState extends State<ProductsListPage> {
  var sqlHelper = GetIt.I.get<SqlHelper>();
  List<Product> products = [];

  @override
  void initState() {
    getProducts(); // Fetch Products when the widget initializes
    super.initState();
  }

  //mapping data to list
  Future<void> getProducts() async {
    try {
      var data = await sqlHelper.db!.rawQuery("""
        Select P.*,C.name as categoryName from products P
        Inner JOIN categories C
        On P.categoryId = C.id
      """);

      if (data.isNotEmpty) {
        products = data.map((item) => Product.fromJson(item)).toList();
      } else {
        products = [];
      }
    } catch (e) {
      print('Error in get products: $e');
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('products'),
          actions: [
            IconButton(
                icon: const Icon(
                  Icons.add,
                  size: 30,
                ),

                //updating getProducts function after adding or updating any product
                onPressed: () async {
                  var updated = await pushWidgetAwait(
                      newPage: const ProductsOpsPage(), context: context);
                  if (updated == true) {
                    getProducts();
                  }
                }),
          ],
        ),
        body: products.isEmpty
            ? Center(
                child: Text('No Products Found'),
              )
            : Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    //calling searchfield
                    AppSearchField(
                      //if the search field is empty, nothing change
                      onSearchTextChanged: (text) async {
                        if (text.isEmpty) {
                          getProducts();
                          return;
                        }

                        //search the data (name/desciption/barcode) for the text provided
                        final data = await sqlHelper.db!.rawQuery('''
                      SELECT * FROM products 
                      WHERE name LIKE '%$text%'
                      OR description LIKE '%$text%'
                      OR barcode LIKE '%$text%'
                    ''');

                        //if anything related found, map it to a list
                        if (data.isNotEmpty) {
                          products = data
                              .map((item) => Product.fromJson(item))
                              .toList();

                          //nothing found? empty list
                        } else {
                          products = [];
                        }
                        setState(() {});
                      },
                    ),

                    const SizedBox(height: 20),

                    Expanded(
                      child: ListView.builder(
                          itemCount: products.length,
                          itemBuilder: (context, index) {
                            final product = products[index];
                            print('Product: ${product.name}');

                            //caling listcard
                            return ProductCard(
                                imageUrl: product.image,
                                name: product.name,
                                description: product.description,
                                category: product.categoryName,
                                stock: product.stock,
                                price: product.price,
                                onDeleted: () => onDeleteProduct(product),
                                onEdit: () {
                                  slideRightWidget(
                                      newPage:
                                          ProductsOpsPage(product: product),
                                      context: context);
                                });
                          }),
                    ),
                  ],
                )));
  }

  //Deleting product
  Future<void> onDeleteProduct(Product product) async {
    await sqlHelper.db!
        .delete('products', where: 'id =?', whereArgs: [product.id]);
    getProducts();
  }
}
