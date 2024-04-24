import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'DataController.dart';  // Ensure this import points to your DataController correctly
import 'view_events_page.dart';  // Ensure this import points to your ViewEventsPage correctly

class CreateEventView extends StatefulWidget {
  @override
  _CreateEventViewState createState() => _CreateEventViewState();
}

     class _CreateEventViewState extends State<CreateEventView> {
     final GlobalKey<FormState> formKey = GlobalKey<FormState>();
     final TextEditingController _eventNameController = TextEditingController();
     final TextEditingController _eventLocationController = TextEditingController();
     final TextEditingController _eventDateController = TextEditingController();

  final DataController _dataController = Get.find<DataController>();

    Future<void> _createEvent() async {
    final String name = _eventNameController.text.trim();
    final String location = _eventLocationController.text.trim();
    final String date = _eventDateController.text.trim();
    final String userId = FirebaseAuth.instance.currentUser?.uid ?? '';

    if (name.isNotEmpty && location.isNotEmpty && date.isNotEmpty && userId.isNotEmpty) {
      bool success = await _dataController.createEvent(name, location, date, userId);
      if (success) {
        // Redirect to ViewEventsPage after successful event creation
        Get.to(() => ViewEventsPage());  // Navigate to the event listing page
      }
    } else {
      Get.snackbar('Error', 'All fields are required.',
          backgroundColor: Colors.red, colorText: Colors.white, snackPosition: SnackPosition.BOTTOM);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Event', style: GoogleFonts.lato()),
        backgroundColor: Colors.brown, // Ensure AppBar color matches the theme
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                controller: _eventNameController,
                decoration: const InputDecoration(
                  labelText: 'Event Name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.event_note),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _eventLocationController,
                decoration: const InputDecoration(
                  labelText: 'Location',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.location_on),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _eventDateController,
                decoration: const InputDecoration(
                  labelText: 'Date (YYYY-MM-DD)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                keyboardType: TextInputType.datetime,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _createEvent,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown, // Button color to match the theme
                  foregroundColor: Colors.white, // Text color to match the theme
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Create Event', style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}