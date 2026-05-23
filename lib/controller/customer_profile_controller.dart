import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:range_wave/core/utils/custom_http.dart';
import 'package:range_wave/core/app_credentials.dart';
import 'package:range_wave/core/utils/custom_toast.dart';
import 'package:http/http.dart' as http;

class CustomerProfileController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isUpdating = false.obs;
  RxBool isAvatarUploading = false.obs;
  RxMap<String, dynamic> customerData = RxMap<String, dynamic>({});
  RxString profileImageUrl = ''.obs;
  Rx<File?> selectedAvatar = Rx<File?>(null);

  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    loadProfile();
    super.onInit();
  }

  Future<void> pickAvatar() async {
    final file = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
      maxWidth: 800,
      maxHeight: 800,
    );
    if (file != null) {
      selectedAvatar.value = File(file.path);
    }
  }

  Future<void> loadProfile({bool forceReload = false}) async {
    if (!forceReload && customerData.isNotEmpty) return;

    isLoading.value = true;
    try {
      final response = await CustomHttp.get(
        endpoint: 'customer/me',
        needAuth: true,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data as Map<String, dynamic>;
        customerData.assignAll(data);

        final avatar = data['avatar_url']?.toString() ?? '';
        profileImageUrl.value = AppCredentials.resolveUrl(avatar);
      }
    } catch (e) {
      print('Customer profile error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> updateProfile({
    required String fullName,
    required String phone,
    required String address,
  }) async {
    isUpdating.value = true;
    try {
      final files = <http.MultipartFile>[];

      if (selectedAvatar.value != null) {
        files.add(
          await http.MultipartFile.fromPath(
            'avatar',
            selectedAvatar.value!.path,
          ),
        );
      }

      final response = await CustomHttp.multipart(
        endpoint: 'auth/update-profile',
        method: CommonCustomMethods.POST,
        fields: {
          'full_name': fullName,
          'phone': phone.isEmpty ? '' : phone,
          'address': address,
        },
        files: files,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        selectedAvatar.value = null;

        final profile = response.data['profile'];
        if (profile != null) {
          customerData.assignAll({
            ...customerData,
            'full_name':  profile['full_name']  ?? customerData['full_name']  ?? '',
            'phone':      profile['phone']      ?? customerData['phone']      ?? '',
            'address':    profile['address']    ?? customerData['address']    ?? '',
            'avatar_url': profile['avatar_url'] ?? customerData['avatar_url'] ?? '',
          });

          final avatar = profile['avatar_url']?.toString() ?? '';
          if (avatar.isNotEmpty) {
            profileImageUrl.value = AppCredentials.resolveUrl(avatar);
          }
        }

        showCustomToast(
          text: 'Profile updated successfully',
          toastType: ToastTypesInfo(ToastTypes.success),
        );
        return true;
      } else {
        showCustomToast(
          text: response.error ?? 'Failed to update profile',
          toastType: ToastTypesInfo(ToastTypes.error),
        );
        return false;
      }
    } catch (e) {
      print('Update profile error: $e');
      showCustomToast(
        text: 'Something went wrong',
        toastType: ToastTypesInfo(ToastTypes.error),
      );
      return false;
    } finally {
      isUpdating.value = false;
    }
  }
}