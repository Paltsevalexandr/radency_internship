import 'package:flutter/material.dart';
import 'package:radency_internship_project_2/utils/styles.dart';
import 'package:radency_internship_project_2/utils/ui_utils.dart';

// TODO: This is part of another ticket and should be changed. Test implementation.
Future<String> getValueFromTestModalBottomSheet({@required BuildContext context, @required List<String> options, @required onAddCallback}) async {
  return showModalBottomSheet(
    context: context,
    builder: (context) => Container(
      child: GridView.count(
          crossAxisCount: 3,
          childAspectRatio: 2,
          children: List.generate(
              options.length,
              (index) => modalMenuGridButton(
                  context: context,
                  title: options[index],
                  onPressed: () {
                    Navigator.pop(context, options[index]);
                  }))
            ..add(modalMenuGridButton(context: context, title: 'Add', onPressed: onAddCallback))),
    ),
  );
}

Widget modalMenuGridButton({@required BuildContext context, @required String title, @required Function onPressed}) {
  return Container(
    decoration: BoxDecoration(
      border: Border.all(
        color: Colors.black54,
        width: pixelsToDP(context, 0.3),
      ),
    ),
    child: TextButton(
      child: Text(
        title,
        style: addTransactionBottomModalSheetButtonsTextStyle(context),
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
        textAlign: TextAlign.center,
      ),
      onPressed: onPressed,
    ),
  );
}

