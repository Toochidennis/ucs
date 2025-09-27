import 'package:flutter/material.dart';

class StudentDashboardView extends StatelessWidget {
  const StudentDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    // Next step we’ll replace with a proper stepper/timeline and summary cards.
    return Scaffold(
      appBar: AppBar(title: const Text('Student Dashboard')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          Text('Clearance Progress', style: TextStyle(fontWeight: FontWeight.w600)),
          SizedBox(height: 12),
          // Placeholder tiles
          ListTile(leading: Icon(Icons.receipt_long), title: Text('Faculty Finance Office'), subtitle: Text('Pending')),
          ListTile(leading: Icon(Icons.local_library), title: Text('Library'), subtitle: Text('Pending')),
          ListTile(leading: Icon(Icons.badge), title: Text('Alumni Office'), subtitle: Text('Pending')),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {}, label: const Text('Continue Clearance'), icon: const Icon(Icons.play_arrow),
      ),
    );
  }
}
