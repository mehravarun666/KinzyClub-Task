// lib/widgets/transaction_section.dart
import 'package:flutter/material.dart';

class TransactionSection extends StatelessWidget {
  const TransactionSection({super.key});

  Widget _transactionItem({
    required String name,
    required String date,
    required String type,
    required VoidCallback onCheckOutPressed,
  }) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Color( 0xFFFFE280)),
                    color: Colors.grey[600],
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold,color: Colors.black54)),
                    const SizedBox(height: 2),
                    Text(date, style: const TextStyle(fontSize: 10, color: Colors.white)),
                  ],
                ),
              ],
            ),
            // Centering the "type" text vertically
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(type, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
              ],
            ),
            const SizedBox(width: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Color(0xFFFFE280),
                borderRadius: BorderRadius.circular(8),
              ),
              child: GestureDetector(
                onTap: onCheckOutPressed,
                child: Text("Check Out", style: TextStyle(fontSize: 10, color: Colors.grey[800])),
              ),
            ),
          ],
        ),
        const Divider(thickness: 1),
      ],
    );

  }

  @override
  Widget build(BuildContext context) {
    SizedBox space = SizedBox(height: MediaQuery.of(context).size.height * 0.01);

    return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFECB3), Colors.grey[800]!, Colors.grey[900]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
           Text(
          "Latest Transaction",
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold,color: Colors.white),
        ),
        Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    decoration: BoxDecoration(
    color: Color( 0xFFFFE280),
    borderRadius: BorderRadius.circular(8),
    ),
          child: Row(
            children: const [
              Text("Check More", style: TextStyle(fontSize: 10, color: Colors.black)),
              SizedBox(width: 2),
              Icon(Icons.arrow_forward, size: 15, color: Colors.black),
            ],
          ),
        ),
          ],
          ),
            space,
            _transactionItem(
              name: "Karan Dixit",
              date: "Aug, 25, 2024",
              type: "Payment",
              onCheckOutPressed: () {
                // Handle Check Out action
              },
            ),
            const SizedBox(height: 8),
            _transactionItem(
              name: "Aditi Rao",
              date: "Jul, 09, 2024",
              type: "Transfer",
              onCheckOutPressed: () {
                // Handle Check Out action
              },
            ),
            const SizedBox(height: 8),
            _transactionItem(
              name: "Devang Ar",
              date: "Jun, 21, 2024",
              type: "Payment",
              onCheckOutPressed: () {
                // Handle Check Out action
              },
            ),
          ],
        ),
    );
  }
}
