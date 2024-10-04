import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/my_drawer_tile.dart';
import 'package:flutter_application_1/pages/login_page.dart';
import 'package:flutter_application_1/services/auth/auth_service.dart';
import 'package:flutter_application_1/pages/account_page.dart';
import 'package:flutter_application_1/themes/theme_provider.dart';
import 'package:provider/provider.dart';
import '../pages/setting_page.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthService _authService = AuthService();
    final themeProvider = Provider.of<ThemeProvider>(context);

    // Set dark colors for the drawer items
    Color darkTextColor = themeProvider.themeData.colorScheme.inversePrimary;
    Color darkIconColor = themeProvider.themeData.colorScheme.inversePrimary;

    return Drawer(
      backgroundColor: themeProvider.themeData.colorScheme.background,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 100.0),
            child: Icon(
              Icons.lock_open,
              size: 144,
              color: themeProvider.themeData.colorScheme.inversePrimary,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Divider(
              color: themeProvider.themeData.colorScheme.inversePrimary,
            ),
          ),
          MyDrawerTile(
            text: "Home",
            icon: Icons.home,
            textColor: darkTextColor, // Set dark text color
            iconColor: darkIconColor, // Set dark icon color
            onTap: () => Navigator.pop(context),
          ),
          MyDrawerTile(
            text: "Setting",
            icon: Icons.settings,
            textColor: darkTextColor, // Set dark text color
            iconColor: darkIconColor, // Set dark icon color
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsPage(),
                ),
              );
            },
          ),
          MyDrawerTile(
            text: "Account",
            icon: Icons.person,
            textColor: darkTextColor, // Set dark text color
            iconColor: darkIconColor, // Set dark icon color
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AccountPage(),
                ),
              );
            },
          ),
          const Spacer(),
          MyDrawerTile(
            text: "Logout",
            icon: Icons.logout,
            textColor: darkTextColor, // Set dark text color
            iconColor: darkIconColor, // Set dark icon color
            onTap: () async {
              await _authService.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginPage(
                    onTap: () {},
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 25),
        ],
      ),
    );
  }
}
