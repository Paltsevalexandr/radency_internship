import 'dart:core';

import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:radency_internship_project_2/ui/shared_components/modals/account_modal.dart';
import 'package:radency_internship_project_2/ui/shared_components/modals/amount_modal.dart';
import 'package:radency_internship_project_2/ui/shared_components/modals/category_modal.dart';

enum ModalType { Account, Category, Amount }

Future<String> showModal({BuildContext context, @required ModalType type, List<String> values, onAddCallback, updateAmountCallback, String title}) async {
  // TODO: investigate
  var modal;
  switch (type) {
    case ModalType.Account:
      modal = AccountModal(
        onAddCallback: onAddCallback,
        accounts: values,
      );
      break;
    case ModalType.Category:
      modal = CategoryModal(
        onAddCallback: onAddCallback,
        categories: values,
      );
      break;
    case ModalType.Amount:
      modal = AmountModal(
        onUpdateCallback: updateAmountCallback,
        title: title,
      );
      break;
  }

  if (modal != null) {
    return showMaterialModalBottomSheet(
      barrierColor: Colors.transparent,
      expand: false,
      context: context,
      builder: (context) => modal,
    );
  }
}
