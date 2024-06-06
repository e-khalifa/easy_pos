import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../helpers/sql_helper.dart';
import '../models/category.dart';

class CategoriesDropDown extends StatefulWidget {
  final int? selectedValue;
  final void Function(int?)? onChanged;
  const CategoriesDropDown(
      {required this.onChanged, this.selectedValue, super.key});

  @override
  State<CategoriesDropDown> createState() => _CategoriesDropDownState();
}

class _CategoriesDropDownState extends State<CategoriesDropDown> {
  var sqlHelper = GetIt.I.get<SqlHelper>();

  List<Category> categories = [];

  @override
  void initState() {
    getCategories();
    super.initState();
  }

  Future<void> getCategories() async {
    try {
      var data = await sqlHelper.db!.query('categories');
      if (data.isNotEmpty) {
        categories = data.map((item) => Category.fromJson(item)).toList();
      } else {
        categories = [];
      }
    } catch (e) {
      print('Error in get Categories: $e');
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                color: Colors.black,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              child: DropdownButton(
                  value: widget.selectedValue,
                  isExpanded: true,
                  underline: const SizedBox(),
                  hint: const Text('Select Category'),
                  items: [
                    for (var category in categories)
                      DropdownMenuItem(
                        value: category.id,
                        child: Text(category.name ?? 'No Name'),
                      ),
                  ],
                  onChanged: widget.onChanged),
            ),
          ),
        ),
      ],
    );
  }
}
