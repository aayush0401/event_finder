import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:event_finder/models/event_model.dart';
import 'package:event_finder/screens/home_screen.dart';
import 'package:event_finder/services/api_service.dart';

class _SuccessApiService extends ApiService {
  final List<Event> _events;

  _SuccessApiService(this._events);

  @override
  Future<List<Event>> fetchEvents() async => _events;
}

class _DelayedApiService extends ApiService {
  final Future<List<Event>> Function() _loader;

  _DelayedApiService(this._loader);

  @override
  Future<List<Event>> fetchEvents() => _loader();
}

class _FailingApiService extends ApiService {
  final String message;

  _FailingApiService(this.message);

  @override
  Future<List<Event>> fetchEvents() async => throw Exception(message);
}

Event _sampleEvent({int id = 1, String title = 'Tech Meetup'}) {
  return Event(
    id: id,
    title: title,
    category: 'Technology',
    date: '2026-05-01',
    time: '18:30',
    location: 'City Hall',
    image: 'https://example.com/event.jpg',
    distance: '2.4 km',
    description: 'A community meetup for developers.',
  );
}

void main() {
  testWidgets('shows loading indicator, then events list', (
    WidgetTester tester,
  ) async {
    final completer = Completer<List<Event>>();

    await tester.pumpWidget(
      MaterialApp(
        home: HomeScreen(apiService: _DelayedApiService(() => completer.future)),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    completer.complete([_sampleEvent()]);
    await tester.pumpAndSettle();

    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.text('Tech Meetup'), findsOneWidget);
    expect(find.byType(Card), findsOneWidget);
  });

  testWidgets('tap event card navigates to detail and shows full details', (
    WidgetTester tester,
  ) async {
    final event = _sampleEvent();

    await tester.pumpWidget(
      MaterialApp(home: HomeScreen(apiService: _SuccessApiService([event]))),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byType(Card).first);
    await tester.pumpAndSettle();

    expect(find.text('Tech Meetup'), findsWidgets);
    expect(find.text('Technology'), findsOneWidget);
    expect(find.text('2026-05-01 • 18:30'), findsOneWidget);
    expect(find.text('City Hall'), findsOneWidget);
    expect(find.text('A community meetup for developers.'), findsOneWidget);
    expect(find.text('Get Tickets'), findsOneWidget);
  });

  testWidgets('shows error message when API fails', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: HomeScreen(apiService: _FailingApiService('Failed to load events')),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Failed to load events'), findsOneWidget);
  });

  testWidgets('shows empty state when API returns no events', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(home: HomeScreen(apiService: _SuccessApiService([]))),
    );
    await tester.pumpAndSettle();

    expect(find.text('No events available'), findsOneWidget);
  });
}
