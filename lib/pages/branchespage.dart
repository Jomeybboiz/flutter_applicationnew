import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/controller/branch_controller.dart';
import 'package:flutter_application_1/model/branch_model.dart';
import 'package:flutter_application_1/pages/home_page.dart';
import 'package:flutter_application_1/themes/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';

class BranchesPage extends StatelessWidget {
  final BranchController branchController = Get.put(BranchController());

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pepino\'s Inventory System',
          style: TextStyle(
            fontWeight: FontWeight.bold, // Set the title to bold
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.background,
        iconTheme: themeProvider.themeData.iconTheme,
        foregroundColor: Theme.of(context).colorScheme.secondary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Add padding to the entire body
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start, // Align text to the left
          children: [
            Center(
              // Center the 'Select Branches' text
              child: Text(
                'Select Branches', // The title above the list
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold, // Make title bold
                  color: Theme.of(context)
                      .colorScheme
                      .secondary, // Use theme color
                ),
              ),
            ),
            const SizedBox(
                height: 20), // Add space between the title and buttons
            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: branchController.getBranchesStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text('No branches available'));
                  } else {
                    final branches = snapshot.data!.docs.map((doc) {
                      final data = doc.data();
                      print('Document data: $data'); // Debugging statement
                      return BranchModel.fromFirestore(
                          doc as DocumentSnapshot<Map<String, dynamic>>, null);
                    }).toList();
                    return GridView.builder(
                      padding:
                          EdgeInsets.all(10), // Overall padding for the grid
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1, // 1 column for vertical stacking
                        mainAxisSpacing:
                            5, // Reduce vertical spacing between buttons
                        crossAxisSpacing: 0, // No extra horizontal space
                        childAspectRatio:
                            5, // Control the width/height ratio of the buttons
                      ),
                      itemCount: branches.length,
                      itemBuilder: (context, index) {
                        final branch = branches[index];
                        return Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 2), // Minimal padding between buttons
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(120, 40), // Smaller button size
                              padding:
                                  EdgeInsets.all(8), // Control internal padding
                              backgroundColor: themeProvider.themeData
                                  .buttonTheme.colorScheme?.background,
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => HomePage(
                                    branchId: branch.id, // Pass branchId
                                  ),
                                ),
                              );
                            },
                            child: Center(
                              // Center the text inside the button
                              child: Text(
                                branch.id, // Display branch ID
                                style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
