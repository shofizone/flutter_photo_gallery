import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_photo_gallery/gallery_logic.dart';
import 'package:flutter_photo_gallery/gallery_folder_list_botom_sheet.dart';
import 'package:flutter_photo_gallery/gallery_grid_view.dart';
import 'package:flutter_photo_gallery/selected_image_logic.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final galleryController = Get.put(GalleryLogic());
  final selectedImageController = Get.put(SelectedImageLogic());

  @override
  void initState() {
    super.initState();
    Get.find<GalleryLogic>().getItems();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.find<SelectedImageLogic>().clearSelected();
        return true;
      },
      child: GetBuilder<GalleryLogic>(
        builder: (logic) {
          return GetBuilder<SelectedImageLogic>(
            builder: (selectedImageController) {
              return Scaffold(
                appBar: AppBar(
                  leading: selectedImageController.hasSelectedImage
                      ? TextButton(
                          onPressed: () {
                            selectedImageController.clearSelected();
                          },
                          child: const Text(
                            "Clear",
                            style: TextStyle(color: Colors.white),
                          ))
                      : const SizedBox(),
                  title: logic.galleryFolderList.isEmpty
                      ? null
                      : InkWell(
                          onTap: () {
                            _showFolderListBottomSheet();
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text("${logic.selectedGalleryFolderWithItems?.name}"),
                                const Icon(Icons.arrow_drop_down_outlined),
                              ],
                            ),
                          ),
                        ),
                ),
                body: RefreshIndicator(
                  onRefresh: () async {
                    await logic.getItems();
                    return;
                  },
                  child: GalleryGridView(
                    itemList: logic.selectedGalleryFolderWithItems?.items ?? [],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  _showFolderListBottomSheet() {
    Get.bottomSheet(
        GalleryFolderListBottomSheet(
          onSelect: galleryController.onSelectFolderListItem,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        ignoreSafeArea: false);
  }
}
