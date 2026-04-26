# Event Finder App (Flutter)

## Overview
This Flutter app helps users discover nearby events such as concerts, sports events, and meetups.

## Implemented Screens
- Home Screen
- Event Detail Screen

## Features
- Fetches event data dynamically from a mock GET API
- Displays events in a scrollable card list
- Shows event image, title, date, time, location, and distance
- Navigates from Home to Event Detail on card tap
- Includes loading, error, and empty states
- Includes search/filter and pull-to-refresh
- Includes saved events/profile UI as extra screens

## Mock API Endpoint
https://event-finder-aayush.free.beeceptor.com/events

## Tech Stack
- Flutter
- Dart
- HTTP package

## Project Structure
- `lib/screens` - UI screens
- `lib/models` - Event data model
- `lib/services` - API handling
- `lib/widgets` - Reusable UI components

## How to Run
1. Run `flutter pub get`
2. Run `flutter run`

## APK
`APK_OUTPUT/event_finder-release.apk`

## Demo Video
https://www.loom.com/share/3982db08e04f42a8a9cdbffc79cbb5a5

## Short Explanation
Implemented screens are the Home Screen and Event Detail Screen. The Home Screen fetches events from a Beeceptor mock GET endpoint through `ApiService`, converts JSON into `Event` models, and renders a searchable, pull-to-refresh event list with loading, error, and empty states. Tapping a card opens the Event Detail Screen, which shows the banner image, category, date, time, location, distance, description, and Get Tickets CTA. Code is organized into models, services, screens, and widgets for readability and reuse. The main challenge was keeping the API parser flexible for common mock API payload shapes while preserving clear UI states.
