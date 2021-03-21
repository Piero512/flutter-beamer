import 'package:beamer_app/models/latlong.dart';
import 'package:beamer_app/services/api_service.dart';
import 'package:beamer_app/services/bg_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';
import 'beacon_view.dart';

class BroadcastScreen extends StatefulWidget {
  final ApiService apiService;

  BroadcastScreen(this.apiService);

  @override
  _BroadcastScreenState createState() => _BroadcastScreenState();
}

class _BroadcastScreenState extends State<BroadcastScreen> {
  final _uuid = Uuid().v4();
  BgLocationService service;

  @override
  void initState() {
    service = BgLocationService(service: widget.apiService, passkey: _uuid);
    service.startLocationService();
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("You are carrying the beacon!"),
      ),
      body: Column(
        children: [
          StreamBuilder<LatLong>(
            stream: service.lastLocation,
            builder: (context, snapshot) {
              return BeaconView(
                type: MapType.BROADCAST,
                beaconPosition: snapshot.data,
              );
            }
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(child: Text("Your passkey for this session is $_uuid")),
                      IconButton(
                        icon: Icon(Icons.content_paste),
                        onPressed: () => Clipboard.setData(
                          ClipboardData(text: _uuid),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    service.stopLocationService();
    widget.apiService.stopSharing(_uuid);
    super.dispose();
  }
}
