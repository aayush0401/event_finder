import 'package:flutter/material.dart';

import '../models/event_model.dart';
import 'saved_events_screen.dart';

class ProfileScreen extends StatelessWidget {
  final List<Event> savedEvents;
  final void Function(Event event) onToggleSaved;
  final bool Function(Event event) isSaved;

  const ProfileScreen({
    super.key,
    this.savedEvents = const <Event>[],
    this.onToggleSaved = _noopToggle,
    this.isSaved = _defaultIsSaved,
  });

  static void _noopToggle(Event event) {}

  static bool _defaultIsSaved(Event event) => false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 8),
            const CircleAvatar(radius: 40, child: Icon(Icons.person, size: 40)),
            const SizedBox(height: 10),
            const Text(
              'Aayush Kaushik',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              'aayush@example.com',
              style: TextStyle(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 24),
            ListTile(
              leading: const Icon(Icons.favorite),
              title: const Text('Saved Events'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SavedEventsScreen(
                      events: savedEvents,
                      onToggleSaved: onToggleSaved,
                      isSaved: isSaved,
                    ),
                  ),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Settings clicked')),
                );
              },
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }
}
