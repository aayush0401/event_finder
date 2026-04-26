import 'package:flutter/material.dart';

import '../models/event_model.dart';
import 'event_image.dart';

class EventCard extends StatelessWidget {
  final Event event;
  final bool isSaved;
  final VoidCallback onTap;
  final VoidCallback onToggleSaved;

  const EventCard({
    super.key,
    required this.event,
    required this.isSaved,
    required this.onTap,
    required this.onToggleSaved,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 16 / 9,
                child: EventImage(
                  imageUrl: event.image,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      event.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: isSaved ? 'Remove from saved' : 'Save event',
                    onPressed: onToggleSaved,
                    icon: Icon(
                      isSaved ? Icons.favorite : Icons.favorite_border,
                      color: isSaved ? Colors.red : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              _CardMetaRow(
                icon: Icons.calendar_today_outlined,
                text: '${event.date} | ${event.time}',
              ),
              const SizedBox(height: 4),
              _CardMetaRow(
                icon: Icons.location_on_outlined,
                text: '${event.location} | ${event.distance}',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CardMetaRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _CardMetaRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey.shade700),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: Colors.grey.shade800),
          ),
        ),
      ],
    );
  }
}
