class CarModel {
  final String name;
  final String imagePath;
  final String certifiedIconPath;
  final bool isSelected;

  CarModel({
    required this.name,
    required this.imagePath,
    required this.certifiedIconPath,
    this.isSelected = false,
  });

  CarModel copyWith({bool? isSelected}) {
    return CarModel(
      name: name,
      imagePath: imagePath,
      certifiedIconPath: certifiedIconPath,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}