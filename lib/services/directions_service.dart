import 'dart:async';
import 'dart:convert';
// ignore: avoid_web_libraries_in_flutter
import 'dart:js' as js;
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Chama o DirectionsService do Maps JS já carregado na página (sem CORS).
/// Funciona apenas em Flutter Web. Para Android/iOS usar HTTP direto.
class DirectionsService {
  static Future<List<LatLng>> getRoute({
    required LatLng origin,
    required LatLng destination,
    List<LatLng> waypoints = const [],
  }) {
    final completer = Completer<List<LatLng>>();

    final waypointsJson = jsonEncode(
      waypoints.map((w) => {'lat': w.latitude, 'lng': w.longitude}).toList(),
    );

    try {
      js.context.callMethod('goschoolGetDirections', [
        origin.latitude,
        origin.longitude,
        destination.latitude,
        destination.longitude,
        waypointsJson,
        js.allowInterop((String resultJson) {
          try {
            final List decoded = jsonDecode(resultJson);
            final points = decoded
                .map((p) => LatLng(
                      (p['lat'] as num).toDouble(),
                      (p['lng'] as num).toDouble(),
                    ))
                .toList();
            completer.complete(points);
          } catch (_) {
            completer.complete([]);
          }
        }),
      ]);
    } catch (e) {
      completer.complete([]);
    }

    return completer.future;
  }
}