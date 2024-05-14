import 'package:flutter/material.dart';
import 'package:location/location.dart';
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

  String? selectedDepartureLocation;
  String? selectedArrivalLocation;
  GlobalKey<FormState> departureKey = GlobalKey<FormState>();
  GlobalKey<FormState> arrivalKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _getUserLocation();
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
                        DropdownButtonFormField<String>(
                          key: departureKey,
                          value: selectedDepartureLocation,
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedDepartureLocation = newValue;
                            });
                          },
                          items: <String>[
                            'Paris',
                            'Lyon',
                            'Marseille',
                            'Nice',
                            'Paris',
                            'Lyon',
                            'Marseille',
                            'Nice',
                            'Paris',
                            'Lyon',
                            'Marseille',
                            'Nice',
                            'Paris',
                            'Lyon',
                            'Marseille',
                            'Nice',
                            'Paris',
                            'Lyon',
                            'Marseille',
                            'Nice',
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          decoration: const InputDecoration(
                            hintText: 'Lieu de départ',
                          ),
                        ).padding(bottom: 10),

                        DropdownButtonFormField<String>(
                          key: arrivalKey,
                          value: selectedArrivalLocation,
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedArrivalLocation = newValue;
                            });
                          },
                          items: <String>[
                            'New York',
                            'Los Angeles',
                            'Chicago',
                            'San Francisco',
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          decoration: const InputDecoration(
                            hintText: "Lieu d'arrivée",
                          ),
                        ).padding(bottom: 20),
                        ElevatedButton(
                          onPressed: () {
                            print('Departure: $selectedDepartureLocation');
                            print('Arrival: $selectedArrivalLocation');

                          },
                          child: const Text('Chercher les trajets possibles')
                              .padding(all: 10),
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
