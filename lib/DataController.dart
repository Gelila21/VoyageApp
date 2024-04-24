import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class DataController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<bool> createEvent(String name, String location, String date, String userId) async {
    try {
      await firestore.collection('events').add({
        'name': name,
        'location': location,
        'date': date,
        'userId': userId, // Associate event with the user
      });
      // Indicate success with a snackbar and return true
      Get.snackbar('Success', 'Event created successfully',
          backgroundColor: Colors.green, colorText: Colors.white, snackPosition: SnackPosition.BOTTOM);
      return true;
    } catch (e) {
      // Indicate failure with a snackbar and return false
      Get.snackbar('Error', 'Failed to create event: ${e.toString()}',
          backgroundColor: Colors.red, colorText: Colors.white, snackPosition: SnackPosition.BOTTOM);
      return false;
    }
  }
}
