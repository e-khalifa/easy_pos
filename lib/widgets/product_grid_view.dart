import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ProductGridViewItem extends StatelessWidget {
  final String? name;
  final String? description;
  final String? category;
  final double? price;
  final int? stock;
  final String? imageUrl;

  Future<void> Function() onDeleted;
  void Function()? onEdit;

  ProductGridViewItem(
      {super.key,
      required this.name,
      this.description,
      required this.onDeleted,
      required this.onEdit,
      required this.category,
      required this.price,
      required this.stock,
      this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color.fromARGB(255, 250, 250, 250),
      surfaceTintColor: Colors.white,
      child: Dismissible(
        key: Key(name!),
        onDismissed: (direction) {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Confirm Deleting'),
                  content:
                      const Text('Are you sure you want to delete this item?'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () async {
                        Navigator.pop(context);
                        await onDeleted();

                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            backgroundColor: Colors.black.withOpacity(0.8),
                            content: Text(
                              '$name deleted',
                              textAlign: TextAlign.center,
                            )));
                      },
                      child: const Text('Delete'),
                    ),
                  ],
                );
              });
        },
        direction: DismissDirection.endToStart,
        background: Container(
          color: Colors.red,
          child: const Padding(
            padding: EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(Icons.delete, color: Colors.white),
                SizedBox(width: 10),
                Text(
                  'Delete',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Stack(children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CachedNetworkImage(
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  imageUrl: imageUrl ?? '',
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.error,
                      size: 40,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              Positioned(
                  top: 0,
                  right: 0,
                  child: IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: onEdit,
                    color: Theme.of(context).primaryColor,
                  )),
            ]),
            SizedBox(
              height: 10,
            ),
            Text(
              name!,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              description!,
              style: const TextStyle(fontSize: 13),
            ),
            SizedBox(height: description == null ? 5 : 10),
            Text(
              'Category: $category',
              style: const TextStyle(fontSize: 12),
            ),
            Divider(
              color: Colors.grey,
            ),
            Text('In Stock: $stock'),
            SizedBox(height: 10),
            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                '$price EGP',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            )
          ]),
        ),
      ),
    );
  }
}
