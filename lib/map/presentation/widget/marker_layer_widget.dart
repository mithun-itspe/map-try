import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../controller/map_controller.dart';

class MarkerLayerWidget extends StatelessWidget {
  const MarkerLayerWidget({super.key, required this.watch});

  final MapHomeController watch;

  @override
  Widget build(BuildContext context) {
    return MarkerLayer(
      rotate: true,
      markers: [
        Marker(
          width: 80.0,
          height: 80.0,
          point: watch.currentLocation != null
              ? LatLng(
            watch.currentLocation!.latitude,
            watch.currentLocation!.longitude,
          )
              : watch.latLongIndCenter,
          rotate: true,
          child: Transform.rotate(
            angle: watch.compassHeading! * (3.141592653589793 / 90),
            child: const Icon(
              Icons.navigation,
              color: Colors.black,
              size: 40,
            ),
          ),
        ),
      ],
    );
  }
}
