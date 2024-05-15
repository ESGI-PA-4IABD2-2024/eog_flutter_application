import 'dart:async';

Future<List<String>> fetchDepartureLocations() async {
  await Future.delayed(const Duration(seconds: 2));
  return [
    'Paris',
    'Lyon',
    'Marseille',
    'Nice',
    'Tokyo',
    'Kyoto',
    'Osaka',
  ];
}

Future<List<String>> fetchArrivalLocations() async {
  await Future.delayed(const Duration(seconds: 2));
  return [
    'New York',
    'Los Angeles',
    'Chicago',
    'San Francisco',
  ];
}
