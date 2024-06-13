import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:sqflite/sqflite.dart';

import '../helpers/sql_helper.dart';
import '../models/order.dart';
import '../models/order_item.dart';
import '../models/product.dart';
import '../widgets/app_elevated_button.dart';

class SalesOpsPage extends StatefulWidget {
  final Order? order;
  const SalesOpsPage({this.order, super.key});

  @override
  State<SalesOpsPage> createState() => _SalesOpsPageState();
}

class _SalesOpsPageState extends State<SalesOpsPage> {
  List<Product>? products;
  List<OrderItem>? selectedOrderItems;
  String? orderLabel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.order == null ? 'New Sale' : 'Edit Sale'),
      ),
    );
  }
}
