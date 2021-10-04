import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_manager/photo_manager.dart';

class SelectedImageLogic extends GetxController {
  static SelectedImageLogic to = Get.find<SelectedImageLogic>();
  List<AssetEntity> selectedImages = [];

  List<String> get selectedImagesIds => selectedImages.map((e) => e.id).toList();
  bool get hasSelectedImage => selectedImages.isNotEmpty;

  handleImageSelect(AssetEntity assetEntity, {bool allowMultiSelect = true}) {
    if (allowMultiSelect) {
      bool alreadySelected = selectedImages.any((element) => element.id == assetEntity.id);
      if (alreadySelected) {
        selectedImages = selectedImages.where((element) => element.id != assetEntity.id).toList();
      } else {
        selectedImages.add(assetEntity);
      }
    } else {
      selectedImages = [assetEntity];
    }

    update();
  }

  clearSelected() {
    selectedImages = [];
    update();
  }
}
