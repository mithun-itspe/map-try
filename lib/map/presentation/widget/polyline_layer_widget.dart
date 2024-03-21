import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

import '../../controller/map_controller.dart';

class PolylineLayerWidget extends StatelessWidget {
  const PolylineLayerWidget({super.key, required this.watch});

  final MapHomeController watch;

  @override
  Widget build(BuildContext context) {
    return PolylineLayer(
      polylines: [
        Polyline(
          color: Colors.blue,
          strokeWidth: 4,
          points: watch.coordinators ?? [],
        ),
      ],
    );
  }
}
