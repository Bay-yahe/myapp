import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MapScreen(),
    );
  }
}

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController _controller;
  TextEditingController _locationController = TextEditingController();
  Marker? _selectedMarker;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Location Picker'),
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: (controller) => _controller = controller,
            onTap: _selectLocation,
            markers: _markers,
            initialCameraPosition: CameraPosition(
              target: LatLng(14.1591, 121.2742),
              zoom: 15,
            ),
          ),
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: TextField(
              controller: _locationController,
              decoration: InputDecoration(
                hintText: 'Selected Location',
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    setState(() {
                      _clearSelectedLocation();
                    });
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Set<Marker> _markers = Set<Marker>();

  void _selectLocation(LatLng position) async {
    _clearSelectedLocation();

    _selectedMarker = Marker(
      markerId: MarkerId('selected-location'),
      position: position,
      draggable: true,
      onDragEnd: (dragPosition) {
        _updateSelectedLocation(dragPosition);
      },
      icon: BitmapDescriptor.defaultMarkerWithHue(
        BitmapDescriptor.hueRed,
      ),
      infoWindow: InfoWindow(
        title: 'Selected Location',
        snippet: 'This is the location you picked.',
      ),
    );

    _controller.animateCamera(CameraUpdate.newLatLng(position));

    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    if (placemarks != null && placemarks.isNotEmpty) {
      Placemark placemark = placemarks[0];
      String address =
          '${placemark.name}, ${placemark.locality}, ${placemark.country}';
      _locationController.text = address;
    }

    setState(() {
      _markers.add(_selectedMarker!);
    });
  }

  void _updateSelectedLocation(LatLng position) async {
    _clearSelectedLocation();

    _selectedMarker = Marker(
      markerId: MarkerId('selected-location'),
      position: position,
      draggable: true,
      onDragEnd: (dragPosition) {
        _updateSelectedLocation(dragPosition);
      },
      icon: BitmapDescriptor.defaultMarkerWithHue(
        BitmapDescriptor.hueRed,
      ),
      infoWindow: InfoWindow(
        title: 'Selected Location',
        snippet: 'This is the location you picked.',
      ),
    );

    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    if (placemarks != null && placemarks.isNotEmpty) {
      Placemark placemark = placemarks[0];
      String address =
          '${placemark.name}, ${placemark.locality}, ${placemark.country}';
      _locationController.text = address;
    }

    setState(() {
      _markers.add(_selectedMarker!);
    });
  }

  void _clearSelectedLocation() {
    if (_selectedMarker != null) {
      setState(() {
        _markers.remove(_selectedMarker);
        _selectedMarker = null;
      });
    }
  }
}
