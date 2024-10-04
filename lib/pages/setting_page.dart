import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../themes/theme_provider.dart';

class SettingsPage extends StatelessWidget{
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
   final themeProvider = Provider.of<ThemeProvider>(context);
    // TODO: implement build
    return Scaffold(appBar: AppBar(title: Text("Setting"),
    backgroundColor: themeProvider.themeData.colorScheme.background,
    ),
    backgroundColor: themeProvider.themeData.colorScheme.background,
    body: Column(
      children: [
        Container( 
          decoration: 
          BoxDecoration(color: themeProvider.themeData.colorScheme.secondary,
          borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.only(left: 25 , top: 10, right: 25),
          padding: const EdgeInsets.all(25.0),
      child:  Row( 
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
       Text("Dark Mode" , style: TextStyle(fontWeight: FontWeight.bold, 
       color: themeProvider.themeData.colorScheme.inversePrimary,
       ),
      ),


      CupertinoSwitch(value: Provider.of<ThemeProvider>(context ,listen: false)
       .isDarkMode, 
      onChanged: (value) => Provider.of<ThemeProvider>(context ,listen: false)
       .toggleTheme(),
        ),
       ],
     ),
        ),
    ],
     ),
    );
  }
}