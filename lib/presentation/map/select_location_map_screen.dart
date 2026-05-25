import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:range_wave/core/utils/color/app_colors.dart';
import 'package:range_wave/core/utils/common_widget/primary_button.dart';

class SelectLocationMapScreen extends StatefulWidget {
  const SelectLocationMapScreen({super.key});

  @override
  State<SelectLocationMapScreen> createState() => _SelectLocationMapScreenState();
}

class _SelectLocationMapScreenState extends State<SelectLocationMapScreen> {
  final MapController _mapController = MapController();
  LatLng _currentCenter = const LatLng(23.8103, 90.4125);
  String _selectedAddress = "Fetching address...";
  bool _isLoading = true;
  bool _isFetchingAddress = false;

  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _getUserCurrentLocation();
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }

  Future<void> _getUserCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _currentCenter = LatLng(position.latitude, position.longitude);
        _isLoading = false;
      });

      _mapController.move(_currentCenter, 16.0);
      _getReadableAddress(_currentCenter);
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _getReadableAddress(LatLng coordinates) async {
    if (!mounted) return;
    setState(() => _isFetchingAddress = true);

    try {
      final url = Uri.parse(
          'https://nominatim.openstreetmap.org/reverse?format=json&lat=${coordinates.latitude}&lon=${coordinates.longitude}');

      final response = await http.get(url, headers: {
        'User-Agent': 'RangeWaveApp_Unique_Agent_v1',
        'Accept-Language': 'en'
      });

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        final address = data['address'];
        String formattedAddress = "";

        if (address != null) {
          String road = address['road'] ?? address['suburb'] ?? address['neighbourhood'] ?? "";
          String city = address['city'] ?? address['town'] ?? address['state'] ?? "";
          if (road.isNotEmpty && city.isNotEmpty) {
            formattedAddress = "$road, $city";
          } else {
            formattedAddress = data['display_name'] ?? "Selected Location";
          }
        } else {
          formattedAddress = data['display_name'] ?? "Selected Location";
        }

        setState(() {
          _selectedAddress = formattedAddress;
        });
      } else {
        setState(() => _selectedAddress = "Location Selected");
      }
    } catch (e) {
      setState(() => _selectedAddress = "Location Selected");
    } finally {
      if (mounted) setState(() => _isFetchingAddress = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pin Your Location', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _currentCenter,
              initialZoom: 16.0,
              onPositionChanged: (position, hasGesture) {
                if (hasGesture) {
                  _currentCenter = position.center;

                  if (_debounceTimer?.isActive ?? false) _debounceTimer?.cancel();
                  _debounceTimer = Timer(const Duration(milliseconds: 800), () {
                    _getReadableAddress(_currentCenter);
                  });
                }
              },
            ),
            children: [
              TileLayer(
                urlTemplate:
                'https://tiles.stadiamaps.com/tiles/alidade_smooth/{z}/{x}/{y}{r}.png?api_key=a0dfe28e-db77-4409-ae11-b8fa691d1db9',
              ),
            ],
          ),

          Center(
            child: Padding(
              padding: EdgeInsets.only(bottom: 35.h),
              child: Icon(
                Icons.location_on,
                size: 45.w,
                color: AppColors.blue,
              ),
            ),
          ),

          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
                boxShadow: [
                  BoxShadow(color: Colors.black12, blurRadius: 10.r, spreadRadius: 2.r),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.location_searching, color: AppColors.blue, size: 20.w),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          _isFetchingAddress ? "Locating..." : _selectedAddress,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  PrimaryButton(
                    text: 'Confirm Location',
                    backgroundColor: AppColors.primary,
                    onTap: _isFetchingAddress || _selectedAddress == "Location Selected"
                        ? null
                        : () {
                      Get.back(result: {
                        "address": _selectedAddress,
                        "lat": _currentCenter.latitude,
                        "lon": _currentCenter.longitude,
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}