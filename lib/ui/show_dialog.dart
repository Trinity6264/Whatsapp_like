import 'package:flutter/material.dart';

class ShowDialog extends StatelessWidget {
  const ShowDialog({Key? key, required this.imageUrl, required this.name})
      : super(key: key);
  final String imageUrl;
  final String name;

  void displaySnackBar(String name, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        elevation: 0.0,
        content: Text(name),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Column(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(
                  left: Constants.padding,
                  top: Constants.avatarRadius + Constants.padding + 80,
                  right: Constants.padding,
                  bottom: Constants.padding),
              margin: EdgeInsets.only(
                top: Constants.avatarRadius,
                left: Constants.avatarRadius - 10,
                right: Constants.avatarRadius - 10,
              ),
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(Constants.padding),
                ),
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
              child: Text(
                name,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28.0,
                  backgroundColor: Colors.black.withOpacity(0.6),
                ),
                textAlign: TextAlign.justify,
              ),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(),
              margin: EdgeInsets.only(
                left: Constants.avatarRadius - 10,
                right: Constants.avatarRadius - 10,
              ),
              color: Colors.white,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.message),
                  ),
                  IconButton(
                    onPressed: () {
                      displaySnackBar('Phone Icon pressed', context);
                    },
                    icon: Icon(Icons.phone),
                  ),
                  IconButton(
                    onPressed: () {
                      displaySnackBar('Videocam', context);
                    },
                    icon: Icon(Icons.videocam),
                  ),
                  IconButton(
                    onPressed: () {
                      displaySnackBar('Profile', context);
                    },
                    icon: Icon(Icons.blur_circular_rounded),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class Constants {
  Constants._();
  static const double padding = 20;
  static const double avatarRadius = 45;
}
