import 'package:meta/meta.dart';

class LatLong {
  final double lat;
  final double long;

  LatLong({@required this.lat, @required this.long});

  Map<String, dynamic> toJson() => {'lat': lat, 'long': long};

  factory LatLong.fromJson(Map<String, dynamic> json) =>
      LatLong(lat: json['lat'], long: json['long']);
}
