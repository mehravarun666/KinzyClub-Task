// lib/widgets/dashboard_buttons.dart
import 'package:flutter/material.dart';

class DashboardButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _dashboardButton("Payment\nHistory", Icons.history),
        _dashboardButton("Payment\nReceived", Icons.attach_money),
        _dashboardButton("Payment\nReminders", Icons.notifications_active),
        _dashboardButton("Active\nLoan", Icons.account_balance),
      ],
    );
  }

  Widget _dashboardButton(String title, IconData icon) {
    return Expanded(
      child: Card(
        elevation: 6,
        color: Colors.grey[800],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Icon(icon, size: 20,color: Colors.white,),
              const SizedBox(height: 5),
              Text(title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 10,color: Colors.white)),
            ],
          ),
        ),
      ),
    );
  }
}
