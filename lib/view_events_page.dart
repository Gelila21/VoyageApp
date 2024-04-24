import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:share/share.dart';
import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'map_page.dart'; // Ensure this file exists with the MapPage class
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ViewEventsPage extends StatelessWidget {
  String formatDate(String dateString) {
    try {
      final date = DateFormat('yyyy-MM-dd').parse(dateString);
      return DateFormat('MMMM dd, yyyy').format(date);
    } catch (e) {
      print('Error parsing date: $e');
      return 'Invalid date';
    }
  }

  // Replace 'YOUR_API_KEY' with your actual Google Geocoding API key
  Future<LatLng> geocodeAddress(String address) async {
    const apiKey = 'AIzaSyAztaD8XSExrPeIOOX_5odi9HwMqH-3AOQ';
    final uri = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?address=${Uri.encodeComponent(address)}&key=$apiKey');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      if (result['results'].isNotEmpty) {
        final location = result['results'][0]['geometry']['location'];
        return LatLng(location['lat'], location['lng']);
      } else {
        throw Exception('No results found.');
      }
    } else {
      throw Exception('Failed to fetch location');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Events', style: GoogleFonts.lato()),
        backgroundColor: Colors.brown,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 1));
        },
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('events').orderBy('date').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            final events = snapshot.data!.docs;
            if (events.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.search_off, size: 80, color: Colors.grey[300]),
                    Text('No events found', style: GoogleFonts.lato(color: Colors.grey)),
                  ],
                ),
              );
            }
            return ListView.builder(
              itemCount: events.length,
              itemBuilder: (context, index) {
                var event = events[index].data() as Map<String, dynamic>;
                var formattedDate = event['date'] is String ? formatDate(event['date']) : 'Date not available';

                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.brown,
                      child: Icon(Icons.event, color: Colors.white),
                    ),
                    title: Text(event['name'], style: GoogleFonts.lato(fontSize: 18, fontWeight: FontWeight.bold)),
                    subtitle: Text('${event['location']} on $formattedDate', style: GoogleFonts.lato()),
                    onTap: () {
                      // Implement navigation to event detail page if necessary
                    },
                    trailing: Wrap(
                      spacing: 12,
                      children: <Widget>[
                        IconButton(
                          icon: const Icon(Icons.share),
                          onPressed: () {
                            final String eventDetails = 'Check out this event: ${event['name']} happening at ${event['location']} on $formattedDate. Don\'t miss it!';
                            Share.share(eventDetails);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.calendar_today),
                          onPressed: () {
                            final Event eventToAdd = Event(
                              title: event['name'],
                              description: 'Event at ${event['location']}',
                              location: event['location'],
                              startDate: DateFormat('yyyy-MM-dd').parse(event['date']),
                              endDate: DateFormat('yyyy-MM-dd').parse(event['date']).add(Duration(hours: 2)),
                            );
                            Add2Calendar.addEvent2Cal(eventToAdd);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.map),
                          onPressed: () async {
                            try {
                              final coordinates = await geocodeAddress(event['location']);
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => MapPage(latitude: coordinates.latitude, longitude: coordinates.longitude)));
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to load the map.")));
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
