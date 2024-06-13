import 'package:easy_pos_app/pages/categories/categories_list.dart';
import 'package:easy_pos_app/pages/products/products_list.dart';
import 'package:easy_pos_app/pages/sales_statistics.dart';
import 'package:flutter/material.dart';
import 'package:route_transitions/route_transitions.dart';
import '../widgets/custom_grid_view_item.dart';
import '../widgets/header_card.dart';
import 'clients/clients_list.dart';
import 'sales_ops.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Container(),
      appBar: AppBar(),
      body: Column(
        children: [
          Container(
              color: Theme.of(context).primaryColor,
              height: MediaQuery.of(context).size.height / 3,
              child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          Text(
                            'Easy POS',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                          ),
                        ]),

                        SizedBox(height: 20),
                        //Calling headercard #2
                        HeaderCard(
                          label: 'Exchange Rate',
                          value: '1EUR = 51.5 Egp',
                          onTap: () {},
                        ),

                        SizedBox(height: 10),

                        HeaderCard(
                            label: 'Today\'s Sales',
                            value: '9000 Egp',
                            onTap: () {
                              slideRightWidget(
                                  newPage: SalesStatisticsPage(),
                                  context: context);
                            }),
                      ]))),

          //gridview container
          Expanded(
              child: Container(
            color: const Color.fromARGB(255, 250, 250, 250),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: GridView.count(
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
                crossAxisCount: 2,
                children: [
                  CustomGridViewItem(
                    label: 'Sales Statistics',
                    icon: Icons.calculate,
                    color: Colors.orange,
                    onTap: () {
                      slideRightWidget(
                          newPage: SalesStatisticsPage(), context: context);
                    },
                  ),
                  CustomGridViewItem(
                    label: 'Products',
                    icon: Icons.inventory_2,
                    color: Colors.pink,
                    onTap: () {
                      slideRightWidget(
                          newPage: ProductsListPage(), context: context);
                    },
                  ),
                  CustomGridViewItem(
                      label: 'Clients',
                      icon: Icons.groups,
                      color: Colors.lightBlue,
                      onTap: () {
                        slideRightWidget(
                            newPage: ClientsListPage(), context: context);
                      }),
                  CustomGridViewItem(
                    label: 'New sale',
                    icon: Icons.point_of_sale,
                    color: Colors.green,
                    onTap: () {
                      slideRightWidget(
                          newPage: SalesOpsPage(), context: context);
                    },
                  ),
                  CustomGridViewItem(
                    label: 'Categories',
                    icon: Icons.category,
                    color: Colors.yellow,
                    onTap: () {
                      slideRightWidget(
                          newPage: CategoriesListPage(), context: context);
                    },
                  ),
                  CustomGridViewItem(
                    label: 'Iventory',
                    icon: Icons.inventory,
                    color: Colors.purple,
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ))
        ],
      ),
    );
  }
}
