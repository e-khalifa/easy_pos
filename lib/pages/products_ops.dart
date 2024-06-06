import 'package:easy_pos_app/widgets/is_available_switch.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:sqflite/sqflite.dart';

import '../helpers/sql_helper.dart';
import '../models/product.dart';
import '../widgets/app_elevated_button.dart';
import '../widgets/app_text_field.dart';
import '../widgets/categories_drop_down.dart';

class ProductsOpsPage extends StatefulWidget {
  final Product? product;
  const ProductsOpsPage({this.product, super.key});

  @override
  State<ProductsOpsPage> createState() => _ProductsOpsState();
}

class _ProductsOpsState extends State<ProductsOpsPage> {
  var sqlHelper = GetIt.I.get<SqlHelper>();

  var formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();
  final barcodeController = TextEditingController();
  final stockController = TextEditingController();
  final imageController = TextEditingController();
  bool? isAvailable;
  int? selectedCategoryId;

  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      // Setting initial values for editing an existing product
      nameController.text = widget.product!.name!;
      descriptionController.text = widget.product!.description!;
      priceController.text = '${widget.product?.price ?? ''}';
      barcodeController.text = widget.product!.barcode!;
      stockController.text = '${widget.product?.stock ?? ''}';
      imageController.text = widget.product!.image!;

      isAvailable = widget.product?.isAvailable;
      selectedCategoryId = widget.product?.categoryId;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product == null ? 'Add New' : 'Edit Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                AppTextField(label: 'Product Name', controller: nameController),
                const SizedBox(height: 20),
                AppTextField(
                    label: 'Description', controller: descriptionController),
                const SizedBox(height: 20),
                //Calling categories drop down menu
                CategoriesDropDown(
                  selectedValue: selectedCategoryId,
                  onChanged: (value) {
                    selectedCategoryId = value;
                    setState(() {});
                  },
                ),
                const SizedBox(height: 20),
                AppTextField(
                    label: 'Add your image URL here',
                    controller: imageController),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: AppTextField(
                        label: 'Price',
                        controller: priceController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: AppTextField(
                        label: 'Stock',
                        controller: stockController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                Row(
                  children: [
                    Expanded(
                      child: IsAvailableSwitch(
                          value: isAvailable ?? false,
                          onChanged: (value) {
                            setState(() {
                              isAvailable = value;
                            });
                          }),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: AppTextField(
                          label: 'Barcode', controller: barcodeController),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                AppElevatedButton(
                    label: 'Submit',
                    onPressed: () async {
                      await onSubmittedProduct();
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //if the controllers are empty, add a new product, if it's not, update
  Future<void> onSubmittedProduct() async {
    if (formKey.currentState!.validate()) {
      if (widget.product == null) {
        // Add a new product
        await sqlHelper.db!.insert(
          'products',
          conflictAlgorithm: ConflictAlgorithm.replace,
          {
            'name': nameController.text,
            'description': descriptionController.text,
            'price': double.parse(priceController.text),
            'stock': int.parse(stockController.text),
            'barcode': barcodeController.text,
            'image': imageController.text,
            'categoryId': selectedCategoryId,
            'isAvaliable': isAvailable ?? false,
          },
        );
      } else {
        // Update an existing product
        await sqlHelper.db!.update(
          'products',
          {
            'name': nameController.text,
            'description': descriptionController.text,
            'price': double.parse(priceController.text),
            'stock': int.parse(stockController.text),
            'barcode': barcodeController.text,
            'image': imageController.text,
            'categoryId': selectedCategoryId,
            'isAvaliable': isAvailable ?? false,
          },
          where: 'id =?',
          whereArgs: [widget.product?.id],
        );
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green,
          content: Text(
            widget.product == null
                ? 'Product added Successfully!'
                : 'Product Updated Successfully!',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      );
      //updated ones don't appear immediately after editing?
      Navigator.pop(context, true);
    }
  }
}