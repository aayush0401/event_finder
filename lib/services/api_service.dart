import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/event_model.dart';

class ApiService {
  const ApiService({http.Client? client}) : _client = client;

  static const String _eventsUrl =
      'https://event-finder-aayush.free.beeceptor.com/events';

  final http.Client? _client;

  Future<List<Event>> fetchEvents() async {
    final http.Client client = _client ?? http.Client();
    final bool shouldCloseClient = _client == null;

    try {
      final response = await client
          .get(Uri.parse(_eventsUrl))
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 204) {
        return <Event>[];
      }

      if (response.statusCode != 200) {
        throw Exception('Failed to load events (${response.statusCode}).');
      }

      if (response.body.trim().isEmpty) {
        return <Event>[];
      }

      final dynamic decoded = jsonDecode(response.body);
      final List<dynamic> jsonList = _extractEventList(decoded);

      return jsonList
          .whereType<Map>()
          .map((json) => Event.fromJson(Map<String, dynamic>.from(json)))
          .toList();
    } on TimeoutException {
      throw Exception('Request timed out. Please try again.');
    } on FormatException {
      throw Exception('Invalid server response. Please try again later.');
    } on http.ClientException {
      throw Exception('Network error. Check your internet connection.');
    } finally {
      if (shouldCloseClient) {
        client.close();
      }
    }
  }

  List<dynamic> _extractEventList(dynamic decoded) {
    if (decoded is List<dynamic>) {
      return decoded;
    }

    if (decoded is Map<String, dynamic>) {
      for (final key in const ['events', 'data', 'items']) {
        final value = decoded[key];
        if (value is List<dynamic>) {
          return value;
        }
      }
    }

    throw const FormatException('Invalid events payload');
  }
}
