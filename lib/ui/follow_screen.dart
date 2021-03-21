import 'package:beamer_app/models/latlong.dart';
import 'package:beamer_app/services/api_service.dart';
import 'package:beamer_app/ui/beacon_view.dart';
import 'package:flutter/material.dart';

class FollowScreen extends StatelessWidget {
  final String passkey;
  final ApiService service;

  const FollowScreen({Key key, @required this.passkey, @required this.service})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("You're following the beacon"),
      ),
      body: Column(
        children: [
          StreamBuilder<LatLong>(
              stream: service.subscribePasskey(passkey),
              builder: (context, snapshot) {
                return BeaconView(
                  type: MapType.FOLLOW,
                  beaconPosition: snapshot.data,
                );
              })
        ],
      ),
    );
  }
}
