import 'dart:convert';
import '../config.dart';
import '../road_page/road_page.dart';
import '../road_page/road_page_error.dart';
import 'map_locations.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'package:styled_widget/styled_widget.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late GoogleMapController mapController;
  Location location = Location();
  LatLng _initialPosition = const LatLng(48.8534, 2.3488);

  late Future<List<String>> _departureLocationsFuture;
  late Future<List<String>> _arrivalLocationsFuture;
  String? selectedDepartureLocation;
  String? selectedArrivalLocation;
  GlobalKey<FormState> departureKey = GlobalKey<FormState>();
  GlobalKey<FormState> arrivalKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _getUserLocation();
    _departureLocationsFuture = fetchDepartureLocations();
    _arrivalLocationsFuture = fetchArrivalLocations();
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _getUserLocation() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    LocationData currentLocation = await location.getLocation();
    setState(() {
      _initialPosition = LatLng(currentLocation.latitude!, currentLocation.longitude!);
      mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: _initialPosition, zoom: 11.5),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.green[200],
      ),
      home: Scaffold(
        body: Column(
          children: <Widget>[
            Expanded(
              child: GoogleMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: _initialPosition,
                  zoom: 11.5,
                ),
                myLocationEnabled: true,
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: <Widget>[
                        FutureBuilder<List<String>>(
                          future: _departureLocationsFuture,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const Center(child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Center(child: Text('Error: ${snapshot.error}'));
                            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                              return const Center(child: Text('No departure locations found.'));
                            } else {
                              return DropdownSearch<String>(
                                key: departureKey,
                                items: snapshot.data!,
                                selectedItem: selectedDepartureLocation,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedDepartureLocation = newValue;
                                  });
                                },
                                dropdownDecoratorProps: const DropDownDecoratorProps(
                                  dropdownSearchDecoration: InputDecoration(
                                    labelText: 'Lieu de départ',
                                    hintText: 'Lieu de départ',
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 5,
                                    ),
                                  ),
                                ),
                                popupProps: const PopupProps.menu(
                                  showSearchBox: true,
                                ),
                              ).padding(bottom: 10);
                            }
                          },
                        ),
                        FutureBuilder<List<String>>(
                          future: _arrivalLocationsFuture,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const Center(child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Center(child: Text('Error: ${snapshot.error}'));
                            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                              return const Center(child: Text('No arrival locations found.'));
                            } else {
                              return DropdownSearch<String>(
                                key: arrivalKey,
                                items: snapshot.data!,
                                selectedItem: selectedArrivalLocation,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedArrivalLocation = newValue;
                                  });
                                },
                                dropdownDecoratorProps: const DropDownDecoratorProps(
                                  dropdownSearchDecoration: InputDecoration(
                                    labelText: "Lieu d'arrivée",
                                    hintText: "Lieu d'arrivée",
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 5,
                                    ),
                                  ),
                                ),
                                popupProps: const PopupProps.menu(
                                  showSearchBox: true,
                                ),
                              ).padding(bottom: 20);
                            }
                          },
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            String? departure = selectedDepartureLocation;
                            String? arrival = selectedArrivalLocation;

                            String apiUrl = '${Config.apiUrl}/departure-arrival/$departure/$arrival';
                            try {
                              http.Response response = await http.get(Uri.parse(apiUrl));
                              if (response.statusCode == 200) {
                                print('Réponse de l\'API: ${response.body}');
                                final responseData = jsonDecode(response.body);
                                // Navigate to RoadPage
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => RoadPage(responseData: responseData)),
                                );
                              } else {
                                print('Erreur: ${response.statusCode}');
                                print('Message: ${response.body}');
                                // Navigate to ErrorRoadPage
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const ErrorRoadPage()),
                                );
                              }
                            } catch (e) {
                              print('Erreur de connexion: $e');
                              // Navigate to ErrorRoadPage in case of a connection error
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const ErrorRoadPage()),
                              );
                            }
                          },
                          child: const Text('Chercher les trajets possibles').padding(all: 10),
                        ),
                      ],
                    ),
                  )
              ),
            ),
          ],
        ),
      ),
    );
  }
}
