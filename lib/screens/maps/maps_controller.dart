import 'package:mobx/mobx.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:premiere_league_v2/components/util/command_query.dart';

class MapsController {
  MapsController() {
    locationCoordinates = Observable<LatLng?>(null);
    isLoading = Observable(false);
    errorMessage = Observable<String?>(null);
  }

  late final Observable<LatLng?> locationCoordinates;
  late final Observable<bool> isLoading;
  late final Observable<String?> errorMessage;

  late final fetchCoordinates =
      CommandQuery.createWithParam<String, void>(_fetchCoordinates);

  Future<void> _fetchCoordinates(String location) async {
    try {
      isLoading.value = true;
      errorMessage.value = null;
      List<Location> locations = await locationFromAddress(location);

      if (locations.isNotEmpty) {
        locationCoordinates.value = LatLng(
          locations.first.latitude,
          locations.first.longitude,
        );
      } else {
        errorMessage.value = 'Location not found.';
      }
    } catch (e) {
      errorMessage.value = 'Error fetching location: $e';
    } finally {
      isLoading.value = false;
    }
  }
}
