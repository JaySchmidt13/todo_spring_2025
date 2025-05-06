import 'package:flutter/material.dart';
import '../services/places_service.dart';

class LocationSearchField extends StatefulWidget {
  final Function(String) onLocationSelected;

  const LocationSearchField({
    super.key,
    required this.onLocationSelected,
  });

  @override
  State<LocationSearchField> createState() => _LocationSearchFieldState();
}

class _LocationSearchFieldState extends State<LocationSearchField> {
  final _placesService = PlacesService();
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return _placesService.getSearchTextField(
      controller: _controller,
      onLocationSelected: widget.onLocationSelected,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}