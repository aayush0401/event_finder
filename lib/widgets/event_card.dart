import 'package:flutter/material.dart';

import '../models/event_model.dart';

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
			child: InkWell(
				onTap: onTap,
				child: Padding(
					padding: const EdgeInsets.all(12),
					child: Column(
						crossAxisAlignment: CrossAxisAlignment.start,
						children: [
							AspectRatio(
								aspectRatio: 16 / 9,
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
							const SizedBox(height: 10),
							Row(
								children: [
									Expanded(
										child: Text(
											event.title,
											style: const TextStyle(
												fontSize: 18,
												fontWeight: FontWeight.bold,
											),
										),
									),
									IconButton(
										onPressed: onToggleSaved,
										icon: Icon(
											isSaved ? Icons.favorite : Icons.favorite_border,
											color: isSaved ? Colors.red : null,
										),
									),
								],
							),
							const SizedBox(height: 4),
							Text('${event.date} • ${event.time}'),
							const SizedBox(height: 4),
							Text('${event.location} • ${event.distance}'),
						],
					),
				),
			),
		);
	}
}
