import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:untitled8/map/data/repo/map_repo.dart';

class MapHomeController with ChangeNotifier {
  MapHomeController() {
    requestLocationPermission();
  }

  LatLng latLongIndCenter = const LatLng(23.860366994344993, 77.78199537824027);

  MapController mapController = MapController();
  Position? currentLocation;
  double? compassHeading;
  List<LatLng>? coordinators;
  bool isLoading = false;

  requestLocationPermission() async {
    isLoading = true;
    PermissionStatus permissionStatus = await Permission.location.request();

    if (permissionStatus.isGranted) {
      compassInit();
      getCurrentLocation();
    } else {
      log("Location permission denied");
    }
  }

  Future<void> getCurrentLocation() async {
    try {
      currentLocation = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      Geolocator.getPositionStream().listen((event) async {
        currentLocation = event;
        await getRoute();
      });
      notifyListeners();
    } catch (e) {
      log(e.toString(), name: 'error from current location permission');
    }
  }

  void compassInit() {
    FlutterCompass.events?.listen((event) {
      compassHeading = event.heading;
      notifyListeners();
    });
  }

  getRoute() async {
    try {
      log(currentLocation?.latitude.toString() ?? '', name: 'latitude');
      log(currentLocation?.longitude.toString() ?? '', name: 'longitude');
      final response = await MapRepo.osrmRoute(
        currentLocation: currentLocation!,
        destination: const LatLng(17.30616772960623, 78.72577291109071),
      );

      log(response.toString(), name: 'coordinators');
      if (response.statusCode == 200) {
        decodePolyline(response.data['routes'][0]['geometry']);
      }
    } catch (e) {
      log(e.toString(), name: 'exception catch');
    }
    isLoading = false;
    notifyListeners();
  }

  decodePolyline(String value) async {
    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> decodedPoints = polylinePoints.decodePolyline(value);
    coordinators = decodedPoints
        .map((point) => LatLng(point.latitude, point.longitude))
        .toList();
    log(coordinators.toString(), name: 'coordinators');
  }
}
