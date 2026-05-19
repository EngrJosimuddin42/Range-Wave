import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../gen/assets.gen.dart';
import '../model/car_model.dart';

class ScheduledServiceController extends GetxController {
  final Rxn<CarModel> selectedCard = Rxn<CarModel>(null);
  RxBool isSelectCar = RxBool(false);


  final RxList<CarModel> carList = [
    CarModel(
      name: 'Honda Civic',
      imagePath: Assets.images.car1.path,
      certifiedIconPath: Assets.icons.certified.path,
      isSelected: false,
    ),
    CarModel(
      name: 'Toyota Corolla',
      imagePath: Assets.images.car2.path,
      certifiedIconPath: Assets.icons.certified.path,
      isSelected: false,
    ),
    CarModel(
      name: 'BMW X5',
      imagePath: Assets.images.car3.path,
      certifiedIconPath: Assets.icons.certified.path,
      isSelected: false,
    ),
  ].obs;

  final RxList<CarPhotoModel> carPhotoList = [
    CarPhotoModel(imagePath: Assets.images.car1.path, isSelected: false),
    CarPhotoModel(imagePath: Assets.images.car2.path, isSelected: false),
  ].obs;

  void selectPhoto(int index) {
    for (var photo in carPhotoList) {
      photo.isSelected.value = false;
    }
    carPhotoList[index].isSelected.value = true;
  }

  void selectCar(CarModel car) {
    selectedCard.value = car;
    carList.value = carList
        .map((c) => c.copyWith(isSelected: c == car))
        .toList();
  }

  final Rx<XFile?> selectedImage = Rx<XFile?>(null);

  Future<void> getImage() async {
    final picker = ImagePicker();
    final file = await picker.pickImage(source: ImageSource.gallery);

    if (file != null) {
      selectedImage.value = file;
      carPhotoList.add(CarPhotoModel(imagePath: file.path, isSelected: false));
    }
  }
}

class CarPhotoModel {
  final String imagePath;
  RxBool isSelected;

  CarPhotoModel({required this.imagePath, bool isSelected = false})
    : isSelected = isSelected.obs;
}
