// lib/screens/dashboard_screen.dart
import 'package:credixo/providers/dashboardProvider.dart';
import 'package:credixo/ui/screen/dashboard/appBarDashboard.dart';
import 'package:credixo/ui/screen/dashboard/buttonsDashboard.dart';
import 'package:credixo/ui/screen/dashboard/dropdownDashboard.dart';
import 'package:credixo/ui/screen/dashboard/paymentRequestSection.dart';
import 'package:credixo/ui/screen/dashboard/transactionSection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => DashboardProvider(),
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black87,
                    Colors.black54,
                    Colors.grey[600]!,
                  ],
                ),
              ),
            ),
            SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Consumer<DashboardProvider>(
                builder: (context, provider, child) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      DashboardAppBar(), // Extracted AppBar
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 40, // Set the same height as the button
                                child: TextField(
                                  decoration: InputDecoration(
                                    hintStyle: TextStyle(color: Colors.white),
                                    hintText: "Search",
                                    prefixIcon: Icon(Icons.search, size: 20, color: Colors.white),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    contentPadding: EdgeInsets.symmetric(vertical: 10), // Adjusts the content's vertical padding
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            SizedBox(
                              height: 40,
                              width: 40,
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey[200],
                                  padding: EdgeInsets.zero, // Remove extra padding
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8), // Rounded borders
                                  ),
                                  elevation: 1,
                                ),
                                child: const Icon(
                                  Icons.line_axis_sharp,
                                  size: 24, // Icon size
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Dashboard",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      const SizedBox(height: 10),
                      DashboardDropdowns(), // Extracted Dropdowns
                      const SizedBox(height: 10),
                      DashboardButtons(), // Extracted Buttons
                      const SizedBox(height: 16),
                      const PaymentRequestSection(), // Latest Payment Requests
                      const SizedBox(height: 16),
                      const TransactionSection(), // Latest Transactions
                      const SizedBox(height: 16),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Colors.black54, // Set transparent so container color shows
            elevation: 10,
            selectedItemColor: Colors.green,
            unselectedItemColor: Colors.grey,
            showSelectedLabels: true,
            showUnselectedLabels: false,
            type: BottomNavigationBarType.fixed,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.contacts_outlined),
                activeIcon: Icon(Icons.contacts),
                label: 'Contact List',
              ),
            ],
          ),

      ),
    );
  }
}
