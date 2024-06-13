import 'package:easy_pos_app/widgets/app_search_field.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:route_transitions/route_transitions.dart';

import '../../helpers/sql_helper.dart';
import '../../models/client.dart';
import '../../widgets/list_card.dart';
import 'clients_ops.dart';

class ClientsListPage extends StatefulWidget {
  const ClientsListPage({super.key});

  @override
  _ClientsListPageState createState() => _ClientsListPageState();
}

class _ClientsListPageState extends State<ClientsListPage> {
  var sqlHelper = GetIt.I.get<SqlHelper>();
  List<Client> clients = [];

  @override
  void initState() {
    getClients(); // Fetch clients when the widget initializes
    super.initState();
  }

  //mapping data to list
  Future<void> getClients() async {
    try {
      var data = await sqlHelper.db!.query('customers');
      if (data.isNotEmpty) {
        clients = data.map((item) => Client.fromJson(item)).toList();
      } else {
        clients = [];
      }
    } catch (e) {
      print('Error in get Clients: $e');
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Clients'),
          actions: [
            IconButton(
                icon: const Icon(
                  Icons.add,
                  size: 30,
                ),

                //updating getClients function after adding or updating any client
                onPressed: () async {
                  var updated = await pushWidgetAwait(
                      newPage: const ClientsOpsPage(), context: context);
                  if (updated == true) {
                    getClients();
                  }
                }),
          ],
        ),
        body: clients.isEmpty
            ? Center(
                child: Text('No Clients Found'),
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
                          getClients();
                          return;
                        }

                        //search the data for the text provided
                        final data = await sqlHelper.db!.rawQuery('''
                      SELECT * FROM customers 
                      WHERE name LIKE '%$text%' OR address LIKE '%$text%' OR email LIKE '$text'
                    ''');

                        //if anything related found, map it to a list
                        if (data.isNotEmpty) {
                          clients = data
                              .map((item) => Client.fromJson(item))
                              .toList();

                          //nothing found? empty list
                        } else {
                          clients = [];
                        }
                        setState(() {});
                      },
                    ),

                    const SizedBox(height: 20),

                    Expanded(
                      child: ListView.builder(
                          itemCount: clients.length,
                          itemBuilder: (context, index) {
                            final client = clients[index];
                            print('Client: ${client.name}');

                            //caling listcard
                            return ListCard(
                                name: client.name,
                                description: client.phone,
                                onDeleted: () => onDeleteClient(client),
                                onEdit: () {
                                  slideRightWidget(
                                      newPage: ClientsOpsPage(client: client),
                                      context: context);
                                });
                          }),
                    ),
                  ],
                )));
  }

  //Deleting client
  Future<void> onDeleteClient(Client client) async {
    await sqlHelper.db!
        .delete('customers', where: 'id =?', whereArgs: [client.id]);
    getClients();
  }
}
