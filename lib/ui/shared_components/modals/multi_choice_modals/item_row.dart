import 'package:flutter/material.dart';
import 'package:radency_internship_project_2/utils/ui_utils.dart';

class ItemRow extends StatelessWidget{
  final bool selected;
  final String title;
  final onTap;

  const ItemRow({Key key, this.selected, this.title, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.only(
        left: pixelsToDP(context, 90)
      ),
      selected: selected,
      leading: Icon(
        selected ? Icons.check_box : Icons.check_box_outline_blank,
        size: pixelsToDP(context, 100),
      ),
      title: Text(title),
      onTap: onTap,
    );
  }
}