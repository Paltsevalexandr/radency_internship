import 'package:flutter/material.dart';
import 'package:radency_internship_project_2/utils/ui_utils.dart';

const _avatarSize = 48.0;

class Avatar extends StatelessWidget {
  const Avatar({Key key, this.photo}) : super(key: key);

  final String photo;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: pixelsToDP(context, _avatarSize),
      backgroundImage: photo != null ? NetworkImage(photo) : null,
      child: photo == null
          ? Icon(Icons.person_outline, size: pixelsToDP(context, _avatarSize))
          : null,
    );
  }
}