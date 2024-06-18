import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_pos_app/models/client.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:route_transitions/route_transitions.dart';

import '../../helpers/sql_helper.dart';
import '../pages/clients/clients_ops.dart';

class ClientsDropDown extends StatefulWidget {
  final int? selectedValue;
  TextEditingController clientSearchController = TextEditingController();

  final void Function(int?)? onChanged;

  ClientsDropDown(
      {this.selectedValue,
      required this.onChanged,
      required this.clientSearchController,
      super.key});

  @override
  State<ClientsDropDown> createState() => _ClientsDropDownState();
}

class _ClientsDropDownState extends State<ClientsDropDown> {
  var sqlHelper = GetIt.I.get<SqlHelper>();

  List<Client> clients = [];

  @override
  void initState() {
    getClients();
    super.initState();
  }

  Future<void> getClients() async {
    try {
      var data = await sqlHelper.db!.query('clients');
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
    try {
      return clients.isEmpty
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('No Clients Found, '),
                InkWell(
                  //updating the clients right away
                  onTap: () async {
                    var updated = await pushWidgetAwait(
                        newPage: const ClientsOpsPage(), context: context);
                    if (updated == true) {
                      getClients();
                    }
                  },
                  child: Text(
                    'Add A New One',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor),
                  ),
                )
              ],
            )
          : DropdownButtonFormField2<int>(
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(right: 12, top: 25, bottom: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
              ),
              value: widget.selectedValue,
              isExpanded: true,
              hint: const Text('Select Client'),
              items: clients.map((client) {
                return DropdownMenuItem<int>(
                  value: client.id,
                  child: Text(
                    client.name ?? 'No Name',
                    style: TextStyle(
                      fontWeight: widget.selectedValue == client.id
                          ? FontWeight.w600 // Bold for selected item
                          : FontWeight.normal,
                    ),
                  ),
                );
              }).toList(),
              onChanged: widget.onChanged,
              dropdownSearchData: DropdownSearchData(
                searchController: widget.clientSearchController,
                searchInnerWidgetHeight: 60,
                searchInnerWidget: Container(
                  height: 60,
                  padding: const EdgeInsets.only(
                    top: 10,
                    bottom: 5,
                    right: 10,
                    left: 10,
                  ),
                  child: TextFormField(
                    expands: true,
                    maxLines: null,
                    controller: widget.clientSearchController,
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 15,
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade50,
                      hintText: 'Search',
                      hintStyle: const TextStyle(fontSize: 12),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.grey.shade300)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              width: 2, color: Theme.of(context).primaryColor)),
                    ),
                  ),
                ),
                searchMatchFn: (item, searchValue) {
                  //find the first client that has the samd id as the itemvalue for this menu
                  var client =
                      clients.firstWhere((client) => client.id == item.value);

                  //compare this client's name with the searchvalue
                  return client.name!
                      .toLowerCase()
                      .contains(searchValue.toLowerCase());
                },
              ),

              //to clear the search value after closing the menu
              onMenuStateChange: (isOpen) {
                if (!isOpen) {
                  widget.clientSearchController.clear();
                }
              });
    } catch (e) {
      print('Error building ClientsDropDown: $e');
      return const SizedBox.shrink(); // Return an empty box if there's an error
    }
  }
}
