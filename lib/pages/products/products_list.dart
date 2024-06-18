import 'package:easy_pos_app/widgets/app_widgets/app_search_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
enum StockFilter { all, inventory, outOfStock }

class ProductsListPage extends StatefulWidget {
  const ProductsListPage({super.key});

  @override
  _ProductsListPageState createState() => _ProductsListPageState();
}

class _ProductsListPageState extends State<ProductsListPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  var sqlHelper = GetIt.I.get<SqlHelper>();
  List<Product> products = [];
  String? selectedSorting = 'Time';
  StockFilter currentFilter = StockFilter.all;

  var sortingChoices = [
    'Time',
    'Name',
    'Price ⬆️',
    'Price ⬇️',
    'Stock ⬆️',
    'Stock ⬇️',
  ];

  @override
  void initState() {
    getProducts(); // Fetch Products when the widget initializes
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_handleTabSelection);
    super.initState();
  }

  void _handleTabSelection() {
    if (_tabController.indexIsChanging) return;
    setState(() {
      switch (_tabController.index) {
        case 0:
          currentFilter = StockFilter.all;
          break;
        case 1:
          currentFilter = StockFilter.inventory;
          break;
        case 2:
          currentFilter = StockFilter.outOfStock;
          break;
      }
      getProducts(filter: currentFilter, sort: selectedSorting);
    });
  }

  //mapping data to list
  Future<void> getProducts(
      {StockFilter filter = StockFilter.all, String? sort}) async {
    String query;
    switch (filter) {
      case StockFilter.inventory:
        query = """
        SELECT P.*, C.name as categoryName FROM products P
        INNER JOIN categories C ON P.categoryId = C.id
        WHERE P.stock >= 1
      """;
        break;
      case StockFilter.outOfStock:
        query = """
        SELECT P.*, C.name as categoryName FROM products P
        INNER JOIN categories C ON P.categoryId = C.id
        WHERE P.stock < 1
      """;
        break;
      default:
        query = """
        SELECT P.*, C.name as categoryName FROM products P
        INNER JOIN categories C ON P.categoryId = C.id
      """;
    }

    try {
      // Execute the query and fetch data
      var data = await sqlHelper.db!.rawQuery(query);

      // Map data to products list
      if (data.isNotEmpty) {
        products = data.map((item) => Product.fromJson(item)).toList();
      } else {
        products = [];
      }
      // Apply sorting if a sort parameter is provided
      if (sort != null) {
        applySorting(sort);
      }
    } catch (e) {
      print('Error in get products: $e');
    }
    setState(() {});
  }

  void applySorting(String sort) {
    switch (sort) {
      case 'Name':
        products.sort((a, b) => a.name!.compareTo(b.name!));
        break;
      case 'Price ⬆️':
        products.sort((a, b) => a.price!.compareTo(b.price!));
        break;
      case 'Price ⬇️':
        products.sort((a, b) => b.price!.compareTo(a.price!));
        break;
      case 'Stock ⬆️':
        products.sort((a, b) => a.stock!.compareTo(b.stock!));
        break;
      case 'Stock ⬇️':
        products.sort((a, b) => b.stock!.compareTo(a.stock!));
        break;
    }
  }

  void dispose() {
    _tabController.removeListener(_handleTabSelection);
    _tabController.dispose();
    super.dispose();
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
            : Column(
                children: [
                  Container(
                    color: Theme.of(context).primaryColor,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: TabBar(
                        dividerColor: Colors.grey,
                        controller: _tabController,
                        unselectedLabelColor: Colors.white,
                        labelColor: Colors.black,
                        indicatorSize: TabBarIndicatorSize.tab,
                        indicator: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10)),
                          color: Colors.white,
                        ),
                        labelStyle: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                        tabs: [
                          Tab(text: 'All'),
                          Tab(text: 'Inventory'),
                          Tab(text: 'out-of-stock')
                        ]),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(children: [
                        //calling searchfield
                        Row(
                          children: [
                            Container(
                              width: 350,
                              child: AppSearchField(
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
                            ),
                            SizedBox(width: 5),
                            Expanded(
                              child: DropdownButtonFormField(
                                  decoration: InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                          color: Colors.grey.shade300),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                          color: Colors.grey.shade300),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                          color: Colors.grey.shade300),
                                    ),
                                  ),
                                  style: TextStyle(fontSize: 14),
                                  items: sortingChoices.map((String item) {
                                    return DropdownMenuItem<String>(
                                      value: item,
                                      child: Text(item),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedSorting = newValue;
                                    });
                                    getProducts(
                                        filter: currentFilter, sort: newValue);
                                  },
                                  value:
                                      selectedSorting // Set the value to the selected item
                                  ),
                            )
                          ],
                        ),
                        const SizedBox(height: 20),

                        Expanded(
                          child: ListView.builder(
                              itemCount: products.length,
                              itemBuilder: (context, index) {
                                final product = products[index];
                                print('Product: ${product.name}');

                                //calling listcard
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
                      ]),
                    ),
                  ),
                ],
              ));
  }

  //Deleting product
  Future<void> onDeleteProduct(Product product) async {
    await sqlHelper.db!
        .delete('products', where: 'id =?', whereArgs: [product.id]);
    getProducts();
  }
}
