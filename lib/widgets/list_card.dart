import 'package:flutter/material.dart';

class ListCard extends StatelessWidget {
  final String? name;
  final String? description;
  Future<void> Function() onDeleted;
  void Function()? onEdit;

  final String? category;
  final double? price;
  final int? stock;
  final String? imageUrl;

  ListCard({
    super.key,
    required this.name,
    required this.description,
    required this.onDeleted,
    required this.onEdit,
    this.category,
    this.price,
    this.stock,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      color: Colors.white,
      surfaceTintColor: Colors.white,
      shadowColor: Colors.black.withOpacity(0.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),

      // Swipe to delete

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
          child: ListTile(
            //Only show leading if there is an image
            leading: imageUrl != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      imageUrl!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 30,
                    ),
                  )
                : null,

            title: Text(
              name!,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            subtitle: imageUrl != null
                ? Column(
                    children: [
                      Text(
                        'Category $category',
                        style: const TextStyle(fontSize: 12),
                      ),
                      Text(
                        description!,
                        style: const TextStyle(fontSize: 14),
                      ),
                      Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Price: $price EGP'),
                          Text('In Stock: $stock')
                        ],
                      ),
                    ],
                  )
                : Text(
                    description!,
                    style: const TextStyle(fontSize: 14),
                  ),

            trailing: IconButton(
              onPressed: onEdit,
              icon: Icon(Icons.edit),
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
      ),
    );
  }
}
