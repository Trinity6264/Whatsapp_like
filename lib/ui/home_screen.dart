import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project1/models/current_user_model.dart';
import 'package:project1/models/firestore_models.dart';
import 'package:project1/services/custom_firebase.dart';
import 'package:project1/services/custom_firestore.dart';
import 'package:project1/ui/chat_screen.dart';
import 'package:project1/ui/edit_profile.dart';
import 'package:project1/ui/image_view.dart';
import 'package:project1/ui/show_dialog.dart';
import 'package:project1/ui/story_view.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // instance on custom local firebase
  static final _auth = CustomFirebase.instance;

  // text edit controller
  static final TextEditingController _controller = TextEditingController();

  // creating cahtRoomId
  String generatingChatRoomIdWithDisplayName(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return '$b\@$a';
    } else {
      return '$a\@$b';
    }
  }

  File? image;

  Future<void> getImage(BuildContext context, ImageSource source) async {
    try {
      final _imagePicker = await ImagePicker().pickImage(
        source: source,
      );
      if (_imagePicker != null) {
        setState(
          () {
            image = File(_imagePicker.path);
          },
        );
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ImageView(image: image),
          ),
        );
      }
    } on Exception catch (e) {
      print(e);
    }
  }

  void _updateDetails(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditProfile(),
      ),
    );
  }

  Future<void> _showMyDialogProfile(String imageUrl, String name) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: EdgeInsets.symmetric(vertical: 210),
          insetAnimationCurve: Curves.bounceInOut.flipped,
          insetAnimationDuration: Duration(milliseconds: 5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: ShowDialog(imageUrl: imageUrl, name: name),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final _user = Provider.of<CurrentUserModel>(context);
    Size _size = MediaQuery.of(context).size;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => Container(
              padding: const EdgeInsets.symmetric(vertical: 230),
              child: AlertDialog(
                elevation: 0.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25)),
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
        },
        child: Icon(Icons.camera),
      ),
      appBar: AppBar(
        elevation: 0.0,
        title: Text('Whatsapp-Like'),
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: IconButton(
              onPressed: () async {
                return _updateDetails(context);
              },
              icon: Icon(Icons.settings),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: IconButton(
              onPressed: () async {
                return _auth.signOut();
              },
              icon: Icon(Icons.exit_to_app_rounded),
            ),
          ),
        ],
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: StreamBuilder(
                stream: CustomFireStore.instance.fromFirestoreStatusAll,
                builder: (context,
                    AsyncSnapshot<List<FirestoreModelsStatus>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: Container(),
                    );
                  } else if (!snapshot.hasData) {
                    return Center(
                      child: Text('No data Found'),
                    );
                  } else {
                    return Container(
                      height: _size.height * 0.4 / 3.8,
                      width: double.infinity,
                      child: ListView.builder(
                        itemCount: snapshot.data!.length,
                        scrollDirection: Axis.horizontal,
                        physics: BouncingScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics(),
                        ),
                        itemBuilder: (_, index) {
                          final data = snapshot.data![index];
                          if (data.status.isNotEmpty) {
                            return Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: GestureDetector(
                                    onTap: () {
                                      if (data.status.isEmpty) {
                                        return null;
                                      } else {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (_) => CustomStoryView(
                                              statusData: data.status,
                                              modelsStatus: data,
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                    child: CircleAvatar(
                                      backgroundColor: Colors.indigo,
                                      maxRadius: 30,
                                      child: CircleAvatar(
                                        maxRadius: 28,
                                        backgroundImage: data.photoUrl != null
                                            ? NetworkImage(
                                                data.photoUrl.toString())
                                            : NetworkImage(
                                                'https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png'),
                                      ),
                                    ),
                                  ),
                                ),
                                Text(data.displayName.toString()),
                              ],
                            );
                          } else {
                            return Container();
                          }
                        },
                      ),
                    );
                  }
                },
              ),
            ),
            Expanded(
              child: Container(
                child: StreamBuilder(
                  stream: CustomFireStore.instance.fromFirestoreAll,
                  builder:
                      (context, AsyncSnapshot<List<FirestoreModels>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (!snapshot.hasData) {
                      return Container();
                    } else {
                      return Container(
                        width: double.infinity,
                        child: ListView.builder(
                          itemCount: snapshot.data!.length,
                          scrollDirection: Axis.vertical,
                          physics: BouncingScrollPhysics(
                            parent: AlwaysScrollableScrollPhysics(),
                          ),
                          itemBuilder: (_, index) {
                            final data = snapshot.data![index];
                            return Card(
                              child: GestureDetector(
                                onTap: () {
                                  final chatRoomId =
                                      generatingChatRoomIdWithDisplayName(
                                    _user.displayName.toString(),
                                    data.displayName.toString(),
                                  );
                                  Map<String, dynamic> chatRoomInfo = {
                                    'users': [
                                      _user.displayName.toString(),
                                      data.displayName.toString(),
                                    ],
                                  };
                                  CustomFireStore.instance
                                      .createChatRoom(chatRoomId, chatRoomInfo);
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => ChatScreen(
                                        data: data,
                                      ),
                                    ),
                                  );
                                },
                                child: ListTile(
                                  leading: GestureDetector(
                                    onTap: () {
                                      _showMyDialogProfile(
                                        data.photoUrl.toString(),
                                        data.displayName.toString(),
                                      );
                                    },
                                    child: CircleAvatar(
                                      backgroundImage: NetworkImage(
                                        data.photoUrl.toString(),
                                      ),
                                    ),
                                  ),
                                  title: Text(data.displayName.toString()),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
