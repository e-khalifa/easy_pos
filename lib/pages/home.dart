import 'package:flutter/material.dart';
import 'package:route_transitions/route_transitions.dart';
import '../widgets/custom_grid_view_item.dart';
import '../widgets/header_card.dart';

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
                  padding: const EdgeInsets.all(20),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(children: [
                          Text(
                            'Easy POS',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                          ),
                        ]),

                        const SizedBox(height: 20),
                        //Calling headercard #2
                        HeaderCard(
                            label: 'Exchange Rate', value: '1EUR = 51.5 Egp'),

                        const SizedBox(height: 10),

                        HeaderCard(label: 'Today\'s Sales', value: '9000 Egp'),
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
                    label: 'All sales',
                    icon: Icons.calculate,
                    color: Colors.orange,
                    onTap: () {},
                  ),
                  CustomGridViewItem(
                    label: 'Products',
                    icon: Icons.inventory_2,
                    color: Colors.pink,
                    onTap: () {},
                  ),
                  CustomGridViewItem(
                      label: 'Clients',
                      icon: Icons.groups,
                      color: Colors.lightBlue,
                      onTap: () {
                        slideRightWidget(newPage: HomePage(), context: context);
                      }),
                  CustomGridViewItem(
                    label: 'New sale',
                    icon: Icons.point_of_sale,
                    color: Colors.green,
                    onTap: () {},
                  ),
                  CustomGridViewItem(
                    label: 'Categories',
                    icon: Icons.category,
                    color: Colors.yellow,
                    onTap: () {},
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
