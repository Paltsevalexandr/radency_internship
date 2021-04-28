import 'package:flutter/material.dart' hide ReorderableList;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:radency_internship_project_2/blocs/settings/category/category_bloc.dart';
import 'package:radency_internship_project_2/generated/l10n.dart';
import 'package:radency_internship_project_2/ui/bottom_nav_bar/bottom_nav_bar.dart';
import 'package:radency_internship_project_2/utils/ui_utils.dart';

import 'category_page_common.dart';

class NewCategoryPageArguments {
  final String categoriesType;

  NewCategoryPageArguments(this.categoriesType);
}

class NewCategoryPage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => NewCategoryPage());
  }

  var newCategoryName = "";

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryBloc, CategoryState>(builder: (context, state) {
      final NewCategoryPageArguments args =
          ModalRoute.of(context).settings.arguments as NewCategoryPageArguments;
      final categoriesType = args.categoriesType;
      List<CategoryItemData> categoryItems;

      int nextItemId;

      if (categoriesType == incomeList) {
        categoryItems = state.incomeCategories;
        nextItemId = state.nextIncomeCategoryId;
      } else {
        categoryItems = state.expensesCategories;
        nextItemId = state.nextExpenseCategoryId;
      }

      return Scaffold(
          appBar: AppBar(title: Text(S.current.newCategory)),
          body: Column(
            children: [
              Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: pixelsToDP(context, 24.0),
                      horizontal: pixelsToDP(context, 12.0)),
                  child: buildCategoryEditText(context)),
              ElevatedButton(
                onPressed: () {
                  if (newCategoryName.isNotEmpty) {
                    print(nextItemId.toString());
                    categoryItems.add(CategoryItemData(
                        newCategoryName, ValueKey(nextItemId)));

                    context.read<CategoryBloc>().add(ChangeCategory(
                        listSettingValue: categoryItems,
                        settingName: categoriesType));

                    context.read<CategoryBloc>().add(ChangeCategoryCounter(
                        settingValue: nextItemId + 1,
                        settingName: categoriesType));

                    Navigator.of(context).pop();
                  }
                },
                child: Text(S.current.save),
              )
            ],
          ),
          bottomNavigationBar: BottomNavBar(4));
    });
  }

  Widget buildCategoryEditText(context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: pixelsToDP(context, 32)),
      child: TextFormField(
        decoration: InputDecoration(
            labelText: S.current.categoryName,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(5))),
        onChanged: (value) => newCategoryName = value,
      ),
    );
  }
}
