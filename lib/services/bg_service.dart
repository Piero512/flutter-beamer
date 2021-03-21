import 'dart:async';

import 'package:background_location/background_location.dart';
import 'package:beamer_app/models/latlong.dart';
import 'package:beamer_app/services/api_service.dart';
import 'package:flutter/foundation.dart';

import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

class BgLocationService  {
  final ApiService service;
  final String passkey;
  BehaviorSubject<LatLong> _lastLocation = BehaviorSubject();
  Stream<LatLong> get lastLocation => _lastLocation.stream;
  BgLocationService({@required this.service, @required this.passkey});

  Future<void> startLocationService() async {
    await BackgroundLocation.setAndroidNotification(
      title: "Beamer",
      message: "Beamer is beaming your location",
      icon: "@mipmap/ic_launcher",
    );
    //await BackgroundLocation.setAndroidConfiguration(1000);
    await BackgroundLocation.startLocationService(distanceFilter: 20);
    BackgroundLocation.getLocationUpdates((location) {
      var lastLoc = LatLong(lat: location.latitude, long: location.longitude);
      _lastLocation.add(lastLoc);
      service.updateLocation(passkey, lastLoc);
    });
  }

  stopLocationService() async {
    await BackgroundLocation.stopLocationService();
  }
}
