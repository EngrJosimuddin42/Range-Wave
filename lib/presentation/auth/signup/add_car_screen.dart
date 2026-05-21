import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:range_wave/controller/car_controller.dart';
import 'package:range_wave/core/utils/color/app_colors.dart';
import 'package:range_wave/core/utils/common_widget/app_title.dart';
import 'package:range_wave/core/utils/common_widget/primary_button.dart';

import '../../../../core/navigation/app_routes.dart';
import '../../../../core/utils/common_widget/added_car_card.dart';
import '../../../../core/utils/common_widget/app_top_section.dart';
import '../../../../core/utils/common_widget/custom_text_field.dart';
import '../../../../gen/assets.gen.dart';
import '../../../core/utils/app_helper.dart';
import '../../../service/car_service.dart';

// ── Holds all state for one "Add Car" form entry ──────────────────────────
class _CarFormEntry {
  final TextEditingController brand = TextEditingController();
  final TextEditingController model = TextEditingController();
  final TextEditingController code = TextEditingController();
  final TextEditingController year = TextEditingController();
  final TextEditingController licensePlate = TextEditingController();
  final TextEditingController tagNumber = TextEditingController();
  XFile? image;
  bool isLoading = false;
  bool isImageLoading = false;

  void dispose() {
    brand.dispose();
    model.dispose();
    code.dispose();
    year.dispose();
    licensePlate.dispose();
    tagNumber.dispose();
  }
}

class AddCarScreen extends StatefulWidget {
  const AddCarScreen({super.key});

  @override
  State<AddCarScreen> createState() => _AddCarScreenState();
}

class _AddCarScreenState extends State<AddCarScreen> {
  final CarController controller = Get.put(CarController());

  // First form is always visible; more are added on each "Add New Car" click
  final List<_CarFormEntry> _forms = [_CarFormEntry()];

  void _addNewForm() {
    setState(() => _forms.add(_CarFormEntry()));
  }

  void _removeForm(int index) {
    _forms[index].dispose();
    setState(() => _forms.removeAt(index));
  }

  Future<void> _pickImage(int index) async {
    setState(() => _forms[index].isImageLoading = true);
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (picked != null) _forms[index].image = picked;
      _forms[index].isImageLoading = false;
    });
  }

  Future<void> _saveCar(int index) async {
    final form = _forms[index];
    setState(() => form.isLoading = true);

    controller.brandNameController.text = form.brand.text;
    controller.modelNameController.text = form.model.text;
    controller.codeController.text = form.code.text;
    controller.yearController.text = form.year.text;
    controller.licensePlateController.text = form.licensePlate.text;
    controller.tagNumberController.text = form.tagNumber.text;

    if (form.image != null) {
      final token = await AppHelper.instance.getAccessToken();
      if (token != null) {
        final resp = await CarService().addCarImage(
          File(form.image!.path),
          token,
        );
        if (resp.success && resp.data != null) {
          controller.uploadedImageIds.assignAll([resp.data!]);
        }
      }
    }

    final success = await controller.customerAddCar();

    if (success == true) {
      _removeForm(index);
    } else {
      setState(() => form.isLoading = false);
    }
  }

  @override
  void dispose() {
    for (final f in _forms) f.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppTopLogo(),
              SizedBox(height: 50.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── My Cars section ───────────────────────────────────
                    Obx(() {
                      if (controller.isLoading2.value) {
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                          child: Center(
                            child: CircularProgressIndicator(
                              color: AppColors.primary,
                              strokeWidth: 2,
                            ),
                          ),
                        );
                      }
                      if (controller.carList.isEmpty)
                        return const SizedBox.shrink();
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppTitle(
                            title: 'My Cars',
                            isShowAll: false,
                            onTap: () {},
                          ),
                          SizedBox(height: 20.h),
                          SizedBox(
                            height: 160.h,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: controller.carList.length,
                              separatorBuilder: (_, __) =>
                                  SizedBox(width: 16.w),
                              itemBuilder: (context, index) {
                                final car = controller.carList[index];
                                return AddedCarCard(
                                  carName: car.brand,
                                  carModel: car.model,
                                  image: car.imageUrl,
                                );
                              },
                            ),
                          ),
                          SizedBox(height: 24.h),
                        ],
                      );
                    }),

                    // ── One card per "Add New Car" click ──────────────────
                    ...List.generate(_forms.length, (i) {
                      return _CarFormSection(
                        key: ValueKey(i),
                        entry: _forms[i],
                        index: i,
                        onPickImage: () => _pickImage(i),
                        onRemoveImage: () =>
                            setState(() => _forms[i].image = null),
                        onPickYear: (yr) =>
                            setState(() => _forms[i].year.text = yr.toString()),
                        onSave: () => _saveCar(i),
                        onDiscard: () => _removeForm(i),
                      );
                    }),

                    SizedBox(height: 16.h),

                    // ── Add New Car button ─────────────────────────────────
                    GestureDetector(
                      onTap: _addNewForm,
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          vertical: 14.h,
                          horizontal: 16.w,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(color: AppColors.primary),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add,
                              color: AppColors.primary,
                              size: 20.w,
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              'Add New Car',
                              style: TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                fontFamily: GoogleFonts.manrope().fontFamily,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 24.h),

                    // ── Save & Continue ────────────────────────────────────
                    PrimaryButton(
                      text: 'Save & Continue',
                      backgroundColor: AppColors.primary,
                      textStyle: TextStyle(
                        color: AppColors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        fontFamily: GoogleFonts.manrope().fontFamily,
                      ),
                      onTap: () => Get.toNamed(AppRoutes.userBottomNav),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30.h),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Single Add Car form card ───────────────────────────────────────────────
class _CarFormSection extends StatelessWidget {
  final _CarFormEntry entry;
  final int index;
  final VoidCallback onPickImage;
  final VoidCallback onRemoveImage;
  final ValueChanged<int> onPickYear;
  final VoidCallback onSave;
  final VoidCallback onDiscard;

  const _CarFormSection({
    super.key,
    required this.entry,
    required this.index,
    required this.onPickImage,
    required this.onRemoveImage,
    required this.onPickYear,
    required this.onSave,
    required this.onDiscard,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row with label + close
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Car ${index + 1}',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                  fontFamily: GoogleFonts.manrope().fontFamily,
                ),
              ),
              GestureDetector(
                onTap: onDiscard,
                child: Icon(
                  Icons.close,
                  size: 20.w,
                  color: AppColors.textPrimary.withValues(alpha: 0.4),
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),

          _ImagePickerWidget(
            entry: entry,
            onPickImage: onPickImage,
            onRemoveImage: onRemoveImage,
          ),
          SizedBox(height: 14.h),

          CustomTextField(
            filColor: AppColors.buttonTextColor,
            filled: true,
            controller: entry.brand,
            hintText: 'Enter car brand name',
            keyboardType: TextInputType.text,
          ),
          SizedBox(height: 10.h),
          CustomTextField(
            filColor: AppColors.buttonTextColor,
            filled: true,
            controller: entry.model,
            hintText: 'Enter car model',
            keyboardType: TextInputType.text,
          ),
          SizedBox(height: 10.h),
          CustomTextField(
            filColor: AppColors.buttonTextColor,
            filled: true,
            controller: entry.code,
            hintText: 'Enter code',
            keyboardType: TextInputType.text,
          ),
          SizedBox(height: 10.h),
          CustomTextField(
            filColor: AppColors.buttonTextColor,
            filled: true,
            readOnly: true,
            controller: entry.year,
            hintText: 'Select Year',
            keyboardType: TextInputType.text,
            suffixIcon: IconButton(
              onPressed: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime(DateTime.now().year + 5),
                );
                if (picked != null) onPickYear(picked.year);
              },
              icon: Icon(
                Icons.keyboard_arrow_down_outlined,
                size: 24.w,
                color: AppColors.textPrimary.withValues(alpha: 0.5),
              ),
            ),
          ),
          SizedBox(height: 10.h),
          CustomTextField(
            filColor: AppColors.buttonTextColor,
            filled: true,
            controller: entry.licensePlate,
            hintText: 'Enter license plate number',
            keyboardType: TextInputType.text,
          ),
          SizedBox(height: 10.h),
          CustomTextField(
            filColor: AppColors.buttonTextColor,
            filled: true,
            controller: entry.tagNumber,
            hintText: 'Enter tag number',
            keyboardType: TextInputType.text,
          ),
          SizedBox(height: 20.h),

          PrimaryButton(
            loading: entry.isLoading,
            text: 'Save Car',
            backgroundColor: AppColors.primary,
            textStyle: TextStyle(
              color: AppColors.white,
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              fontFamily: GoogleFonts.manrope().fontFamily,
            ),
            onTap: onSave,
          ),
        ],
      ),
    );
  }
}

// ── Image picker widget (single image per form) ────────────────────────────
class _ImagePickerWidget extends StatelessWidget {
  final _CarFormEntry entry;
  final VoidCallback onPickImage;
  final VoidCallback onRemoveImage;

  const _ImagePickerWidget({
    required this.entry,
    required this.onPickImage,
    required this.onRemoveImage,
  });

  @override
  Widget build(BuildContext context) {
    // No image selected yet — show dotted upload area
    if (entry.image == null) {
      return DottedBorder(
        options: RectDottedBorderOptions(
          color: AppColors.hintText.withValues(alpha: 0.6),
          strokeWidth: 2,
          dashPattern: [6, 3],
        ),
        child: GestureDetector(
          onTap: onPickImage,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 20.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
            ),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (entry.isImageLoading)
                  Padding(
                    padding: EdgeInsets.only(bottom: 12.h),
                    child: CircularProgressIndicator(
                      color: AppColors.primary,
                      strokeWidth: 2,
                    ),
                  )
                else
                  Assets.images.addImage.image(),
                SizedBox(height: 10.h),
                Text(
                  entry.isImageLoading
                      ? "Uploading photo..."
                      : "Upload Car Photo",
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    fontFamily: GoogleFonts.manrope().fontFamily,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  "Tap to add a photo",
                  style: TextStyle(
                    color: AppColors.textTernary.withValues(alpha: 0.5),
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Image selected — show preview with a remove button and tap-to-change
    return GestureDetector(
      onTap: onPickImage, // tap to change image
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: Image.file(
              File(entry.image!.path),
              width: double.infinity,
              height: 160.h,
              fit: BoxFit.cover,
            ),
          ),
          // "Change" label overlay at the bottom
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 6.h),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.4),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(12.r),
                  bottomRight: Radius.circular(12.r),
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                "Tap to change",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          // Remove (✕) button at top-right
          Positioned(
            top: 6.h,
            right: 6.w,
            child: GestureDetector(
              onTap: onRemoveImage,
              child: Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.5),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.close, color: Colors.white, size: 16.w),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
