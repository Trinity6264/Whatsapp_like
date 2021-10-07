import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project1/models/current_user_model.dart';
import 'package:project1/services/custom_firebase.dart';
import 'package:project1/shared/text_field.dart';
import 'package:project1/ui/edit_image_select.dart';
import 'package:provider/provider.dart';

class EditProfile extends StatefulWidget {
  EditProfile({Key? key}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController? _textCtrl = TextEditingController();
  File? image;

  bool isUpdating = false;

  Future<void> getImage(ImageSource source) async {
    try {
      final _imagePicker = await ImagePicker().pickImage(source: source);
      if (_imagePicker != null) {
        setState(() {
          image = File(_imagePicker.path);
        });
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => EditImage(image: image),
          ),
        );
      }
    } on Exception catch (e) {
      print(e);
    }
  }

  imageSelect(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    showModalBottomSheet(
      context: context,
      builder: (_) => Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Container(
          height: _size.height * 0.4 / 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  'Profile Photo',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    child: Column(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.red,
                          child: FaIcon(
                            FontAwesomeIcons.trash,
                            color: Colors.white,
                          ),
                        ),
                        Text('Remove Photo'),
                      ],
                    ),
                  ),
                  Container(
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            getImage(ImageSource.gallery);
                            Navigator.pop(context);
                          },
                          child: CircleAvatar(
                            backgroundColor: Colors.blue,
                            child: FaIcon(
                              FontAwesomeIcons.piedPiper,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Text('Galley'),
                      ],
                    ),
                  ),
                  Container(
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            getImage(ImageSource.camera);
                            Navigator.pop(context);
                          },
                          child: CircleAvatar(
                            backgroundColor: Colors.amber,
                            child: FaIcon(
                              FontAwesomeIcons.photoVideo,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Text('Camera'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final _user = Provider.of<CurrentUserModel?>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    imageSelect(context);
                  },
                  child: CircleAvatar(
                    radius: 80,
                    backgroundColor: Colors.indigo.shade200,
                    child: ClipOval(
                      child: SizedBox(
                        height: 155,
                        width: 155,
                        child: image != null
                            ? Image.file(
                                image!,
                                fit: BoxFit.cover,
                              )
                            : _user!.photoUrl != null
                                ? Image.network(
                                    _user.photoUrl.toString(),
                                    fit: BoxFit.cover,
                                  )
                                : Icon(
                                    FontAwesomeIcons.camera,
                                    color: Color(0xFF000000),
                                  ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: ListTile(
                  leading: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(Icons.person),
                  ),
                  title: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    child: Text('Username'),
                  ),
                  subtitle: TextField(
                    controller: _textCtrl,
                    decoration: txtField.copyWith(
                      fillColor: Colors.indigo.shade200,
                      hintText: FirebaseAuth.instance.currentUser?.displayName,
                      hintStyle: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  )),
                  onPressed: () {
                    if (_textCtrl?.text != null) {
                      setState(() {
                        isUpdating = true;
                      });
                      CustomFirebase.instance
                          .updatinguserName(_textCtrl!.text)
                          .then((value) {
                        setState(() {
                          isUpdating = false;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Username updated'),
                          ),
                        );
                      });
                    } else {
                      return null;
                    }
                  },
                  child: Text('Update'),
                ),
              ),
              isUpdating
                  ? Center(child: CircularProgressIndicator())
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
