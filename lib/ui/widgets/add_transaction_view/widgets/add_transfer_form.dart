import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:radency_internship_project_2/blocs/transactions/add_transaction/add_transaction_bloc.dart';
import 'package:radency_internship_project_2/generated/l10n.dart';
import 'package:radency_internship_project_2/models/transactions/transfer_transaction.dart';
import 'package:radency_internship_project_2/ui/widgets/add_transaction_view/widgets/add_expense_form.dart';
import 'package:radency_internship_project_2/ui/widgets/add_transaction_view/widgets/stylized_elevated_button.dart';
import 'package:radency_internship_project_2/ui/widgets/add_transaction_view/widgets/show_modal.dart';
import 'package:radency_internship_project_2/utils/date_formatters.dart';
import 'package:radency_internship_project_2/utils/strings.dart';
import 'package:radency_internship_project_2/utils/styles.dart';
import 'package:radency_internship_project_2/utils/ui_utils.dart';

class AddTransferForm extends StatefulWidget {
  @override
  _AddTransferFormState createState() => _AddTransferFormState();
}

class _AddTransferFormState extends State<AddTransferForm> {
  static final GlobalKey<FormState> _addTransferFormKey = GlobalKey<FormState>();

  DateTime _selectedDateTime;
  String _fromValue;
  String _toValue;
  double _amountValue;
  double _feesValue;
  String _noteValue;

  TextEditingController _dateFieldController = TextEditingController();
  TextEditingController _fromFieldController = TextEditingController();
  TextEditingController _toFieldController = TextEditingController();
  TextEditingController _amountFieldController = TextEditingController();
  TextEditingController _feesFieldController = TextEditingController();
  TextEditingController _noteFieldController = TextEditingController();

  bool _areFeesVisible = false;

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
        if (state is AddTransactionLoaded) return _addTransferFormBody(state);

        return SizedBox();
      },
    );
  }

  Widget _addTransferFormBody(AddTransactionLoaded state) {
    return Padding(
      padding: EdgeInsets.all(pixelsToDP(context, 16.0)),
      child: Form(
        key: _addTransferFormKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _dateField(),
            _fromField(state.accounts),
            _toField(state.accounts),
            _amountField(),
            _feesField(),
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

  Widget _fromField(List<String> accounts) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: _fieldTitleWidget(title: S.current.addTransactionFromFieldTitle),
          flex: _titleFlex,
        ),
        Flexible(
          flex: _textFieldFlex,
          child: TextFormField(
            controller: _fromFieldController,
            readOnly: true,
            showCursor: false,
            onTap: () async {
              _fromFieldController.text = await showModal(context: context, type: ModalType.Account, values: accounts, onAddCallback: null);
              setState(() {});
            },
            onSaved: (value) => _fromValue = value,
            validator: (val) {
              if (val.isEmpty) return S.current.addTransactionAccountFieldValidationEmpty;

              return null;
            },
          ),
        )
      ],
    );
  }

  Widget _toField(List<String> accounts) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: _fieldTitleWidget(title: S.current.addTransactionToFieldTitle),
          flex: _titleFlex,
        ),
        Flexible(
          flex: _textFieldFlex,
          child: TextFormField(
            controller: _toFieldController,
            readOnly: true,
            showCursor: false,
            onTap: () async {
              _toFieldController.text = await showModal(context: context, values: accounts, type: ModalType.Account, onAddCallback: null);
              setState(() {});
            },
            onSaved: (value) => _toValue = value,
            validator: (val) {
              if (val.isEmpty) return S.current.addTransactionAccountFieldValidationEmpty;

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
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _amountFieldController,
                  readOnly: true,
                  showCursor: false,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(numberWithDecimalRegExp)),
                  ],
                  // keyboardType: TextInputType.numberWithOptions(decimal: true),
                  validator: (val) {
                    if (!RegExp(moneyAmountRegExp).hasMatch(val)) return S.current.addTransactionAmountFieldValidationEmpty;

                    return null;
                  },
                  onTap: () {
                    showModal(context: context, type: ModalType.Amount, updateAmountCallback: updateAmountCallback);
                  },
                  onSaved: (value) => _amountValue = double.tryParse(value) ?? 0,
                ),
              ),
              _feesButton(),
            ],
          ),
        )
      ],
    );
  }

  Widget _feesButton() {
    return StylizedElevatedButton(
      child: Text(
        S.current.addTransactionFeesFieldTitle,
        style: addTransactionElevatedButtonTitleStyle(context, _areFeesVisible ? Colors.red : Colors.black),
      ),
      backgroundColor: Colors.white,
      onPressed: () {
        _toggleFeesVisibility();
      },
      borderColor: _areFeesVisible ? Colors.red : Colors.black,
    );
  }

  Widget _feesField() {
    return Visibility(
      visible: _areFeesVisible,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: _fieldTitleWidget(title: S.current.addTransactionFeesFieldTitle),
            flex: _titleFlex,
          ),
          Flexible(
            flex: _textFieldFlex,
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _feesFieldController,
                    readOnly: true,
                    showCursor: false,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(numberWithDecimalRegExp)),
                    ],
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    validator: (val) {
                      if (!_areFeesVisible) return null;

                      if (!RegExp(moneyAmountRegExp).hasMatch(val)) return S.current.addTransactionAmountFieldValidationEmpty;

                      return null;
                    },
                    onTap: () {
                      showModal(context: context, type: ModalType.Amount, updateAmountCallback: updateFeeCallback, title: S.current.addTransactionFeesFieldTitle);
                    },
                    onSaved: (value) {
                      _areFeesVisible ? _feesValue = double.tryParse(value) ?? 0 : _feesValue = 0;
                    },
                  ),
                ),
              ],
            ),
          )
        ],
      ),
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
          _addTransferFormKey.currentState.save();

          if (_addTransferFormKey.currentState.validate()) {
            BlocProvider.of<AddTransactionBloc>(context).add(AddTransferTransaction(
                isAddingCompleted: true,
                transferTransaction: TransferTransaction(
                  from: _fromValue,
                  to: _toValue,
                  note: _noteValue,
                  fees: _feesValue,
                  dateTime: _selectedDateTime,
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
          _addTransferFormKey.currentState.save();

          if (_addTransferFormKey.currentState.validate()) {
            BlocProvider.of<AddTransactionBloc>(context).add(AddTransferTransaction(
                isAddingCompleted: false,
                transferTransaction: TransferTransaction(
                  note: _noteValue,
                  from: _fromValue,
                  dateTime: _selectedDateTime,
                  to: _toValue,
                  amount: _amountValue,
                  fees: _feesValue,
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

  void _toggleFeesVisibility() {
    _areFeesVisible = !_areFeesVisible;
    if (_areFeesVisible) {
      _feesFieldController.text = '';
    }
    setState(() {});
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

  void updateAmountCallback(var value) {
    String amount = getUpdatedAmount(_amountFieldController, value);
    setState(() {
      _amountFieldController.text = amount;
    });
  }

  void updateFeeCallback(var value) {
    String amount = getUpdatedAmount(_feesFieldController, value);
    setState(() {
      _feesFieldController.text = amount;
    });
  }

  void _clearFields() {
    setState(() {
      _selectedDateTime = DateTime.now();
      _dateFieldController.text = DateFormatters().dateToTransactionDateString(_selectedDateTime);

      _fromFieldController.text = '';
      _toFieldController.text = '';
      _amountFieldController.text = '';
      _noteFieldController.text = '';
      _areFeesVisible = false;
    });
  }
}
