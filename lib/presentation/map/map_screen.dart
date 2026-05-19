import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:range_wave/core/utils/color/app_colors.dart';
import 'package:range_wave/core/utils/common_widget/primary_button.dart';

import '../../core/navigation/app_routes.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? userLocation;

  // Example mechanic location
  final LatLng mechanicLocation = LatLng(51.515, -0.09);

  Future<LatLng> getCurrentLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    return LatLng(position.latitude, position.longitude);
  }

  @override
  void initState() {
    super.initState();
    loadLocation();
  }

  Future<void> loadLocation() async {
    userLocation = await getCurrentLocation();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (userLocation == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(initialCenter: userLocation!, initialZoom: 13),
            children: [
              TileLayer(
                urlTemplate:
                    'https://tiles.stadiamaps.com/tiles/alidade_smooth/{z}/{x}/{y}{r}.png?api_key=a0dfe28e-db77-4409-ae11-b8fa691d1db9',
              ),

              // Markers
              MarkerLayer(
                markers: [
                  Marker(
                    point: userLocation!,
                    width: 40,
                    height: 40,
                    child: const Icon(Icons.person_pin_circle, size: 40),
                  ),
                  Marker(
                    point: mechanicLocation,
                    width: 40,
                    height: 40,
                    child: const Icon(Icons.build, size: 40),
                  ),
                ],
              ),

              // Polyline
              PolylineLayer(
                polylines: [
                  Polyline(
                    points: [userLocation!, mechanicLocation],
                    strokeWidth: 4,
                    color: Colors.blue,
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: PrimaryButton(
              text: 'Arrived',
              backgroundColor: AppColors.primary,
              onTap: () {
                Get.toNamed(AppRoutes.serviceInProgress);
              },
            ),
          ),
        ],
      ),
    );
  }
}
