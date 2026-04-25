import 'package:flutter/material.dart';

import '../models/event_model.dart';

class EventDetailScreen extends StatelessWidget {
  final Event event;

  const EventDetailScreen({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(event.title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: SizedBox(
                width: double.infinity,
                height: 200,
                child: Image.network(
                  event.image,
                  fit: BoxFit.cover,
                  errorBuilder: (_, error, stackTrace) {
                    return const ColoredBox(
                      color: Color(0xFFE0E0E0),
                      child: Center(child: Icon(Icons.broken_image)),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              event.title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              event.category,
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 18),
                const SizedBox(width: 8),
                Expanded(child: Text('${event.date} • ${event.time}')),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.location_on, size: 18),
                const SizedBox(width: 8),
                Expanded(child: Text(event.location)),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              event.description,
              style: const TextStyle(fontSize: 16, height: 1.6),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Get Tickets'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
