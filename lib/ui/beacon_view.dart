import 'package:beamer_app/models/latlong.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:cached_network_image/cached_network_image.dart';

enum MapType { FOLLOW, BROADCAST }

class CachedTileProvider extends TileProvider {
  const CachedTileProvider();

  @override
  ImageProvider getImage(Coords<num> coords, TileLayerOptions options) {
    return CachedNetworkImageProvider(
      getTileUrl(coords, options),
      //Now you can set options that determine how the image gets cached via whichever plugin you use.
    );
  }
}

class BeaconView extends StatefulWidget {
  final MapType type;
  final LatLong beaconPosition;

  BeaconView({@required this.type, @required this.beaconPosition});

  @override
  _BeaconViewState createState() => _BeaconViewState();
}

class _BeaconViewState extends State<BeaconView> {
  final MapController _mapController = MapController();

  @override
  void didUpdateWidget(BeaconView oldWidget) {
    super.didUpdateWidget(oldWidget);
    var newPosition = this.widget.beaconPosition;
    if (newPosition != null && newPosition != oldWidget.beaconPosition) {
      _mapController.move(toLatLng(newPosition), 12);
    }
  }

  LatLng toLatLng(LatLong newPosition) =>
      LatLng(newPosition.lat, newPosition.long);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FlutterMap(
          mapController: _mapController,
          options: MapOptions(center: LatLng(-2.20584, -79.90795), zoom: 12),
          layers: [],
          nonRotatedLayers: [
            TileLayerOptions(
              urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
              subdomains: ['a', 'b', 'c'],
              tileProvider: const CachedTileProvider(),
            ),
            MarkerLayerOptions(markers: [
              if (widget.beaconPosition != null)
                Marker(
                    point: toLatLng(widget.beaconPosition),
                    builder: (ctx) => Icon(Icons.pin_drop))
            ])
          ],
        ),
      ),
    );
  }
}
