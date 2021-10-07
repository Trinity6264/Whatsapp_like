import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

import 'package:project1/services/custom_firestore.dart';

// ignore: must_be_immutable
class ImageView extends StatelessWidget {
  ImageView({Key? key, required this.image}) : super(key: key);

  File? image;

  TextEditingController _controller = TextEditingController();

  static final _store = CustomFireStore.instance;

  String? _userPicUrl;

  Future<void> upLoadPic(File? image) async {
    final _fileName = basename(image!.path);
    Reference reference =
        FirebaseStorage.instance.ref('users').child(_fileName);
    UploadTask uploadTask = reference.putFile(image);
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
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: FileImage(image!),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: TextField(
                        controller: _controller,
                        decoration: InputDecoration(
                          prefixIcon: IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.emoji_emotions_outlined),
                          ),
                          border: InputBorder.none,
                          filled: true,
                          fillColor: Colors.white,
                          enabled: true,
                          hintText: 'Add caption',
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusColor: Colors.white,
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(color: Colors.white)),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 7),
                    child: ElevatedButton(
                      onPressed: () async {
                        upLoadPic(image).then((value) {
                          _store.addStatus(
                            caption: _controller.text,
                            imageUlr: _userPicUrl.toString(),
                          );
                        });
                        Navigator.of(context).pop();
                      },
                      child: Icon(Icons.send),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(80),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
