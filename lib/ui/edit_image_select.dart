import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:project1/services/custom_firebase.dart';

// ignore: must_be_immutable
class EditImage extends StatelessWidget {
  EditImage({Key? key, required this.image}) : super(key: key);
  final File? image;

  String? _userPicUrl;

  final _store = CustomFirebase.instance;

  Future<void> upLoadPic() async {
    final _fileName = basename(image!.path);
    Reference reference =
        FirebaseStorage.instance.ref('profiles-picturres').child(_fileName);
    UploadTask uploadTask = reference.putFile(image!);
    TaskSnapshot snapshot = await uploadTask.whenComplete(
      () {
        print('done');
      },
    );
    _userPicUrl = await snapshot.ref.getDownloadURL();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: Image.file(image!),
            ),
            Padding(
              padding: const EdgeInsets.all(50.0),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.white.withOpacity(0.5),
                      child: IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                    CircleAvatar(
                      backgroundColor: Colors.white.withOpacity(0.5),
                      child: IconButton(
                        icon: const Icon(Icons.check, color: Colors.white),
                        onPressed: () async {
                          await upLoadPic().then((value) {
                            _store.updatinguserProfile(_userPicUrl!);
                            Navigator.of(context).pop();
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
