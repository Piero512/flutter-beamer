import 'dart:convert' show jsonEncode, jsonDecode;

import 'package:beamer_app/models/latlong.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/web_socket_channel.dart';

class ApiService {
  final _baseUrl = Uri.parse("https://flutter-beamer.herokuapp.com");
  WebSocketChannel _channel;
  Stream<LatLong> locationUpdates;

  Uri _buildUri(String path) {
    return Uri(
        scheme: _baseUrl.scheme,
        host: _baseUrl.host,
        pathSegments: path.split("/"),
        port: _baseUrl.port);
  }

  Future<void> updateLocation(String passkey, LatLong coords) {
    return http.post(
      _buildUri('api/$passkey/update'),
      body: jsonEncode(
        coords,
      ),
      headers: {
        'Content-Type': 'application/json; charset=utf-8',
      }
    );
  }

  Future<LatLong> getLastLocation(String passkey) {
    return http
        .get(_buildUri('api/$passkey'))
        .then((value) => jsonDecode(value.body))
        .then((value) => LatLong.fromJson(value));
  }

  Future<void> stopSharing(String passkey) {
    return http.delete(
      _buildUri('api/$passkey'),
    );
  }

  Stream<LatLong> subscribePasskey(String passkey) {
    if (_channel == null) {
      _channel = WebSocketChannel.connect(
        Uri.parse('wss://flutter-beamer.herokuapp.com/'),
      );
    }
    if (locationUpdates == null) {
      locationUpdates = _channel.stream.map(
        (event) => LatLong.fromJson(jsonDecode(event)),
      );
    }
    _channel.sink.add(
      jsonEncode({'action': 'subscribe', 'passkey': passkey}),
    );
    return locationUpdates;
  }
}
