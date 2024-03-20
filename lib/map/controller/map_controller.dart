import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:permission_handler/permission_handler.dart';

class MapHomeController with ChangeNotifier {
  MapHomeController() {
    requestLocationPermission();
  }

  LatLng latLongIndCenter = const LatLng(23.860366994344993, 77.78199537824027);

  MapController mapController = MapController();
  Position? currentLocation;
  double? compassHeading;
  List<LatLng>? coordinators;

  requestLocationPermission() async {
    PermissionStatus permissionStatus = await Permission.location.request();

    if (permissionStatus.isGranted) {
      await getCurrentLocation();
      compassInit();
      getRoute();
    } else {
      log("Location permission denied");
    }
  }

  Future<void> getCurrentLocation() async {
    try {
      currentLocation = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      Geolocator.getPositionStream().listen((event) {
        currentLocation = event;
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
    Dio dio = Dio();
    try {
      final response = await dio.get(
        'http://int.itspe.co.in:5000/route/v1/walking/${currentLocation?.latitude},${currentLocation?.longitude};17.406350103723327,78.37557062745098',
      );
      log(response.toString(), name: 'coordinators');
      if (response.statusCode == 200) {
        log(response.data['code'], name: 'code');
        final data = response.data['routes'][0]['geometry'];
        log(data.toString());
        decodePolyline(data);
        log(coordinators?.length.toString() ?? '');

        notifyListeners();
      }
    } catch (e) {
      log(e.toString(), name: 'exception catch');
    }
  }

  decodePolyline(String value) async {
    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> decodedPoints = polylinePoints.decodePolyline(value);
    log(decodedPoints.toString(), name: 'decodedPoints');
    coordinators = decodedPoints
        .map((point) => LatLng(point.latitude, point.longitude))
        .toList();
  }

// getDipo() async {
//   Dio dio = Dio();
//   final response = await dio
//       .get('https://neptuneapi.upsrtcvlt.com/pt/operator/get_garage_list');
//   log(response.toString(), name: 'getDipo');
// }
}
