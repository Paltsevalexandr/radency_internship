import 'package:flutter/material.dart';
import 'package:radency_internship_project_2/generated/l10n.dart';
import 'package:radency_internship_project_2/ui/widgets/add_transaction_view/modals/base_modal.dart';
import 'package:radency_internship_project_2/utils/ui_utils.dart';

class AccountModal extends StatelessWidget{
  final List<String> accounts;
  final onAddCallback;

  const AccountModal({Key key, this.accounts, this.onAddCallback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> contents = accounts.map((element) => TextButton(
      onPressed: (){
        Navigator.of(context).pop(element);
      },
      child: Text(element)
    )).toList()
      + [
        TextButton(
          onPressed: onAddCallback,
          child: Text(S.current.addTransactionButtonAdd)
        )
      ];

    return BaseModal(
      title: S.current.transactionsTabTitleAccount,
      contents: contents,
      actions: [
        IconButton(
          icon: Icon(Icons.copy),
          onPressed: (){},
          color: Colors.white,
          iconSize: pixelsToDP(context, 90),
        ),
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
