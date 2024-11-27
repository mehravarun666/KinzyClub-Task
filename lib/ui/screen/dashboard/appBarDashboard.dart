// lib/widgets/dashboard_appbar.dart
import 'package:credixo/providers/dashboardProvider.dart';
import 'package:credixo/ui/screen/profileOptions/profileScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DashboardAppBar extends StatelessWidget {
  const DashboardAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final userName = Provider.of<DashboardProvider>(context).userName;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          height: 40,
          width: 40,
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChangeNotifierProvider(
                    create: (_) => DashboardProvider(),
                    child: ProfileScreen(),
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[200],
              padding: EdgeInsets.zero, // Remove extra padding
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8), // Rounded borders
              ),
              elevation: 1,
            ),
            child: const Icon(
              Icons.account_circle_outlined,
              size: 24, // Icon size
            ),
          ),
        ),
        const SizedBox(
          width: 50,
        ),
        Expanded(
          child: Text(
            'WELCOME BACK! ${userName.toUpperCase()}',
            style: const TextStyle(
                fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white),
          ),
        ),
        IconButton(
          icon: const Icon(
            Icons.notifications_none,
            color: Colors.white,
          ),
          onPressed: () {},
        ),
      ],
    );
  }
}
