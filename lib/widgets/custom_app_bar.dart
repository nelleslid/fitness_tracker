// lib/widgets/custom_app_bar.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final DateTime selectedDate;
  final VoidCallback onCalendarTap;
  final VoidCallback onStatsTap;
  final String? title;

  CustomAppBar({
    required this.selectedDate,
    required this.onCalendarTap,
    required this.onStatsTap,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: title != null 
          ? Text(title!, style: TextStyle(fontWeight: FontWeight.bold))
          : Text(
              DateFormat('EEEE, d. MMMM', 'de').format(selectedDate),
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
      backgroundColor: Colors.grey[50],
      elevation: 0,
      actions: [
        IconButton(
          icon: Icon(Icons.bar_chart),
          onPressed: onStatsTap,
        ),
        IconButton(
          icon: Icon(Icons.calendar_today),
          onPressed: onCalendarTap,
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}