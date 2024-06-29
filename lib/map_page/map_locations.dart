import 'dart:async';
import 'dart:convert';
import '../config.dart';
import 'package:http/http.dart' as http;


Future<List<String>> fetchDepartureLocations() async {
  final List<Map<String, String>> stations = await fetchStationList();
  return stations.map((station) => station['nom']!).toList();
}

Future<List<String>> fetchArrivalLocations() async {
  final List<Map<String, String>> stations = await fetchStationList();
  return stations.map((station) => station['nom']!).toList();
}

Future<String?> fetchStationsData() async {
  String apiUrl = '${Config.apiUrl}/request/stations';
  try {
    http.Response response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      return utf8.decode(response.bodyBytes);
    } else {
      print('Erreur: ${response.statusCode}');
      return null;
    }
  } catch (e) {
    print('Erreur de connexion: $e');
    return null;
  }
}

Future<List<Map<String, String>>> fetchStationList() async {
  final String? jsonData = await fetchStationsData();
  final List<dynamic> data = json.decode(jsonData!)['stations'];
  return data.map((station) => Map<String, String>.from(station)).toList();
}
