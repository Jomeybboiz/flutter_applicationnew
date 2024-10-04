import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/branchespage.dart';
import 'package:flutter_application_1/services/auth/auth_gate.dart';
import 'package:flutter_application_1/themes/theme_provider.dart';
import 'package:provider/provider.dart';

class MySliverAppBar extends StatelessWidget {
  final Widget child;
  final Widget title;
  final Widget filter; // New parameter for the filter section

  const MySliverAppBar(
      {super.key,
      required this.child,
      required this.title,
      required this.filter});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 340,
      collapsedHeight: 120,
      floating: false,
      pinned: true,
      actions: [
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PepinosInventoryApp()),
            );
          },
          icon: const Icon(Icons.business),
        ),
      ],
      backgroundColor: Provider.of<ThemeProvider>(context)
          .themeData
          .colorScheme
          .background, // Use theme provider here
      foregroundColor: Provider.of<ThemeProvider>(context)
          .themeData
          .colorScheme
          .inversePrimary, // Use theme provider here
      title: const Text(
        "Pepino's Pizza and Pasta",
        style: TextStyle(
          fontWeight: FontWeight.bold, // Set text to bold
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Padding(
          padding: const EdgeInsets.only(bottom: 50.0),
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.end, // Aligns children at the bottom
            children: [
              child,
              filter, // Add filter section here
            ],
          ),
        ),
        title: title,
        centerTitle: true,
        titlePadding: const EdgeInsets.only(left: 0, right: 0, top: 0),
        expandedTitleScale: 1,
      ),
    );
  }
}
