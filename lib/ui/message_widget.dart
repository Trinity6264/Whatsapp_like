import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:project1/models/current_user_model.dart';

class MessageWidget extends StatelessWidget {
  final Message message;
  final bool isMe;
  const MessageWidget({Key? key, required this.message, required this.isMe})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final radius = Radius.circular(15);
    final borderRadius = BorderRadius.all(radius);
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        if (!isMe)
          CircleAvatar(
            radius: 16,
            backgroundImage:
                CachedNetworkImageProvider(message.profileLink.toString()),
          ),
        Container(
          padding: EdgeInsets.all(16),
          margin: EdgeInsets.all(16),
          constraints: BoxConstraints(maxWidth: 140),
          decoration: BoxDecoration(
            color: isMe ? Colors.grey[100] : Colors.greenAccent[100],
            borderRadius: isMe
                ? borderRadius.subtract(
                    BorderRadius.only(bottomRight: radius),
                  )
                : borderRadius.subtract(
                    BorderRadius.only(bottomLeft: radius),
                  ),
          ),
          child: buildMessage(),
        ),
      ],
    );
  }

  Widget buildMessage() => Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            message.message.toString(),
            style: TextStyle(color: isMe ? Colors.black : Colors.black),
            textAlign: isMe ? TextAlign.end : TextAlign.start,
          )
        ],
      );
}
