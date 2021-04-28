import 'package:flutter/material.dart';
import 'package:radency_internship_project_2/generated/l10n.dart';
import 'package:radency_internship_project_2/ui/widgets/add_transaction_view/modals/base_modal.dart';
import 'package:radency_internship_project_2/utils/ui_utils.dart';

class AmountModal extends StatelessWidget{
  final onUpdateCallback;
  final title;

  const AmountModal({Key key, this.onUpdateCallback, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> contents = _buttonLabels.map((element) {
      if(element != null) {
        return TextButton(
          onPressed: (){
            return onPressed(context, element);
          },
          child: element is String ? Text(
            element,
            style: TextStyle(
              fontSize: pixelsToDP(context, 60),
              color: element == "OK" ? Colors.red : null
            ),
          ) : element,
        );
      }

      return null;
    }).toList();

    return BaseModal(
      title: title ?? S.current.addTransactionAmountFieldTitle,
      contents: contents,
      crossAxisCount: 4,
      mainAxisCount: 5,
      actions: [
        IconButton(
          icon: Icon(Icons.panorama_photosphere),
          onPressed: (){},
          color: Colors.white,
          iconSize: pixelsToDP(context, 90),
        ),
      ],
    );
  }

  String onPressed(BuildContext context, var title) {
    switch(title.runtimeType){
      case String:
        if (title == "OK"){
          Navigator.of(context).pop();
          break;
        }
        onUpdateCallback(title);
        break;
      case Icon:
        onUpdateCallback(CalculatorButton.Back);
        break;
    }
  }
}

enum CalculatorButton{Back}

final _buttonLabels = [
  "\u00F7",
  "x",
  "–",
  "+",
  "7",
  "8",
  "9",
  "=",
  "4",
  "5",
  "6",
  ".",
  "1",
  "2",
  "3",
  Icon(Icons.backspace_outlined),
  null,
  "0",
  null,
  "OK",
];