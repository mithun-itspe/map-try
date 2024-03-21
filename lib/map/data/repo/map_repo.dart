import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

Dio dio = Dio();

class MapRepo {
  static osrmRoute({
    required Position currentLocation,
    required LatLng destination,
  }) async {
    final response = await dio.get(
      'http://int.itspe.co.in:5000/route/v1/walking/${currentLocation.longitude},${currentLocation.latitude};${destination.longitude},${destination.latitude}',
    );
    return response;
  }
}
