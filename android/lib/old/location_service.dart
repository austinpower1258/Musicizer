import 'dart:async';
import 'package:location/location.dart';
import 'user_location.dart';

class LocationService {
  UserLocation _currentLocation;
  Location location = new Location();
  StreamController<UserLocation> _locationController =
      StreamController<UserLocation>.broadcast();

  Stream<UserLocation> get locationStream => _locationController.stream;

 

  LocationService() {
    // Request permission to use location
    location.requestPermission().then((value) {
      if (true) {
        // If granted listen to the onLocationChanged stream and emit over our controller
        location.changeSettings(
            accuracy: LocationAccuracy.HIGH, interval: 50, distanceFilter: 0);
        location.onLocationChanged().listen((locationData) {
          if (locationData != null) {
            _locationController.add(UserLocation(
              latitude: locationData.latitude,
              longitude: locationData.longitude,
              speed: locationData.speed,
            ));
          }
        });
      }
    });
  }

  Future<UserLocation> getLocation() async {
    try {
      var userLocation = await location.getLocation();
      _currentLocation = UserLocation(
        latitude: userLocation.latitude,
        longitude: userLocation.longitude,
        speed: userLocation.speed,
      );
    } on Exception catch (e) {
      print('Could not get location: ${e.toString()}');
    }
    return _currentLocation;
  }
}
