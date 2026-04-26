import 'package:flutter/material.dart';

import '../models/event_model.dart';
import '../services/api_service.dart';
import '../widgets/event_card.dart';
import 'event_detail_screen.dart';
import 'profile_screen.dart';
import 'saved_events_screen.dart';

class HomeScreen extends StatefulWidget {
  final ApiService apiService;

  const HomeScreen({super.key, this.apiService = const ApiService()});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Event> _allEvents = [];
  List<Event> _filteredEvents = [];
  final List<Event> _savedEvents = [];
  bool _isLoading = true;
  String _error = '';
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  Future<void> _loadEvents({bool showLoader = true}) async {
    if (showLoader) {
      setState(() {
        _isLoading = true;
        _error = '';
      });
    }

    try {
      final fetchedEvents = await widget.apiService.fetchEvents();
      if (!mounted) {
        return;
      }

      setState(() {
        _allEvents = fetchedEvents;
        _filteredEvents = _filterEvents(fetchedEvents);
        _error = '';
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        _error = e.toString().replaceFirst('Exception: ', '');
        _isLoading = false;
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
        _allEvents = fetchedEvents;
        _filteredEvents = _filterEvents(fetchedEvents);
        _error = '';
      });
    } catch (e) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
      );
    }
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query.trim().toLowerCase();
      _filteredEvents = _filterEvents(_allEvents);
    });
  }

  List<Event> _filterEvents(List<Event> events) {
    if (_searchQuery.isEmpty) {
      return List<Event>.from(events);
    }

    return events.where((event) {
      final searchableText = [
        event.title,
        event.category,
        event.location,
      ].join(' ').toLowerCase();

      return searchableText.contains(_searchQuery);
    }).toList();
  }

  bool _isSaved(Event event) {
    return _savedEvents.any((savedEvent) => savedEvent.id == event.id);
  }

  void _toggleSavedEvent(Event event) {
    final bool wasSaved = _isSaved(event);

    setState(() {
      if (wasSaved) {
        _savedEvents.removeWhere((savedEvent) => savedEvent.id == event.id);
      } else {
        _savedEvents.add(event);
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
            tooltip: 'Saved events',
            icon: const Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SavedEventsScreen(
                    events: _savedEvents,
                    onToggleSaved: _toggleSavedEvent,
                    isSaved: _isSaved,
                  ),
                ),
              );
            },
          ),
          IconButton(
            tooltip: 'Profile',
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileScreen(
                    savedEvents: _savedEvents,
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
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error.isNotEmpty) {
      return _ErrorState(message: _error, onRetry: _loadEvents);
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
            child: RefreshIndicator(
              onRefresh: refreshEvents,
              child: _filteredEvents.isEmpty
                  ? _EmptyEventsList(
                      message: _allEvents.isEmpty
                          ? 'No events available'
                          : 'No events found',
                    )
                  : ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: _filteredEvents.length,
                      itemBuilder: (context, index) {
                        final event = _filteredEvents[index];
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

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.cloud_off_outlined,
              size: 44,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyEventsList extends StatelessWidget {
  final String message;

  const _EmptyEventsList({required this.message});

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        SizedBox(height: MediaQuery.sizeOf(context).height * 0.22),
        Icon(Icons.event_busy_outlined, size: 42, color: Colors.grey.shade600),
        const SizedBox(height: 10),
        Center(
          child: Text(message, style: TextStyle(color: Colors.grey.shade700)),
        ),
      ],
    );
  }
}
