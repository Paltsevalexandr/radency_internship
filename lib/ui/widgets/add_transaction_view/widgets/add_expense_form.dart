import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:radency_internship_project_2/blocs/transactions/add_transaction/add_transaction_bloc.dart';
import 'package:radency_internship_project_2/generated/l10n.dart';
import 'package:radency_internship_project_2/models/transactions/expense_transaction.dart';
import 'package:radency_internship_project_2/ui/widgets/add_transaction_view/widgets/stylized_elevated_button.dart';
import 'package:radency_internship_project_2/ui/widgets/add_transaction_view/widgets/test_modal_bottom_menu.dart';
import 'package:radency_internship_project_2/utils/date_formatters.dart';
import 'package:radency_internship_project_2/utils/strings.dart';
import 'package:radency_internship_project_2/utils/styles.dart';
import 'package:radency_internship_project_2/utils/ui_utils.dart';

class AddExpenseForm extends StatefulWidget {
  @override
  _AddExpenseFormState createState() => _AddExpenseFormState();
}

class _AddExpenseFormState extends State<AddExpenseForm> {
  static final GlobalKey<FormState> _addExpenseFormKey = GlobalKey<FormState>();

  DateTime _selectedDateTime;
  String _accountValue;
  String _categoryValue;
  double _amountValue;
  String _noteValue;

  TextEditingController _dateFieldController = TextEditingController();
  TextEditingController _accountFieldController = TextEditingController();
  TextEditingController _categoryFieldController = TextEditingController();
  TextEditingController _amountFieldController = TextEditingController();
  TextEditingController _noteFieldController = TextEditingController();

  final int _titleFlex = 3;
  final int _textFieldFlex = 7;
  final int _saveButtonFlex = 6;
  final int _continueButtonFlex = 4;

  @override
  void initState() {
    _selectedDateTime = DateTime.now();
    _clearFields();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddTransactionBloc, AddTransactionState>(
      listener: (context, state) {
        if (state is AddTransactionSuccessfulAndContinued) {
          _clearFields();
          showSnackBarMessage(context, S.current.addTransactionSnackBarSuccessMessage);
          FocusScope.of(context).unfocus();
        }

        if (state is AddTransactionSuccessfulAndCompleted) {
          showSnackBarMessage(context, S.current.addTransactionSnackBarSuccessMessage);
          Navigator.of(context).pop();
        }
      },
      builder: (context, state) {
        if (state is AddTransactionLoaded) return _addExpenseFormBody(state);

        return SizedBox();
      },
    );
  }

  Widget _addExpenseFormBody(AddTransactionLoaded state) {
    return Padding(
      padding: EdgeInsets.all(pixelsToDP(context, 16.0)),
      child: Form(
        key: _addExpenseFormKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _dateField(),
            _accountField(state.accounts),
            _categoryField(state.categories),
            _amountField(),
            _noteField(),
            _submitButtons(),
          ],
        ),
      ),
    );
  }

  Widget _dateField() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: _fieldTitleWidget(title: S.current.addTransactionDateFieldTitle),
          flex: _titleFlex,
        ),
        Flexible(
          flex: _textFieldFlex,
          child: TextFormField(
            controller: _dateFieldController,
            readOnly: true,
            showCursor: false,
            onTap: () async {
              await _selectNewDate();
            },
          ),
        )
      ],
    );
  }

  Widget _accountField(List<String> accounts) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: _fieldTitleWidget(title: S.current.addTransactionAccountFieldTitle),
          flex: _titleFlex,
        ),
        Flexible(
          flex: _textFieldFlex,
          child: TextFormField(
            controller: _accountFieldController,
            readOnly: true,
            showCursor: false,
            onTap: () async {
              _accountFieldController.text = await getValueFromTestModalBottomSheet(context: context, options: accounts, onAddCallback: null);
              setState(() {});
            },
            onSaved: (value) => _accountValue = value,
            validator: (val) {
              if (val.isEmpty) return S.current.addTransactionAccountFieldValidationEmpty;

              return null;
            },
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
          child: _fieldTitleWidget(title: S.current.addTransactionCategoryFieldTitle),
          flex: _titleFlex,
        ),
        Flexible(
          flex: _textFieldFlex,
          child: TextFormField(
            controller: _categoryFieldController,
            readOnly: true,
            showCursor: false,
            onTap: () async {
              _categoryFieldController.text = await getValueFromTestModalBottomSheet(context: context, options: categories, onAddCallback: null);
              setState(() {});
            },
            onSaved: (value) => _categoryValue = value,
            validator: (val) {
              if (val.isEmpty) return S.current.addTransactionCategoryFieldValidationEmpty;

              return null;
            },
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
          child: _fieldTitleWidget(title: S.current.addTransactionAmountFieldTitle),
          flex: _titleFlex,
        ),
        Flexible(
          flex: _textFieldFlex,
          child: TextFormField(
            controller: _amountFieldController,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(numberWithDecimalRegExp)),
            ],
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            validator: (val) {
              if (!RegExp(moneyAmountRegExp).hasMatch(val)) return S.current.addTransactionAmountFieldValidationEmpty;

              return null;
            },
            onSaved: (value) => _amountValue = double.tryParse(value),
          ),
        )
      ],
    );
  }

  Widget _noteField() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: _fieldTitleWidget(title: S.current.addTransactionNoteFieldTitle),
          flex: _titleFlex,
        ),
        Flexible(
          flex: _textFieldFlex,
          child: TextFormField(
            controller: _noteFieldController,
            onSaved: (value) => _noteValue = value,
          ),
        )
      ],
    );
  }

  Widget _submitButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(flex: _saveButtonFlex, child: _saveButton()),
        Expanded(flex: _continueButtonFlex, child: _continueButton()),
      ],
    );
  }

  Widget _saveButton() {
    return StylizedElevatedButton(
        child: Text(
          S.current.addTransactionButtonSave,
          style: addTransactionElevatedButtonTitleStyle(context, Colors.white),
        ),
        backgroundColor: Colors.orange,
        onPressed: () {
          _addExpenseFormKey.currentState.save();

          if (_addExpenseFormKey.currentState.validate()) {
            BlocProvider.of<AddTransactionBloc>(context).add(AddExpenseTransaction(
                isAddingCompleted: true,
                expenseTransaction: ExpenseTransaction(
                  note: _noteValue,
                  account: _accountValue,
                  dateTime: _selectedDateTime,
                  category: _categoryValue,
                  amount: _amountValue,
                )));
          }
        });
  }

  Widget _continueButton() {
    return StylizedElevatedButton(
        child: Text(
          S.current.addTransactionButtonContinue,
          style: addTransactionElevatedButtonTitleStyle(context, Colors.black),
        ),
        backgroundColor: Colors.white,
        borderColor: Colors.black,
        onPressed: () {
          _addExpenseFormKey.currentState.save();

          if (_addExpenseFormKey.currentState.validate()) {
            BlocProvider.of<AddTransactionBloc>(context).add(AddExpenseTransaction(
                isAddingCompleted: false,
                expenseTransaction: ExpenseTransaction(
                  note: _noteValue,
                  account: _accountValue,
                  dateTime: _selectedDateTime,
                  category: _categoryValue,
                  amount: _amountValue,
                )));
          }
        });
  }

  Widget _fieldTitleWidget({@required String title}) {
    return Text(
      title,
      style: addTransactionFormTitleTextStyle(context),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Future _selectNewDate() async {
    DateTime result = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(1960), lastDate: DateTime.now());
    if (result != null) {
      setState(() {
        _selectedDateTime = result;
        _dateFieldController.text = DateFormatters().dateToTransactionDateString(result);
      });
    }
  }

  void _clearFields() {
    setState(() {
      _selectedDateTime = DateTime.now();
      _dateFieldController.text = DateFormatters().dateToTransactionDateString(_selectedDateTime);

      _accountFieldController.text = '';
      _categoryFieldController.text = '';
      _amountFieldController.text = '';
      _noteFieldController.text = '';
    });
  }


}
