import 'package:flutter/material.dart';
import 'package:radency_internship_project_2/generated/l10n.dart';
import 'package:radency_internship_project_2/ui/shared_components/modals/base_modal.dart';
import 'package:radency_internship_project_2/utils/ui_utils.dart';

class CategoryModal extends StatelessWidget{
  final List<String> categories;
  final onAddCallback;

  const CategoryModal({Key key, this.categories, this.onAddCallback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> contents = categories.map((element) => TextButton(
      onPressed: (){
        Navigator.of(context).pop(element);
      },
      child: Text(
        element,
        textAlign: TextAlign.center,
      )
    )).toList()
      + [
        TextButton(
          onPressed: onAddCallback,
          child: Text(S.current.addTransactionButtonAdd)
        )
      ];

    return BaseModal(
      title: S.current.addTransactionCategoryFieldTitle,
      contents: contents,
      actions: [
        IconButton(
          icon: Icon(Icons.edit_outlined),
          onPressed: (){},
          color: Colors.white,
          iconSize: pixelsToDP(context, 90),
        ),
      ],
    );
  }
}
