import 'package:flutter/material.dart';

import '../models/event_model.dart';
import '../widgets/event_card.dart';
import 'event_detail_screen.dart';

class SavedEventsScreen extends StatefulWidget {
  final List<Event> events;
  final void Function(Event event) onToggleSaved;
  final bool Function(Event event) isSaved;

  const SavedEventsScreen({
    super.key,
    required this.events,
    required this.onToggleSaved,
    required this.isSaved,
  });

  @override
  State<SavedEventsScreen> createState() => _SavedEventsScreenState();
}

class _SavedEventsScreenState extends State<SavedEventsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Saved Events')),
      body: widget.events.isEmpty
          ? const Center(child: Text('No saved events'))
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: widget.events.length,
              itemBuilder: (context, index) {
                final event = widget.events[index];
                return EventCard(
                  event: event,
                  isSaved: widget.isSaved(event),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EventDetailScreen(event: event),
                      ),
                    );
                  },
                  onToggleSaved: () {
                    widget.onToggleSaved(event);
                    setState(() {});
                  },
                );
              },
            ),
    );
  }
}
