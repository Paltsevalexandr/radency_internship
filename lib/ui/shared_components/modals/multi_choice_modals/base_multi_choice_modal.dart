import 'package:flutter/material.dart';
import 'package:radency_internship_project_2/generated/l10n.dart';
import 'package:radency_internship_project_2/utils/styles.dart';
import 'package:radency_internship_project_2/utils/ui_utils.dart';

class BaseMultiChoiceModal extends StatelessWidget{
  final String title;
  final Widget child;
  final onOKCallback;
  final onCancelCallback;

  const BaseMultiChoiceModal({Key key, this.title, this.child, this.onOKCallback, this.onCancelCallback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: pixelsToDP(context, 90),
        bottom: pixelsToDP(context, 60),
        left: pixelsToDP(context, 45),
        right: pixelsToDP(context, 45),
      ),
      child: Column(
        // mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(pixelsToDP(context, 20)),
                color: Colors.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: EdgeInsets.only(
                      top: pixelsToDP(context, 60),
                      bottom: pixelsToDP(context, 20),
                      left: pixelsToDP(context, 90),
                    ),
                    child: Text(
                      title,
                      style: searchModalTitleStyle(context),
                    ),
                  ),
                  Divider(
                    thickness: 1.1,
                  ),
                  Expanded(
                    child: child
                  ),
                ],
              )
            ),
          ),
          SizedBox(
            height: pixelsToDP(context, 30),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(pixelsToDP(context, 20)),
              color: Colors.white,
            ),
            child: IntrinsicHeight(
              child: Row(
                children: [
                  Expanded(
                    child: TextButton(
                      child: Text(
                        S.current.cancel,
                        style: buttonTitleStyle(context),
                      ),
                      onPressed: onCancelCallback,
                    )
                  ),
                  VerticalDivider(),
                  Expanded(
                    child: TextButton(
                      child: Text(
                        "OK",
                        style: buttonTitleStyle(context, Theme.of(context).accentColor)
                      ),
                      onPressed: onOKCallback,
                    )
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}