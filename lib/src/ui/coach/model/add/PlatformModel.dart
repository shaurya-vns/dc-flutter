import 'package:flutter/cupertino.dart';

class PlatformModel {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController latitudeController = TextEditingController();
  final TextEditingController longitudeController = TextEditingController();

  Map<String, dynamic> toJson() {
    return {
      "name": nameController.text.trim(),
      "latitude": double.tryParse(latitudeController.text.trim()) ?? 0.0,
      "longitude": double.tryParse(longitudeController.text.trim()) ?? 0.0,
    };
  }

  void dispose() {
    nameController.dispose();
    latitudeController.dispose();
    longitudeController.dispose();
  }
}
