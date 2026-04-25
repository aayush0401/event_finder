import 'package:flutter/material.dart';

import '../models/event_model.dart';
import '../services/api_service.dart';
import '../widgets/event_card.dart';
import 'event_detail_screen.dart';
import 'profile_screen.dart';
import 'saved_events_screen.dart';

class HomeScreen extends StatefulWidget {
  final ApiService apiService;

  HomeScreen({super.key, ApiService? apiService})
      : apiService = apiService ?? ApiService();

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Event> allEvents = [];
  List<Event> filteredEvents = [];
  List<Event> savedEvents = [];
  bool isLoading = true;
  String error = '';
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    try {
      final fetchedEvents = await widget.apiService.fetchEvents();
      if (!mounted) {
        return;
      }
      setState(() {
        allEvents = fetchedEvents;
        filteredEvents = List<Event>.from(fetchedEvents);
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) {
        return;
      }
      setState(() {
        error = e.toString().replaceFirst('Exception: ', '');
        isLoading = false;
      });
    }
  }

  Future<void> refreshEvents() async {
    try {
      final fetchedEvents = await widget.apiService.fetchEvents();
      if (!mounted) {
        return;
      }

      setState(() {
        allEvents = fetchedEvents;
        filteredEvents = _searchQuery.isEmpty
            ? List<Event>.from(fetchedEvents)
            : fetchedEvents
                .where(
                  (event) =>
                      event.title.toLowerCase().contains(_searchQuery),
                )
                .toList();
        error = '';
      });
    } catch (e) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString().replaceFirst('Exception: ', ''),
          ),
        ),
      );
    }
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query.trim().toLowerCase();
      filteredEvents = _searchQuery.isEmpty
          ? List<Event>.from(allEvents)
          : allEvents
              .where((event) => event.title.toLowerCase().contains(_searchQuery))
              .toList();
    });
  }

  bool _isSaved(Event event) {
    return savedEvents.any((savedEvent) => savedEvent.id == event.id);
  }

  void _toggleSavedEvent(Event event) {
    final bool wasSaved = _isSaved(event);

    setState(() {
      if (wasSaved) {
        savedEvents.removeWhere((savedEvent) => savedEvent.id == event.id);
      } else {
        savedEvents.add(event);
      }
    });

    final String message = wasSaved ? 'Removed' : 'Saved';
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Events'),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SavedEventsScreen(
                    events: savedEvents,
                    onToggleSaved: _toggleSavedEvent,
                    isSaved: _isSaved,
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileScreen(
                    savedEvents: savedEvents,
                    onToggleSaved: _toggleSavedEvent,
                    isSaved: _isSaved,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (error.isNotEmpty) {
      return Center(child: Text(error));
    }

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          TextField(
            onChanged: _onSearchChanged,
            decoration: InputDecoration(
              hintText: 'Search events...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: allEvents.isEmpty
                ? const Center(child: Text('No events available'))
                : filteredEvents.isEmpty
                    ? const Center(child: Text('No events found'))
                : RefreshIndicator(
                    onRefresh: refreshEvents,
                    child: ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: filteredEvents.length,
                      itemBuilder: (context, index) {
                        final event = filteredEvents[index];
                        return EventCard(
                          event: event,
                          isSaved: _isSaved(event),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    EventDetailScreen(event: event),
                              ),
                            );
                          },
                          onToggleSaved: () => _toggleSavedEvent(event),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
