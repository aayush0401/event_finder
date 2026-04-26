class Event {
  final int id;
  final String title;
  final String category;
  final String date;
  final String time;
  final String location;
  final String image;
  final String distance;
  final String description;

  const Event({
    required this.id,
    required this.title,
    required this.category,
    required this.date,
    required this.time,
    required this.location,
    required this.image,
    required this.distance,
    required this.description,
  });

  static int _toInt(dynamic value) {
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    if (value is String) {
      return int.tryParse(value) ?? 0;
    }
    return 0;
  }

  static dynamic _firstValue(Map<String, dynamic> json, List<String> keys) {
    for (final key in keys) {
      final value = json[key];
      if (value != null) {
        return value;
      }
    }

    return null;
  }

  static String _toStringValue(dynamic value, {String fallback = ''}) {
    if (value == null) {
      return fallback;
    }

    final stringValue = value.toString().trim();
    return stringValue.isEmpty ? fallback : stringValue;
  }

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: _toInt(_firstValue(json, const ['id', 'eventId', 'event_id'])),
      title: _toStringValue(json['title'], fallback: 'Untitled Event'),
      category: _toStringValue(json['category'], fallback: 'General'),
      date: _toStringValue(json['date'], fallback: 'TBD'),
      time: _toStringValue(json['time'], fallback: 'TBD'),
      location: _toStringValue(json['location'], fallback: 'Unknown location'),
      image: _toStringValue(
        _firstValue(json, const ['imageUrl', 'image_url', 'image']),
      ),
      distance: _toStringValue(
        _firstValue(json, const ['distance', 'distanceInfo']),
        fallback: 'N/A',
      ),
      description: _toStringValue(
        json['description'],
        fallback: 'No description available.',
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'date': date,
      'time': time,
      'location': location,
      'imageUrl': image,
      'distance': distance,
      'description': description,
    };
  }
}
