// lib/pages/statistics_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/statistics_provider.dart';
import '../widgets/custom_app_bar.dart';

class StatisticsPage extends StatefulWidget {
  @override
  _StatisticsPageState createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    // Initialize statistics provider
    Future.microtask(() {
      Provider.of<StatisticsProvider>(context, listen: false).initialize();
    });
  }

  Future<void> _selectDate() async {
    // Allow selecting a date range for statistics
    DateTimeRange? picked = await showDateRangePicker(
      context: context,
      initialDateRange: DateTimeRange(
        start: DateTime.now().subtract(Duration(days: 30)),
        end: DateTime.now(),
      ),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      locale: Locale('de', 'DE'),
    );
    
    if (picked != null) {
      Provider.of<StatisticsProvider>(context, listen: false)
          .setDateRange(picked.start, picked.end);
    }
  }

  void _onStatsTap() {
    // Already on statistics page, no action needed
  }

  @override
  Widget build(BuildContext context) {
    final statsProvider = Provider.of<StatisticsProvider>(context);
    
    return Scaffold(
      appBar: CustomAppBar(
        selectedDate: _selectedDate,
        onCalendarTap: _selectDate,
        onStatsTap: _onStatsTap,
        title: 'Statistiken',
      ),
      body: statsProvider.isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Zeitraum: ${_formatDate(statsProvider.startDate)} - ${_formatDate(statsProvider.endDate)}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  // Statistics content placeholder
                  Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Ernährung',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 16),
                          Center(
                            child: Text(
                              'Hier werden bald Statistiken angezeigt',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                          // You can add charts, data tables, etc. here
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Körperwerte',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 16),
                          Center(
                            child: Text(
                              'Hier werden bald Statistiken angezeigt',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                          // You can add charts, data tables, etc. here
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}.${date.month}.${date.year}';
  }
}