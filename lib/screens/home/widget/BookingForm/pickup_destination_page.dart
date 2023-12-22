import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PickupDestinationPage extends StatefulWidget {
  final bool isPickup;
  final ValueChanged<String> onLocationSelected;

  PickupDestinationPage({
    required this.isPickup,
    required this.onLocationSelected,
  });

  @override
  _PickupDestinationPageState createState() => _PickupDestinationPageState();
}

class _PickupDestinationPageState extends State<PickupDestinationPage> {
  GoogleMapController? _controller;
  LatLng? _selectedLocation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isPickup ? 'Pickup Location' : 'Destination'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: GoogleMap(
              onMapCreated: (controller) => _controller = controller,
              initialCameraPosition: CameraPosition(
                target: LatLng(0, 0),
                zoom: 2,
              ),
              markers: _selectedLocation != null
                  ? {
                      Marker(
                        markerId: MarkerId('selected-location'),
                        position: _selectedLocation!,
                        icon: BitmapDescriptor.defaultMarkerWithHue(
                          BitmapDescriptor.hueRed,
                        ),
                      ),
                    }
                  : {},
              onTap: _selectLocation,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                labelText:
                    'Enter ${widget.isPickup ? 'pickup' : 'destination'} location',
              ),
              onChanged: (value) {
                // Handle location text changes if needed
              },
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              if (_selectedLocation != null) {
                // Obtain place ID using Google Places API
                String? placeId = await getPlaceId(
                  _selectedLocation!.latitude,
                  _selectedLocation!.longitude,
                );

                if (placeId != null) {
                  widget.onLocationSelected(placeId);
                  Navigator.pop(context);
                } else {
                  // Handle case when place ID is not obtained
                }
              } else {
                // Handle case when location is not provided
                // You may want to show a message or prevent navigation
              }
            },
            child: Text('Set ${widget.isPickup ? 'Pickup' : 'Destination'}'),
          ),
        ],
      ),
    );
  }

  void _selectLocation(LatLng position) {
    setState(() {
      _selectedLocation = position;
      _controller?.animateCamera(CameraUpdate.newLatLng(position));
    });
  }

  Future<String?> getPlaceId(double latitude, double longitude) async {
    final apiKey = 'AIzaSyBfQ75S4IdLHbJeDqcDnTLmgY4WChaqhbo';
    final baseUrl = 'https://maps.googleapis.com/maps/api/geocode/json';

    final Uri uri =
        Uri.parse('$baseUrl?latlng=$latitude,$longitude&key=$apiKey');

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['results'].isNotEmpty) {
        return data['results'][0]['place_id'];
      }
    }

    return null;
  }
}
