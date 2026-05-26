import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:range_wave/core/utils/color/app_colors.dart';
import 'package:range_wave/core/utils/custom_http.dart';
import 'package:range_wave/core/utils/custom_toast.dart';
import 'package:range_wave/model/booking_model.dart';
import 'package:range_wave/model/mechanic_portfolio_model.dart';
import '../../core/navigation/app_routes.dart';
import '../../core/utils/common_widget/primary_button.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {

  // ── Arguments ─────────────────────────────────────────────
  late final MechanicPortfolioModel mechanic;
  late final String carIssueId;

  // ── State ─────────────────────────────────────────────────
  LatLng? userLocation;
  bool    isBooking = false;

  @override
  void initState() {
    super.initState();

    // arguments থেকে data নাও
    final args = Get.arguments as Map;
    mechanic    = args['mechanic'] as MechanicPortfolioModel;
    carIssueId  = args['issue_id'] ?? '';

    _loadLocation();
  }

  Future<void> _loadLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        userLocation = LatLng(position.latitude, position.longitude);
      });
    } catch (e) {
      // fallback location
      setState(() {
        userLocation = LatLng(23.8103, 90.4125); // Dhaka
      });
    }
  }

  // ── Book Mechanic API ──────────────────────────────────────
  Future<void> _bookMechanic() async {
    if (isBooking) return;
    setState(() => isBooking = true);

    try {
      final response = await CustomHttp.post(
        endpoint: 'customer/book-mechanic',
        needAuth: true,
        body: {
          'mechanic_id'  : mechanic.id,
          'car_issue_id' : carIssueId,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final booking = BookingModel.fromJson(response.data);
        showCustomToast(text: 'Booked successfully!');
        Get.toNamed(
          AppRoutes.serviceInProgress,
          arguments: booking,   // booking data পাঠাও
        );
      } else {
        showCustomToast(
          text: response.error ?? 'Booking failed. Please try again.',
        );
      }
    } catch (e) {
      showCustomToast(text: 'Something went wrong');
    } finally {
      setState(() => isBooking = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // ── Loading location ──────────────────────────────────────
    if (userLocation == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final mechanicLocation = LatLng(mechanic.latitude, mechanic.longitude);

    return Scaffold(
      body: Stack(
        children: [

          // ── Map ───────────────────────────────────────────
          FlutterMap(
            options: MapOptions(
              initialCenter: userLocation!,
              initialZoom  : 13,
            ),
            children: [
              TileLayer(
                urlTemplate:
                'https://tiles.stadiamaps.com/tiles/alidade_smooth/{z}/{x}/{y}{r}.png?api_key=a0dfe28e-db77-4409-ae11-b8fa691d1db9',
              ),

              // Markers
              MarkerLayer(
                markers: [
                  // ✅ User location
                  Marker(
                    point : userLocation!,
                    width : 40,
                    height: 40,
                    child : Icon(
                      Icons.person_pin_circle,
                      size : 40,
                      color: AppColors.primary,
                    ),
                  ),
                  // ✅ Mechanic location (API থেকে)
                  Marker(
                    point : mechanicLocation,
                    width : 40,
                    height: 40,
                    child : Icon(
                      Icons.build_circle,
                      size : 40,
                      color: AppColors.blue,
                    ),
                  ),
                ],
              ),

              // ✅ Polyline user → mechanic
              PolylineLayer(
                polylines: [
                  Polyline(
                    points     : [userLocation!, mechanicLocation],
                    strokeWidth: 4,
                    color      : AppColors.blue,
                  ),
                ],
              ),
            ],
          ),

          // ── Back button ───────────────────────────────────
          Positioned(
            top : 50,
            left: 16,
            child: SafeArea(
              child: GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  padding   : const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color       : Colors.white,
                    shape       : BoxShape.circle,
                    boxShadow   : [
                      BoxShadow(
                        color     : Colors.black.withValues(alpha: 0.15),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  child: const Icon(Icons.arrow_back, size: 22),
                ),
              ),
            ),
          ),

          // ── Mechanic info card ─────────────────────────────
          Positioned(
            top  : 90,
            left : 16,
            right: 16,
            child: Container(
              padding   : const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color        : Colors.white,
                borderRadius : BorderRadius.circular(12),
                boxShadow    : [
                  BoxShadow(
                    color     : Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset    : const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius          : 24,
                    backgroundColor : AppColors.surface,
                    backgroundImage : mechanic.avatarUrl.isNotEmpty
                        ? NetworkImage(mechanic.avatarUrl)
                        : null,
                    child: mechanic.avatarUrl.isEmpty
                        ? const Icon(Icons.person)
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          mechanic.fullName,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize  : 15,
                          ),
                        ),
                        Text(
                          mechanic.shopName,
                          style: TextStyle(
                            fontSize: 12,
                            color   : Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '\$${mechanic.initialCharge}',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize  : 16,
                      color     : AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Book Now button ───────────────────────────────
          Positioned(
            bottom: 30,
            left  : 20,
            right : 20,
            child : PrimaryButton(
              loading        : isBooking,
              text           : 'Arrived',
              backgroundColor: AppColors.primary,
              onTap          : _bookMechanic,
            ),
          ),
        ],
      ),
    );
  }
}