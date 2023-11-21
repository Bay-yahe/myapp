import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? mapController;
  Location location = Location();
  Set<Marker> markers = {};

  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  _checkPermissions() async {
    var status = await Permission.location.request();
    if (status.isGranted) {
      _getLocation();
    }
  }

  _getLocation() {
    location.onLocationChanged.listen((LocationData currentLocation) {
      // Check if the current location is within your specified limitations.
      if (_isWithinLimitations(
          currentLocation.latitude, currentLocation.longitude)) {
        setState(() {
          // Clear previous markers and add the new one.
          markers.clear();
          markers.add(Marker(
            markerId: const MarkerId('current_location'),
            position:
                LatLng(currentLocation.latitude!, currentLocation.longitude!),
            infoWindow: const InfoWindow(title: 'Your Location'),
          ));
        });

        if (mapController != null) {
          mapController?.animateCamera(
            CameraUpdate.newLatLng(
                LatLng(currentLocation.latitude!, currentLocation.longitude!)),
          );
        }
      }
    });
  }

  bool _isWithinLimitations(double? lat, double? long) {
    if (lat != null && long != null) {
      // Implement your logic to check if the location is within limitations.
      // For simplicity, we'll use hardcoded values for your specified limitations.
      return (lat >= 14.1806 && lat <= 14.1591) &&
          (long >= 121.2655 && long <= 121.2827);
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Location Tracking'),
      ),
      body: GoogleMap(
        onMapCreated: (GoogleMapController controller) {
          mapController = controller;
        },
        initialCameraPosition: const CameraPosition(
          target: LatLng(14.1700, 121.2736), // Initial camera position
          zoom: 15.0, // Zoom level
        ),
        markers: markers,
      ),
    );
  }
}
