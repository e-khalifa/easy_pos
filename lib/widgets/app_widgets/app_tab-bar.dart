import 'package:flutter/material.dart';

class AppTabBar extends StatefulWidget {
  final String secondLabel;
  final String? thirdLabel;
  final List<Widget> tabContents; // List of widgets for tab contents

  AppTabBar({
    required this.secondLabel,
    this.thirdLabel,
    required this.tabContents, // Require the list of tab contents
    Key? key,
  }) : super(key: key);

  @override
  State<AppTabBar> createState() => _AppTabBarState();
}

class _AppTabBarState extends State<AppTabBar> {
  @override
  Widget build(BuildContext context) {
    try {
      return DefaultTabController(
        length: widget.thirdLabel != null
            ? 3
            : 2, // Adjust the length based on thirdLabel
        child: Column(
          children: [
            Container(
              child: TabBar(
                unselectedLabelColor: Colors.black12,
                indicatorColor: Theme.of(context).primaryColor,
                labelStyle: TextStyle(fontWeight: FontWeight.w600),
                tabs: [
                  Tab(text: 'All'),
                  Tab(text: widget.secondLabel),
                  if (widget.thirdLabel != null)
                    Tab(
                        text: widget
                            .thirdLabel), // Check if thirdLabel is not null
                ],
              ),
            ),
            Expanded(
              child: Container(
                child: TabBarView(
                  children:
                      widget.tabContents, // Use the provided list of widgets
                ),
              ),
            ),
          ],
        ),
      );
    } catch (e) {
      debugPrint('An error occurred: $e');
      return Center(child: Text('Something went wrong'));
    }
  }
}
