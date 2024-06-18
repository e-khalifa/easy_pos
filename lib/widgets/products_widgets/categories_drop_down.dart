import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_pos_app/pages/categories/categories_ops.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:route_transitions/route_transitions.dart';

import '../../helpers/sql_helper.dart';
import '../../models/category.dart';

class CategoriesDropDown extends StatefulWidget {
  final int? selectedValue;
  final String? Function(int?)? validator;
  TextEditingController categorySearchController = TextEditingController();

  final void Function(int?)? onChanged;

  CategoriesDropDown(
      {this.selectedValue,
      required this.validator,
      required this.onChanged,
      required this.categorySearchController,
      super.key});

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
                  //updating the categories right away
                  onTap: () async {
                    var updated = await pushWidgetAwait(
                        newPage: const CategoriesOpsPage(), context: context);
                    if (updated == true) {
                      getCategories();
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
          : DropdownButtonHideUnderline(
              child: DropdownButtonFormField2<int>(
                  decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.only(right: 12, top: 25, bottom: 20),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(
                          width: 2,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(
                          width: 2,
                          color: Colors.red,
                        ),
                      )),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  value: widget.selectedValue,
                  isExpanded: true,
                  hint: const Text('Select Category'),
                  items: categories.map((category) {
                    return DropdownMenuItem<int>(
                      value: category.id,
                      child: Text(
                        category.name ?? 'No Name',
                      ),
                    );
                  }).toList(),
                  onChanged: widget.onChanged,
                  dropdownSearchData: DropdownSearchData(
                    searchController: widget.categorySearchController,
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
                        controller: widget.categorySearchController,
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
                              borderSide:
                                  BorderSide(color: Colors.grey.shade300)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor)),
                        ),
                      ),
                    ),
                    searchMatchFn: (item, searchValue) {
                      var category = categories
                          .firstWhere((category) => category.id == item.value);
                      return category.name!
                          .toLowerCase()
                          .contains(searchValue.toLowerCase());
                    },
                  ),
                  onMenuStateChange: (isOpen) {
                    if (!isOpen) {
                      widget.categorySearchController.clear();
                    }
                  }));
    } catch (e) {
      print('Error building CategoriesDropDown: $e');
      return const SizedBox.shrink();
    }
  }
}
