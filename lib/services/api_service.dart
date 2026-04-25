import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/event_model.dart';

class ApiService {
  static const String _eventsUrl =
      'https://event-finder-aayush.free.beeceptor.com/events';

  Future<List<Event>> fetchEvents() async {
    try {
      final response =
          await http.get(Uri.parse(_eventsUrl)).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final dynamic decoded = jsonDecode(response.body);
        final List<dynamic> jsonList;

        if (decoded is List<dynamic>) {
          jsonList = decoded;
        } else if (decoded is Map<String, dynamic> && decoded['data'] is List<dynamic>) {
          jsonList = decoded['data'] as List<dynamic>;
        } else {
          throw const FormatException('Invalid events payload');
        }

        return jsonList
            .whereType<Map<String, dynamic>>()
            .map(Event.fromJson)
            .toList();
      }

      throw Exception('Failed to load events');
    } on TimeoutException {
      throw Exception('Request timed out. Please try again.');
    } on FormatException {
      throw Exception('Invalid server response. Please try again later.');
    } on http.ClientException {
      throw Exception('Network error. Check your internet connection.');
    } catch (_) {
      throw Exception('Failed to load events');
    }
  }
}
