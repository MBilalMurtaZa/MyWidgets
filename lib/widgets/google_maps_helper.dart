// This file is part of a Flutter package created by Bilal MurtaZa.
// Purpose: This file contains google maps helper.

import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

import '../models/place_model.dart';
import '../models/prediction_model.dart';

class GoogleMapsHelper {
  static Future<List<Prediction>> getPlaces(String placeName, String mapsKey,
      {String? otherOptions}) async {
    /// referenceUrl = https://developers.google.com/maps/documentation/places/web-service/autocomplete#maps_http_places_autocomplete_amoeba-txt;
    String mapOptions =
        ['input=$placeName', 'key=$mapsKey', otherOptions].join('&');

    http.Response response = await http.get(Uri.parse(
        "https://maps.googleapis.com/maps/api/place/autocomplete/json?$mapOptions"));
    debugPrint(response.body.toString());
    if (response.statusCode == 200) {
      Predictions predictions = predictionsFromJson(response.body);
      if (predictions.predictions != null) {
        return predictions.predictions ?? [];
      }
    } else {
      debugPrint(response.statusCode.toString());
    }
    return [];
  }

  static Future<Place?> getPlaceDetail(String placeId, String mapsKey,
      {String? otherOptions}) async {
    /// referenceUrl = https://developers.google.com/maps/documentation/places/web-service/place-id
    // https://maps.googleapis.com/maps/api/place/details/json?place_id=ChIJrTLr-GyuEmsRBfy61i59si0&key=YOUR_API_KEY
    String mapOptions =
        ['place_id=$placeId', 'key=$mapsKey', otherOptions].join('&');

    http.Response response = await http.get(Uri.parse(
        "https://maps.googleapis.com/maps/api/place/details/json?$mapOptions"));
    debugPrint(response.body.toString());
    if (response.statusCode == 200) {
      return placeFromJson(response.body);
    } else {
      debugPrint(response.statusCode.toString());
    }
    return null;
  }

  /// final bitmapDescriptor = BitmapDescriptor.fromBytes(await _getBytesFromUrl('https://example.com/your-marker-image.png'));
  static Future<Uint8List> getMapBytesFromUrl(String url) async {
    final response = await http.get(Uri.parse(url));
    final bytes = response.bodyBytes;
    final imageCodec = await ui.instantiateImageCodec(bytes,
        targetWidth: 150); // Resize the image
    final frame = await imageCodec.getNextFrame();
    final data = await frame.image.toByteData(format: ui.ImageByteFormat.png);
    return data!.buffer.asUint8List();
  }
}
