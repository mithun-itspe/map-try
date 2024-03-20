import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:untitled8/map/controller/map_controller.dart';
import 'package:untitled8/map/presentation/widget/marker_layer_widget.dart';
import 'package:untitled8/map/presentation/widget/tile_layer.dart';

class MapHomeScreen extends StatelessWidget {
  const MapHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final watch = context.watch<MapHomeController>();

    return Scaffold(
      body: FlutterMap(
        mapController: watch.mapController,
        options: MapOptions(
          maxZoom: 18.39,
          minZoom: 5,
          initialCenter: watch.currentLocation != null
              ? LatLng(
                  watch.currentLocation!.latitude,
                  watch.currentLocation!.longitude,
                )
              : watch.latLongIndCenter,
          initialZoom: 2,
        ),
        children: [
          tileLayer(),
          if (watch.compassHeading != null) MarkerLayerWidget(watch: watch),
          if (watch.currentLocation != null)
            PolylineLayer(
              polylines: [
                Polyline(
                  color: Colors.red,
                  points: watch.coordinators ?? [],
                ),
              ],
            ),
        ],
      ),
    );
  }
}
