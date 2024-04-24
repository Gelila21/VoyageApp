import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatelessWidget {
  final double latitude;
  final double longitude;

  const MapPage({Key? key, required this.latitude, required this.longitude}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Event Location'),
        backgroundColor: Colors.brown,
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(latitude, longitude),
          zoom: 15.0,
        ),
        markers: {
          Marker(
            markerId: MarkerId('eventLocation'),
            position: LatLng(latitude, longitude),
          ),
        },
      ),
    );
  }
}
