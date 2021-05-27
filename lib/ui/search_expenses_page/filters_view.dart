import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:radency_internship_project_2/blocs/accounts/account_bloc.dart';
import 'package:radency_internship_project_2/blocs/settings/category/category_bloc.dart';
import 'package:radency_internship_project_2/blocs/transactions/search_transactions/search_transactions_bloc.dart';
import 'package:radency_internship_project_2/generated/l10n.dart';
import 'package:radency_internship_project_2/ui/shared_components/elevated_buttons/colored_elevated_button.dart';
import 'package:radency_internship_project_2/ui/shared_components/field_title.dart';
import 'package:radency_internship_project_2/ui/shared_components/modals/multi_choice_modals/show_multi_choice_modal.dart';
import 'package:radency_internship_project_2/ui/shared_components/modals/single_choice_modals/show_single_choice_modal.dart';
import 'package:radency_internship_project_2/ui/widgets/add_transaction_view/widgets/add_expense_form.dart';
import 'package:radency_internship_project_2/utils/strings.dart';
import 'package:radency_internship_project_2/utils/styles.dart';
import 'package:radency_internship_project_2/utils/ui_utils.dart';

class FiltersView extends StatefulWidget{
  @override
  _FiltersViewState createState() => _FiltersViewState();
}

class _FiltersViewState extends State<FiltersView> {
  static final GlobalKey<FormState> _accountValueFormKey = GlobalKey<FormState>();
  static final GlobalKey<FormState> _categoryValueFormKey = GlobalKey<FormState>();
  static final GlobalKey<FormState> _minAmountValueFormKey = GlobalKey<FormState>();
  static final GlobalKey<FormState> _maxAmountValueFormKey = GlobalKey<FormState>();

  TextEditingController _accountFieldController = TextEditingController();
  TextEditingController _categoryFieldController = TextEditingController();
  TextEditingController _minAmountFieldController = TextEditingController();
  TextEditingController _maxAmountFieldController = TextEditingController();

  final int _titleFlex = 3;
  final int _textFieldFlex = 7;

  double _minAmountValue;
  double _maxAmountValue;

  @override
  void initState() {
    _accountFieldController.text = BlocProvider.of<AccountBloc>(context).state.appliedAccounts.join("; ");
    _categoryFieldController.text = BlocProvider.of<CategoryBloc>(context).state.appliedCategories.join("; ");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AccountBloc, AccountState>(
          listener: (context, accountState){
            _accountFieldController.text = accountState.appliedAccounts.join("; ");
          },
        ),
        BlocListener<CategoryBloc, CategoryState>(
          listener: (context, categoryState){
            _categoryFieldController.text = categoryState.appliedCategories.join("; ");
          },
        )
      ],
      child: Container(
        padding: EdgeInsets.only(
          top: pixelsToDP(context, 48),
          left: pixelsToDP(context, 48),
          right: pixelsToDP(context, 48),
        ),
        child: Column(
          children: [
            _accountField([]),
            _categoryField([]),
            _amountField(),
            SizedBox(
              height: pixelsToDP(context, 30),
            ),
            _applyButton(),
          ],
        ),
      ),
    );
  }

  Widget _accountField(List<String> accounts) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: buildFormFieldTitle(context, title: S.current.addTransactionAccountFieldTitle),
          flex: _titleFlex,
        ),
        Flexible(
          flex: _textFieldFlex,
          child: Form(
            key: _accountValueFormKey,
            child: TextFormField(
              decoration: addTransactionFormFieldDecoration(context),
              controller: _accountFieldController,
              readOnly: true,
              showCursor: false,
              onTap: () async {
                await showMultiChoiceModal(context: context, type: MultiChoiceModalType.Account);
              },
            ),
          ),
        )
      ],
    );
  }

  Widget _categoryField(List<String> categories) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: buildFormFieldTitle(context, title: S.current.addTransactionCategoryFieldTitle),
          flex: _titleFlex,
        ),
        Flexible(
          flex: _textFieldFlex,
          child: Form(
            key: _categoryValueFormKey,
            child: TextFormField(
              decoration: addTransactionFormFieldDecoration(context),
              controller: _categoryFieldController,
              readOnly: true,
              showCursor: false,
              onTap: () async {
                List list = await showMultiChoiceModal(context: context, type: MultiChoiceModalType.Category);
                _categoryFieldController.text = "";
              },
            ),
          ),
        )
      ],
    );
  }

  Widget _amountField() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: buildFormFieldTitle(context, title: S.current.addTransactionAmountFieldTitle),
          flex: _titleFlex,
        ),
        Flexible(
          flex: _textFieldFlex,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: Form(
                  key: _minAmountValueFormKey,
                  child: TextFormField(
                    textAlign: TextAlign.center,
                    decoration: addTransactionFormFieldDecoration(
                      context,
                      hintText: "Min"
                    ),
                    readOnly: true,
                    showCursor: true,
                    controller: _minAmountFieldController,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(numberWithDecimalRegExp)),
                    ],

                    onTap: () async {
                      await showSingleChoiceModal(context: context, type: SingleChoiceModalType.Amount, updateAmountCallback: updateMinAmountCallback, showSubcurrencies: false);
                    },
                    onSaved: (value) => _minAmountValue = double.tryParse(value),
                  ),
                ),
              ),
              Text(" ~ "),
              Expanded(
                child: Form(
                  key: _maxAmountValueFormKey,
                  child: TextFormField(
                    textAlign: TextAlign.center,
                    decoration: addTransactionFormFieldDecoration(
                      context,
                      hintText: "Max"
                    ),
                    readOnly: true,
                    showCursor: true,
                    controller: _maxAmountFieldController,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(numberWithDecimalRegExp)),
                    ],

                    onTap: () async {
                      await showSingleChoiceModal(context: context, type: SingleChoiceModalType.Amount, updateAmountCallback: updateMaxAmountCallback, showSubcurrencies: false);
                    },
                    onSaved: (value) => _maxAmountValue = double.tryParse(value),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _applyButton() {
    return ColoredElevatedButton(
      child: Text("Apply filters"),
      onPressed: (){
        _minAmountValueFormKey.currentState.save();
        _maxAmountValueFormKey.currentState.save();
        BlocProvider.of<SearchTransactionsBloc>(context).add(SearchTransactionsByFilters(
          minAmount: _minAmountValue,
          maxAmount: _maxAmountValue,
          accounts: BlocProvider.of<AccountBloc>(context).state.selectedAccounts,
          categories: BlocProvider.of<CategoryBloc>(context).state.selectedCategories,
        ));
      }
    );
  }

  void updateMinAmountCallback(var value) {
    String amount = getUpdatedAmount(_minAmountFieldController, value);
    setState(() {
      _minAmountFieldController.text = amount;
    });
  }

  void updateMaxAmountCallback(var value) {
    String amount = getUpdatedAmount(_maxAmountFieldController, value);
    setState(() {
      _maxAmountFieldController.text = amount;
    });
  }
}