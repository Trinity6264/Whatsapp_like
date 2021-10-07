import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project1/models/firestore_models.dart';
import 'package:project1/services/custom_firestore.dart';

import 'package:story_view/story_view.dart';

class CustomStoryView extends StatefulWidget {
  const CustomStoryView({
    Key? key,
    required this.modelsStatus,
    required this.statusData,
  }) : super(key: key);
  final List<dynamic> statusData;
  final FirestoreModelsStatus modelsStatus;
  @override
  _CustomStoryViewState createState() => _CustomStoryViewState();
}

class _CustomStoryViewState extends State<CustomStoryView> {
  final _textController = TextEditingController();
  final _storyController = StoryController();
  final _store = CustomFireStore.instance;
  final _focus = FocusNode();

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

  getCurrentUserDetails(BuildContext context) {
    myName = FirebaseAuth.instance.currentUser!.displayName;
    myProfilePic = FirebaseAuth.instance.currentUser!.photoURL;
    myEmail = FirebaseAuth.instance.currentUser!.email;
    myUid = FirebaseAuth.instance.currentUser!.uid;
    chatRoomId = generatingChatRoomIdWithDisplayName(
      widget.modelsStatus.displayName.toString(),
      myName.toString(),
    );
  }

  @override
  void initState() {
    super.initState();
    getCurrentUserDetails(context);
  }

  @override
  void dispose() {
    super.dispose();
    _storyController.dispose();
  }

  void replyModal() {
    showModalBottomSheet(
      enableDrag: true,
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (_) => Container(
        height: 400,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: TextField(
          focusNode: _focus..canRequestFocus,
          autocorrect: true,
          controller: _textController,
          textInputAction: TextInputAction.done,
          maxLines: null,
          minLines: null,
          enabled: true,
          autofocus: true,
          style: TextStyle(
            color: Colors.white,
          ),
          decoration: InputDecoration(
            suffixIcon: IconButton(
              onPressed: () {
                if (FirebaseAuth.instance.currentUser!.uid ==
                    widget.modelsStatus.userId) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('You can\'t reply to yourself'),
                    ),
                  );
                } else {
                  if (_textController.text.isEmpty) {
                    return null;
                  } else {
                    _store
                        .sendPrivateMessage(
                      chatRoomId: chatRoomId.toString(),
                      messageBody: _textController.text,
                      time: DateTime.now(),
                      uid: myUid.toString(),
                      imageUrl: myProfilePic.toString(),
                    )
                        .then((value) {
                      _textController.clear();
                      _focus.unfocus();
                    });
                  }
                }
              },
              icon: Icon(Icons.send, color: Colors.white),
            ),
            hintText: 'Reply',
            labelText: 'Reply',
            labelStyle: TextStyle(
              color: Colors.white,
            ),
            hintStyle: TextStyle(
              color: Colors.white,
            ),
            border: InputBorder.none,
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                topRight: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
              borderSide: BorderSide(
                color: Colors.white,
                width: 2.0,
              ),
            ),
            enabled: true,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                topRight: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
              borderSide: BorderSide(
                color: Colors.white,
                width: 2.0,
              ),
            ),
            focusColor: Colors.white,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: StoryView(
                    repeat: false,
                    storyItems: widget.statusData
                        .map(
                          (e) => StoryItem.inlineImage(
                            imageFit: BoxFit.contain,
                            shown: true,
                            url: e['imageUrl'],
                            caption: Text(
                              e['caption'],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                backgroundColor: Colors.black.withOpacity(0.5),
                              ),
                            ),
                            controller: _storyController,
                          ),
                        )
                        .toList(),
                    controller: _storyController,
                    onComplete: () {
                      Navigator.pop(context);
                    },
                    onVerticalSwipeComplete: (val) {
                      if (val == Direction.down) {
                        Navigator.pop(context);
                      } else if (val == Direction.up) {
                        _storyController.pause();
                        return replyModal();
                      }
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 10),
                  width: double.infinity,
                  color: Colors.black,
                  child: Center(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      physics: AlwaysScrollableScrollPhysics(
                        parent: BouncingScrollPhysics(),
                      ),
                      child: Column(
                        children: [
                          Text(
                            '^',
                            style: TextStyle(color: Colors.white),
                          ),
                          Text(
                            'reply',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 20.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20.0,
                    backgroundColor: Colors.grey[300],
                    backgroundImage: NetworkImage(
                      widget.modelsStatus.photoUrl.toString(),
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  Expanded(
                    child: Text(
                      widget.modelsStatus.displayName.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
