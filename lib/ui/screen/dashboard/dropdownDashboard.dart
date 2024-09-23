// lib/widgets/dashboard_dropdowns.dart
import 'package:credixo/providers/dashboardProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DashboardDropdowns extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DashboardProvider>(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Borrow Dropdown
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey[600], // Grey background color for the container
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: provider.selectedBorrowOption,
                isExpanded: true,
                icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                dropdownColor: Colors.grey[800], // Grey background for the dropdown list
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white, // White text color for the dropdown items
                ),
                onChanged: (String? newValue) {
                  provider.setBorrowOption(newValue!);
                },
                items: provider.borrowOptions.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, style: const TextStyle(color: Colors.white)),
                  );
                }).toList(),
              ),
            ),
          ),

        ),
        const SizedBox(width: 16),

        // Lender Dropdown
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey[600], // Grey background color for the container
              border: Border.all(
                color: Colors.transparent,
                width: 2,
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: provider.selectedLenderOption,
                isExpanded: true,
                icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                dropdownColor: Colors.grey[800], // Grey background for the dropdown list
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white, // White text color for the dropdown items
                  fontWeight: FontWeight.normal,
                ),
                onChanged: (String? newValue) {
                  provider.setLenderOption(newValue!);
                },
                items: provider.lenderOptions.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, style: const TextStyle(color: Colors.white)),
                  );
                }).toList(),
              ),
            ),
          ),


        ),
      ],
    );
  }
}
