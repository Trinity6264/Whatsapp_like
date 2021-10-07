import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project1/models/current_user_model.dart';
import 'package:project1/models/firestore_models.dart';
import 'package:project1/services/custom_firebase.dart';
import 'package:project1/services/custom_firestore.dart';
import 'package:project1/services/shared_prefs.dart';
import 'package:project1/ui/message_widget.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key, required this.data}) : super(key: key);

  final FirestoreModels data;

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _textCtrl = TextEditingController();
  final _focus = FocusNode();
  final _store = CustomFireStore.instance;
  bool isChanged = false;
  static final constantWallpaper = 'images/wallpaper.jpg';

  String? chatRoomId;
  String? myName;
  String? myUid;
  String? myProfilePic;
  String? myEmail;

  String generatingChatRoomIdWithDisplayName(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return '$b\@$a';
    } else {
      return '$a\@$b';
    }
  }

  getCurrentUserDetails() {
    myName = FirebaseAuth.instance.currentUser!.displayName;
    myProfilePic = FirebaseAuth.instance.currentUser!.photoURL;
    myEmail = FirebaseAuth.instance.currentUser!.email;
    myUid = FirebaseAuth.instance.currentUser!.uid;
    chatRoomId = generatingChatRoomIdWithDisplayName(
      widget.data.displayName.toString(),
      myName.toString(),
    );
  }

  @override
  void initState() {
    super.initState();
    getCurrentUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    final _user = Provider.of<CurrentUserModel>(context);
    SharedPrefs.instance.saveData(context);
    Size _size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back),
            ),
            CircleAvatar(
              backgroundImage:
                  CachedNetworkImageProvider(widget.data.photoUrl.toString()),
            ),
            SizedBox(width: 20),
            Text(widget.data.displayName.toString()),
          ],
        ),
        actions: [
          Consumer<CustomFirebase>(builder: (_, data, __) {
            return data.customSwitch();
          }),
        ],
      ),
      body: Stack(
        children: [
          Container(
              width: _size.width,
              height: _size.height,
              child: Consumer<CustomFirebase>(
                builder: (_, data, __) {
                  return !data.isRounded!
                      ? Image.asset(
                          constantWallpaper,
                          fit: BoxFit.cover,
                          colorBlendMode: BlendMode.darken,
                          color: Colors.black.withOpacity(0.4),
                        )
                      : Image.network(
                          widget.data.photoUrl.toString(),
                          fit: BoxFit.cover,
                          colorBlendMode: BlendMode.darken,
                          color: Colors.black.withOpacity(0.4),
                        );
                },
              )),
          Container(
            height: _size.height * 0.8,
            child: StreamBuilder(
              stream: CustomFireStore.instance
                  .message(chatRoomId: chatRoomId.toString()),
              builder: (context, AsyncSnapshot<List<Message>> snapshot) {
                if (!snapshot.hasData) {
                  return Container();
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data?.length,
                    physics: AlwaysScrollableScrollPhysics(
                      parent: BouncingScrollPhysics(),
                    ),
                    reverse: true,
                    itemBuilder: (_, index) {
                      final data = snapshot.data![index];
                      return MessageWidget(
                        message: data,
                        isMe: data.userId == _user.userId,
                      );
                    },
                  );
                }
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _textCtrl,
                      focusNode: _focus,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        fillColor: Colors.white,
                        filled: true,
                        enabled: true,
                        hintText: 'Type a message',
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(color: Colors.white)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(color: Colors.white)),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 20),
                GestureDetector(
                  onTap: () async {
                    if (_textCtrl.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          behavior: SnackBarBehavior.fixed,
                          elevation: 0.0,
                          content: Text('Field is Empty'),
                        ),
                      );
                    } else {
                      return _store
                          .sendPrivateMessage(
                        chatRoomId: chatRoomId.toString(),
                        messageBody: _textCtrl.text.trim(),
                        time: DateTime.now(),
                        uid: myUid.toString(),
                        imageUrl: myProfilePic.toString(),
                      )
                          .then((value) {
                        _textCtrl.clear();
                        _focus.unfocus();
                      });
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 10),
                    width: _size.height * 0.2 / 3,
                    height: _size.height * 0.2 / 3,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.indigo,
                    ),
                    child: Icon(Icons.send, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
