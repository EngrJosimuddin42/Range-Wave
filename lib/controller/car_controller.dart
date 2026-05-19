import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:range_wave/core/utils/app_helper.dart';
import 'package:range_wave/core/utils/custom_toast.dart';
import 'package:range_wave/model/customer_car_list.dart';
import 'package:range_wave/service/car_service.dart';

class CarController extends GetxController {
  final CarService _carService = CarService();

  RxList<CarListModel> carList = RxList<CarListModel>();
  RxBool isLoading = RxBool(false);
  RxBool isLoading2 = RxBool(false);
  RxBool isImageLoading = RxBool(false);
  TextEditingController brandNameController = TextEditingController();
  TextEditingController modelNameController = TextEditingController();
  TextEditingController yearController = TextEditingController();
  TextEditingController licensePlateController = TextEditingController();
  TextEditingController tagNumberController = TextEditingController();
  TextEditingController codeController = TextEditingController();
  final RxList<XFile> selectedImages = RxList<XFile>([]);
  final RxList<String> uploadedImageIds = RxList<String>([]);

  @override
  void onInit() {
    getCars();
    super.onInit();
  }

  Future<void> getImages() async {
    final picker = ImagePicker();
    final List<XFile> files = await picker.pickMultiImage();

    if (files.isNotEmpty) {
      selectedImages.addAll(files);
      for (var file in files) {
        await _uploadImage(file);
      }
    }
  }

  Future<void> _uploadImage(XFile file) async {
    try {
      isImageLoading.value = true;
      final String? token = await AppHelper.instance.getAccessToken();
      if (token != null) {
        final resp = await _carService.addCarImage(File(file.path), token);
        if (resp.success && resp.data != null) {
          uploadedImageIds.add(resp.data!);
          showCustomToast(
            text: 'Image uploaded successfully!',
            toastType: ToastTypesInfo(ToastTypes.success),
          );
        } else {
          showCustomToast(
            text: resp.error ?? 'Image upload failed',
            toastType: ToastTypesInfo(ToastTypes.error),
          );
        }
      }
    } catch (e) {
      debugPrint('IMAGE PICK/UPLOAD ERROR: $e');
    } finally {
      isImageLoading.value = false;
    }
  }

  void removeImage(int index) {
    if (index >= 0 && index < selectedImages.length) {
      selectedImages.removeAt(index);
      if (index < uploadedImageIds.length) {
        uploadedImageIds.removeAt(index);
      }
    }
  }

  Future<void> getCars({bool force = false}) async {
    if (carList.isNotEmpty && !force) return;

    final token = await AppHelper.instance.getAccessToken();
    if (token == null) {
      debugPrint('Aborting getCars: No access token found.');
      return;
    }

    isLoading2.value = true;
    final response = await _carService.getCustomerCarList();
    if (response.data != null) {
      isLoading2.value = false;
      carList.assignAll(response.data ?? []);
    } else {
      isLoading2.value = false;
    }
  }

  Future<bool> customerAddCar() async {
    isLoading.value = true;

    final String carImageIds = uploadedImageIds.join(',');

    final response = await _carService.customerAddCar(
      brandNameController.text.trim(),
      modelNameController.text.trim(),
      yearController.text.trim(),
      licensePlateController.text.trim(),
      tagNumberController.text.trim(),
      carImageIds,
    );

    if (response.data != null) {
      isLoading.value = false;
      await getCars(force: true);
      clearForm();
      return true;
    } else {
      isLoading.value = false;
      showCustomToast(
        text: response.error ?? 'Something went wrong, Please try again...',
        toastType: ToastTypesInfo(ToastTypes.error),
      );
      return false;
    }
  }

  void clearForm() {
    brandNameController.clear();
    modelNameController.clear();
    yearController.clear();
    licensePlateController.clear();
    tagNumberController.clear();
    codeController.clear();
    selectedImages.clear();
    uploadedImageIds.clear();
  }
}
