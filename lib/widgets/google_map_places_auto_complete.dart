import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;

import '../models/place_model.dart';
import '../models/prediction_model.dart';

class GoogleMapPlacesAutoComplete {
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
}
