import 'dart:io';

import 'package:get/get.dart';

class UserImageGetx extends GetxController {
  final Rx<File?> _imageFile = Rx<File?>(null);
  File? get imageFile => _imageFile.value;

  void setImageFile(File? file) {
    _imageFile.value = file;
  }

  void clearImage() {
    _imageFile.value = null;
  }
}
