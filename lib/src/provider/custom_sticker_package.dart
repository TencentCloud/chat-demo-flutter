import 'package:flutter/material.dart';
import 'package:tim_ui_kit_sticker_plugin/utils/tim_ui_kit_sticker_data.dart';

class CustomStickerPackageData extends ChangeNotifier {
  List<CustomStickerPackage> _customStickerPackageList = [];
  List<CustomStickerPackage> get customStickerPackageList {
    return _customStickerPackageList;
  }

  set customStickerPackageList(List<CustomStickerPackage> list) {
    _customStickerPackageList = list;
    notifyListeners();
  }
}
