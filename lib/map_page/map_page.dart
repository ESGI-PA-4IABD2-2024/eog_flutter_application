import 'map_locations.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'package:styled_widget/styled_widget.dart';
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
                              return DropdownButtonFormField<String>(
                                menuMaxHeight: 250.0,
                                key: departureKey,
                                value: selectedDepartureLocation,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedDepartureLocation = newValue;
                                  });
                                },
                                items: snapshot.data!.map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                decoration: const InputDecoration(
                                  hintText: 'Lieu de départ',
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
                              return DropdownButtonFormField<String>(
                                menuMaxHeight: 250.0,
                                key: arrivalKey,
                                value: selectedArrivalLocation,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedArrivalLocation = newValue;
                                  });
                                },
                                items: snapshot.data!.map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                decoration: const InputDecoration(
                                  hintText: "Lieu d'arrivée",
                                ),
                              ).padding(bottom: 20);
                            }
                          },
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            String? departure = selectedDepartureLocation;
                            String? arrival = selectedArrivalLocation;
                            String apiUrl = 'http://192.168.0.202:8000/departure-arrival/$departure/$arrival';
                            try {
                              http.Response response = await http.get(Uri.parse(apiUrl));
                              if (response.statusCode == 200) {
                                print('Réponse de l\'API: ${response.body}');
                              } else {
                                print('Erreur: ${response.statusCode}');
                                print('Message: ${response.body}');
                              }
                            } catch (e) {
                              print('Erreur de connexion: $e');
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
