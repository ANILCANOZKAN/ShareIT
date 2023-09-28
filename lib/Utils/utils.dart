import 'dart:io';
import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';

pickImage(ImageSource source) async {
  final ImagePicker _imagePicker = ImagePicker();
  XFile? _file = await _imagePicker.pickImage(source: source);
  if (_file != null) {
    return await _file.readAsBytes();
  }
}

pickMultipleImage() async {
  final ImagePicker _imagePicker = ImagePicker();
  List<XFile?> _files = await _imagePicker.pickMultiImage();
  List<Uint8List?> selectedImages = [];
  if (_files != null) {
    for (int i = 0; i < _files.length; i++) {
      selectedImages.add(await _files[i]!.readAsBytes());
    }
    return selectedImages;
  }
  return [];
}
