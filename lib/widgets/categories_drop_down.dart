import 'package:easy_pos_app/pages/categories_ops.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:route_transitions/route_transitions.dart';

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
    try {
      return categories.isEmpty
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('No Categories Found, '),
                InkWell(
                  onTap: () {
                    slideRightWidget(
                        newPage: CategoriesOpsPage(), context: context);
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
          : Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(
                  color: Colors.black,
                ),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<int>(
                    value: widget.selectedValue,
                    isExpanded: true,
                    hint: const Text('Select Category'),
                    items: categories.map((category) {
                      return DropdownMenuItem<int>(
                        value: category.id,
                        child: Text(category.name ?? 'No Name'),
                      );
                    }).toList(),
                    onChanged: widget.onChanged,
                  ),
                ),
              ),
            );
    } catch (e) {
      print('Error building CategoriesDropDown: $e');
      return const SizedBox.shrink(); // Return an empty box if there's an error
    }
  }
}
