import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import '../constants/api_keys.dart';

class PlacesService {
  final String apiKey = ApiKeys.googleMapsApiKey;

  GooglePlaceAutoCompleteTextField getSearchTextField({
    required TextEditingController controller,
    required Function(String) onLocationSelected,
  }) {
    return GooglePlaceAutoCompleteTextField(
      textEditingController: controller,
      googleAPIKey: apiKey,
      inputDecoration: const InputDecoration(
        labelText: 'Location',
        filled: true,
        fillColor: Colors.white,
        prefixIcon: Icon(Icons.location_on),
      ),
      debounceTime: 800,
      countries: const ["us"],
      isLatLngRequired: false,
      itemClick: (Prediction prediction) {
        controller.text = prediction.description ?? '';
        onLocationSelected(prediction.description ?? '');
      },
    );
  }
}