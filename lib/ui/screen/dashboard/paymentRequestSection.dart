// lib/widgets/payment_request_section.dart
import 'package:flutter/material.dart';

class PaymentRequestSection extends StatelessWidget {
  const PaymentRequestSection({super.key});

  Widget _paymentRequestItem({
    required String name,
    required String phone,
    required String amount,
    required String date,
    required VoidCallback onPayPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: Colors.grey),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 65,
              width: 75,
              decoration: BoxDecoration(
                border: Border.all(color: Color( 0xFFFFE280)),
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold,color: Colors.white)),
                  const SizedBox(height: 2),
                  Text(phone, style: const TextStyle(fontSize: 12, color: Colors.green)),
                  const SizedBox(height: 2),
                  Text("$amount ₹", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: Colors.white)),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text("Date Of Request:", style: TextStyle(fontSize: 8, color: Colors.grey)),
                Text(date, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold,color: Colors.white)),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  decoration: BoxDecoration(
                    color: Color( 0xFFFFE280),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: GestureDetector(
                    onTap: onPayPressed,
                    child:  Text("Pay Out", style: TextStyle(fontSize: 10, color: Colors.grey[800])),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SizedBox space = SizedBox(height: MediaQuery.of(context).size.height * 0.01);

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Latest Payment Request",
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold,color: Colors.white),
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
          _paymentRequestItem(
            name: "Kuldeep Singh",
            phone: "+91 9387699875",
            amount: "5200.00",
            date: "Aug, 25, 2024",
            onPayPressed: () {
              // Handle Pay Out action
            },
          ),
          const SizedBox(height: 8),
          _paymentRequestItem(
            name: "Dev Raj",
            phone: "+91 9214334758",
            amount: "1100.00",
            date: "Aug, 19, 2024",
            onPayPressed: () {
              // Handle Pay Out action
            },
          ),
        ],
      ),
    );
  }
}
