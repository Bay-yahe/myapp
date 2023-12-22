import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Uber-like Booking App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const BookingPage(),
    );
  }
}

class BookingPage extends StatefulWidget {
  const BookingPage({super.key});

  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  TextEditingController pickupController = TextEditingController();
  TextEditingController destinationController = TextEditingController();

  Position? currentLocation;
  GoogleMapController? mapController;
  Marker? pickupLocationMarker;
  Marker? destinationLocationMarker;
  double estimatedFare = 0.0;
  LatLngBounds bayLagunaBounds = LatLngBounds(
    southwest: const LatLng(14.2285, 121.2925), // SW bounds
    northeast: const LatLng(14.2500, 121.3115), // NE bounds
  );

  Set<String> allowedBarangays = {
    'Calo',
    'Pupuy',
    'Masaya',
    'Tranca',
    'StaCruz'
  };
  bool canBook = false;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        currentLocation = position;
      });
    } catch (e) {
      print("Error getting location: $e");
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }

  Future<String> _getAddressFromLatLng(LatLng location) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        location.latitude,
        location.longitude,
      );
      Placemark place = placemarks.first; // No need for '?'
      return "${place.name}, ${place.locality}";
    } catch (e) {
      print("Error getting address: $e");
      return "Unknown Location";
    }
  }

  void _selectLocation(LatLng location, {String? markerId}) async {
    String locationName = await _getAddressFromLatLng(location);

    setState(() {
      if (markerId == "pickupLocation") {
        pickupLocationMarker = Marker(
          markerId: MarkerId(markerId!),
          position: location,
          infoWindow: InfoWindow(
            title: "Pickup Location",
            snippet: locationName,
          ),
          draggable: true,
          onDragEnd: (LatLng newPosition) async {
            String newLocationName = await _getAddressFromLatLng(newPosition);
            print(
                'Pickup Location: ${newPosition.latitude}, ${newPosition.longitude} - $newLocationName');
          },
        );
      } else if (markerId == "destinationLocation") {
        destinationLocationMarker = Marker(
          markerId: MarkerId(markerId!),
          position: location,
          infoWindow: InfoWindow(
            title: "Destination Location",
            snippet: locationName,
          ),
          draggable: true,
          onDragEnd: (LatLng newPosition) async {
            String newLocationName = await _getAddressFromLatLng(newPosition);
            print(
                'Destination Location: ${newPosition.latitude}, ${newPosition.longitude} - $newLocationName');
          },
        );
        // Estimate fare based on distance (simplified calculation)
        double distanceInKm = Geolocator.distanceBetween(
              pickupLocationMarker!.position.latitude,
              pickupLocationMarker!.position.longitude,
              destinationLocationMarker!.position.latitude,
              destinationLocationMarker!.position.longitude,
            ) /
            1000.0;

        // Assume a base fare of $5 and $2 per kilometer
        estimatedFare = 5.0 + 2.0 * distanceInKm;

        // Check if both pickup and destination are within allowed barangays
        canBook =
            _isLocationWithinAllowedBarangays(pickupLocationMarker!.position) &&
                _isLocationWithinAllowedBarangays(
                    destinationLocationMarker!.position);
      }
    });
  }

  bool _isLocationWithinAllowedBarangays(LatLng location) {
    // Check if the location falls within the specified bounds
    return bayLagunaBounds.contains(location);
  }

  void _resetBooking() {
    setState(() {
      pickupLocationMarker = null;
      destinationLocationMarker = null;
      estimatedFare = 0.0;
      canBook = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Uber-like Booking App'),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 200,
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: const CameraPosition(
                target: LatLng(
                    14.2380, 121.3015), // Centered within the specified bounds
                zoom: 15.0,
              ),
              markers: {
                if (pickupLocationMarker != null) pickupLocationMarker!,
                if (destinationLocationMarker != null)
                  destinationLocationMarker!,
              },
              onTap: (LatLng location) {
                if (pickupLocationMarker == null) {
                  _selectLocation(location, markerId: "pickupLocation");
                } else if (destinationLocationMarker == null) {
                  _selectLocation(location, markerId: "destinationLocation");
                }
              },
              onCameraMove: (CameraPosition position) {
                // Restrict map movement within specified bounds
                if (!bayLagunaBounds.contains(position.target)) {
                  mapController?.animateCamera(
                    CameraUpdate.newLatLngBounds(bayLagunaBounds, 0),
                  );
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (pickupLocationMarker == null)
                  _buildLocationForm("Pickup", pickupLocationMarker),
                if (pickupLocationMarker != null &&
                    destinationLocationMarker == null)
                  ElevatedButton(
                    onPressed: () {
                      print('Next Button Pressed');
                    },
                    child: const Text('Next'),
                  ),
                if (destinationLocationMarker == null)
                  _buildLocationForm("Destination", destinationLocationMarker),
                if (destinationLocationMarker != null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          'Estimated Fare: \$${estimatedFare.toStringAsFixed(2)}'),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: canBook
                            ? () {
                                // Confirm booking logic here
                                print('Booking Confirmed');
                                print('Pickup: ${pickupController.text}');
                                print(
                                    'Destination: ${destinationController.text}');
                                print(
                                    'Estimated Fare: \$${estimatedFare.toStringAsFixed(2)}');
                              }
                            : null,
                        child: const Text('Confirm Booking'),
                      ),
                      if (!canBook)
                        Column(
                          children: [
                            const Text(
                              'Booking is only available within Calo, Pupuy, Masaya, Tranca, and Sta. Cruz barangays.',
                              style: TextStyle(color: Colors.red),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                _resetBooking();
                              },
                              child: const Text('Try Again'),
                            ),
                          ],
                        ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationForm(String locationType, Marker? marker) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$locationType Location:'),
        if (marker != null)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Latitude: ${marker.position.latitude}'),
              Text('Longitude: ${marker.position.longitude}'),
              Text('Location: ${marker.infoWindow.snippet}'),
            ],
          ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            // Open a dialog or navigate to a new page for more detailed location input
          },
          child: Text('Edit $locationType Location'),
        ),
      ],
    );
  }
}
