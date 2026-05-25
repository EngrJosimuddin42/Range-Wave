import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:range_wave/controller/car_controller.dart';
import 'package:range_wave/model/car_issue_model.dart';
import 'package:range_wave/model/car_list_model.dart';
import 'package:range_wave/service/car_issue_service.dart';
import '../core/utils/app_helper.dart';
import '../core/utils/custom_toast.dart';
import '../service/location_service.dart';

class ScheduledServiceController extends GetxController {

  // ── Services ─────────────────────────────────────────────
  final CarIssueService _issueService = CarIssueService();

  // ── CarController ─────────────────────────────────────────
  final CarController carController = Get.find<CarController>();

  // ── Text Controllers ──────────────────────────────────────
  final TextEditingController problemController  = TextEditingController();
  final TextEditingController dateController     = TextEditingController();
  final TextEditingController locationController = TextEditingController();

  // ── Observables ───────────────────────────────────────────
  final Rxn<CarListModel>     selectedCar  = Rxn<CarListModel>();
  final RxList<CarPhotoModel> carPhotoList = RxList<CarPhotoModel>();
  final RxBool                isSubmitting = RxBool(false);

  final Rx<DateTime> selectedDate = DateTime.now().obs;
  final Rx<DateTime> focusedDay   = DateTime.now().obs;
  final RxString     timeText     = "09 : 00".obs;
  final RxBool       isAm         = true.obs;

  // ── Plain fields ──────────────────────────────────────────
  String? voiceNotePath;
  double? selectedLatitude;
  double? selectedLongitude;

  // ── Car list থেকে নাও ─────────────────────────────────────
  RxList<CarListModel> get carList => carController.carList;

  // ═══════════════════════════════════════════════════════════
  //  Date & Time
  // ═══════════════════════════════════════════════════════════

  void setTime(TimeOfDay time) {
    final hour   = time.hourOfPeriod.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    timeText.value = "$hour : $minute";
    isAm.value = time.period == DayPeriod.am;
  }

  void toggleAmPm(bool am) => isAm.value = am;

  void setDate(DateTime date) {
    selectedDate.value  = date;
    dateController.text =
    '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  // ═══════════════════════════════════════════════════════════
  //  Location
  // ═══════════════════════════════════════════════════════════

  void updateManualLocation(Map<String, dynamic> data) {
    locationController.text = data["address"] ?? '';
    selectedLatitude        = (data["lat"] as num?)?.toDouble();
    selectedLongitude       = (data["lon"] as num?)?.toDouble();
  }

  Future<void> useCurrentLocation() async {
    locationController.text = 'Fetching location...';

    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          locationController.text = '';
          showCustomToast(text: 'Location permission denied.');
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        locationController.text = '';
        showCustomToast(text: 'Location permissions are permanently denied.');
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final url = Uri.parse(
        'https://nominatim.openstreetmap.org/reverse?format=json'
            '&lat=${position.latitude}&lon=${position.longitude}',
      );
      final response = await http.get(url, headers: {
        'User-Agent'      : 'RangeWaveApp_Unique_Agent_v1',
        'Accept-Language' : 'en',
      });

      if (response.statusCode == 200) {
        final data    = json.decode(response.body);
        final address = data['address'];
        String readableAddress;

        if (address != null) {
          final road = address['road']    ?? address['suburb'] ?? '';
          final city = address['city']    ?? address['state']  ?? '';
          readableAddress = (road.isNotEmpty && city.isNotEmpty)
              ? '$road, $city'
              : (data['display_name'] ?? 'Current Location');
        } else {
          readableAddress = data['display_name'] ?? 'Current Location';
        }

        locationController.text = readableAddress;
        selectedLatitude        = position.latitude;
        selectedLongitude       = position.longitude;

        final userId = await AppHelper.instance.getUserId();
        if (userId != null) {
          await LocationService().currentLocation(
            position.latitude,
            position.longitude,
            userId,
          );
        }

        showCustomToast(text: 'Location updated successfully!');
      } else {
        locationController.text = 'Location Selected';
      }
    } catch (e) {
      locationController.text = '';
      showCustomToast(text: 'Something went wrong while fetching location.');
    }
  }

  // ═══════════════════════════════════════════════════════════
  //  Car selection
  // ═══════════════════════════════════════════════════════════

  void selectCar(CarListModel car) => selectedCar.value = car;

  bool isCarSelected(CarListModel car) => selectedCar.value == car;

  // ═══════════════════════════════════════════════════════════
  //  Photo
  // ═══════════════════════════════════════════════════════════

  void selectPhoto(int index) {
    for (var photo in carPhotoList) {
      photo.isSelected.value = false;
    }
    carPhotoList[index].isSelected.value = true;
  }

  Future<void> getImage() async {
    final picker = ImagePicker();
    final file   = await picker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      carPhotoList.add(CarPhotoModel(imagePath: file.path));
    }
  }

  // ═══════════════════════════════════════════════════════════
  //  Submit Issue → API
  // ═══════════════════════════════════════════════════════════

  Future<CarIssueModel?> submitIssue() async {

    // ── Validation ────────────────────────────────────────
    if (selectedCar.value == null) {
      showCustomToast(text: 'Please select a car');
      return null;
    }
    if (dateController.text.trim().isEmpty) {
      showCustomToast(text: 'Please select a service date');
      return null;
    }

    isSubmitting.value = true;

    try {
      // ── Image file ─────────────────────────────────────
      File? imageFile;
      if (carPhotoList.isNotEmpty) {
        imageFile = File(carPhotoList.first.imagePath);
      }

      // ── Audio file ─────────────────────────────────────
      File? audioFile;
      if (voiceNotePath != null) {
        audioFile = File(voiceNotePath!);
      }

      // ── Date: "2026-04-07" ─────────────────────────────
      final d = selectedDate.value;
      final dateStr =
          '${d.year}-'
          '${d.month.toString().padLeft(2, '0')}-'
          '${d.day.toString().padLeft(2, '0')}';

      // ── Time: "09:32am" ────────────────────────────────
      final timeStr =
          '${timeText.value.replaceAll(' ', '')}${isAm.value ? 'am' : 'pm'}';

      // ── API call ───────────────────────────────────────
      final response = await _issueService.submitCarIssue(
        carId       : selectedCar.value!.id,
        description : problemController.text.trim(),
        serviceDate : dateStr,
        serviceTime : timeStr,
        latitude    : selectedLatitude  ?? 0.0,
        longitude   : selectedLongitude ?? 0.0,
        imageFile   : imageFile,
        audioFile   : audioFile,
      );

      if (response.data != null) {
        return response.data;
      } else {
        showCustomToast(text: response.error ?? 'Submission failed');
        return null;
      }
    } catch (e) {
      showCustomToast(text: 'Something went wrong');
      return null;
    } finally {
      isSubmitting.value = false;
    }
  }

  // ═══════════════════════════════════════════════════════════
  //  Lifecycle
  // ═══════════════════════════════════════════════════════════

  @override
  void onClose() {
    problemController.dispose();
    dateController.dispose();
    locationController.dispose();
    super.onClose();
  }
}

// ── Photo model ────────────────────────────────────────────
class CarPhotoModel {
  final String imagePath;
  final RxBool isSelected;

  CarPhotoModel({required this.imagePath, bool isSelected = false})
      : isSelected = isSelected.obs;
}