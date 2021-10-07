import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SelectImage with ChangeNotifier {
  File? image;

  Future<void> getImage(BuildContext context, ImageSource source) async {
    try {
      final _imagePicker = await ImagePicker().pickImage(source: source);
      if (_imagePicker != null) {
        image = File(_imagePicker.path);
        notifyListeners();
      }
    } on Exception catch (e) {
      print(e);
    }
  }

  imageSelect(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => Container(
        padding: const EdgeInsets.symmetric(vertical: 230),
        child: AlertDialog(
          elevation: 0.0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          title: Text('Select Image source'),
          content: Column(
            children: [
              ListTile(
                leading: Icon(Icons.camera_alt_rounded),
                title: Text('Camera'),
                autofocus: true,
                focusNode: FocusNode(canRequestFocus: true),
                onTap: () async {
                  Navigator.pop(context);
                  return await getImage(context, ImageSource.camera);
                },
              ),
              ListTile(
                leading: Icon(Icons.filter_outlined),
                title: Text('Gallery'),
                autofocus: true,
                focusNode: FocusNode(canRequestFocus: true),
                onTap: () async {
                  Navigator.pop(context);
                  return await getImage(context, ImageSource.gallery);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
