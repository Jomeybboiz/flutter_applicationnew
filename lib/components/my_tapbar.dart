import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyTabBar extends StatelessWidget {
  final TabController tabController;

  const MyTabBar({super.key, required this.tabController});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context)
          .colorScheme
          .primary, // Background color for the tabs
      child: TabBar(
        controller: tabController,
        indicatorColor: Colors.transparent, // Hide the default indicator
        tabs: [
          _buildTab("Stock"),
          _buildTab("Low Stock"),
          _buildTab("Out of Stock"),
        ],
      ),
    );
  }

  Widget _buildTab(String text) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white, // Background color of the tab
        borderRadius: BorderRadius.circular(8.0), // Rounded corners
      ),
      padding:
          const EdgeInsets.symmetric(vertical: 12.0), // Padding inside the tab
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black, // Text color
        ),
      ),
    );
  }
}
