import 'dart:io';

import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:radency_internship_project_2/blocs/settings/settings_bloc.dart';
import 'package:radency_internship_project_2/blocs/transactions/add_transaction/add_transaction_bloc.dart';
import 'package:radency_internship_project_2/blocs/transactions/add_transaction/transaction_location/transaction_location_bloc.dart';
import 'package:radency_internship_project_2/blocs/transactions/add_transaction/transaction_location_map/transaction_location_map_bloc.dart';
import 'package:radency_internship_project_2/generated/l10n.dart';
import 'package:radency_internship_project_2/models/location.dart';
import 'package:radency_internship_project_2/models/transactions/expense_transaction.dart';
import 'package:radency_internship_project_2/ui/shared_components/elevated_buttons/colored_elevated_button.dart';
import 'package:radency_internship_project_2/ui/shared_components/field_title.dart';
import 'package:radency_internship_project_2/ui/shared_components/modals/single_choice_modals/amount_modal.dart';
import 'package:radency_internship_project_2/ui/shared_components/elevated_buttons/stylized_elevated_button.dart';
import 'package:radency_internship_project_2/ui/shared_components/modals/single_choice_modals/amount_modal.dart';
import 'package:radency_internship_project_2/ui/shared_components/modals/single_choice_modals/show_single_choice_modal.dart';
import 'package:radency_internship_project_2/utils/date_formatters.dart';
import 'package:radency_internship_project_2/utils/routes.dart';
import 'package:radency_internship_project_2/utils/strings.dart';
import 'package:radency_internship_project_2/utils/styles.dart';
import 'package:radency_internship_project_2/utils/ui_utils.dart';

class AddExpenseForm extends StatefulWidget {
  @override
  _AddExpenseFormState createState() => _AddExpenseFormState();
}

class _AddExpenseFormState extends State<AddExpenseForm> {
  static final GlobalKey<FormState> _accountValueFormKey = GlobalKey<FormState>();
  static final GlobalKey<FormState> _categoryValueFormKey = GlobalKey<FormState>();
  static final GlobalKey<FormState> _amountValueFormKey = GlobalKey<FormState>();
  static final GlobalKey<FormState> _noteValueFormKey = GlobalKey<FormState>();

  DateTime _selectedDateTime;
  String _accountValue;
  String _categoryValue;
  double _amountValue;
  String _noteValue;
  ExpenseLocation _locationValue;
  Contact _sharedContact;

  TextEditingController _dateFieldController = TextEditingController();
  TextEditingController _accountFieldController = TextEditingController();
  TextEditingController _categoryFieldController = TextEditingController();
  TextEditingController _amountFieldController = TextEditingController();
  TextEditingController _noteFieldController = TextEditingController();
  TextEditingController _sharedFieldController = TextEditingController();
  TextEditingController _locationFieldController = TextEditingController();

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
        if (state is AddTransactionLoaded) {
          return _addExpenseFormBody(state);
        }

        return SizedBox();
      },
    );
  }

  Widget _addExpenseFormBody(AddTransactionLoaded state) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _dateField(),
          _accountField(state.accounts),
          _categoryField(state.expenseCategories),
          _amountField(),
          _noteField(),
          _sharedWithField(),
          _locationField(context),
          SizedBox(
            height: pixelsToDP(context, 30),
          ),
          _submitButtons(),
        ],
      ),
    );
  }

  Widget _dateField() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: buildFormFieldTitle(context, title: S.current.addTransactionDateFieldTitle),
          flex: _titleFlex,
        ),
        Flexible(
          flex: _textFieldFlex,
          child: TextFormField(
            decoration: addTransactionFormFieldDecoration(),
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
          child: buildFormFieldTitle(context, title: S.current.addTransactionAccountFieldTitle),
          flex: _titleFlex,
        ),
        Flexible(
          flex: _textFieldFlex,
          child: Form(
            key: _accountValueFormKey,
            child: TextFormField(
              decoration: addTransactionFormFieldDecoration(),
              controller: _accountFieldController,
              readOnly: true,
              showCursor: false,
              onTap: () async {
                _accountFieldController.text = await showSingleChoiceModal(context: context, values: accounts, type: SingleChoiceModalType.Account, onAddCallback: null);
                setState(() {
                  _accountValueFormKey.currentState.validate();
                });
              },
              onSaved: (value) => _accountValue = value,
              validator: (val) {
                if (val.isEmpty) {
                  return S.current.addTransactionAccountFieldValidationEmpty;
                }

                return null;
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
              decoration: addTransactionFormFieldDecoration(),
              controller: _categoryFieldController,
              readOnly: true,
              showCursor: false,
              onTap: () async {
                _categoryFieldController.text = await showSingleChoiceModal(context: context, values: categories, type: SingleChoiceModalType.Category, onAddCallback: null);
                setState(() {
                  _categoryValueFormKey.currentState.validate();
                });
              },
              onSaved: (value) => _categoryValue = value,
              validator: (val) {
                if (val.isEmpty) {
                  return S.current.addTransactionCategoryFieldValidationEmpty;
                }

                return null;
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
          child: Form(
            key: _amountValueFormKey,
            child: TextFormField(
              decoration: addTransactionFormFieldDecoration(),
              readOnly: true,
              showCursor: true,
              controller: _amountFieldController,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(numberWithDecimalRegExp)),
              ],
              validator: (val) {
                if (!RegExp(moneyAmountRegExp).hasMatch(val)) {
                  return S.current.addTransactionAmountFieldValidationEmpty;
                }

                return null;
              },
              onTap: () async {
                await showSingleChoiceModal(context: context, type: SingleChoiceModalType.Amount, updateAmountCallback: updateAmountCallback);
                setState(() {
                  _amountValueFormKey.currentState.validate();
                });
              },
              onSaved: (value) => _amountValue = double.tryParse(value),
            ),
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
          child: buildFormFieldTitle(context, title: S.current.addTransactionNoteFieldTitle),
          flex: _titleFlex,
        ),
        Flexible(
          flex: _textFieldFlex,
          child: Form(
            key: _noteValueFormKey,
            child: TextFormField(
              decoration: addTransactionFormFieldDecoration(),
              controller: _noteFieldController,
              onSaved: (value) => _noteValue = value,
            ),
          ),
        )
      ],
    );
  }

  Widget _sharedWithField() {
    ImageProvider _photoProvider;
    try {
      _photoProvider = MemoryImage(_sharedContact.avatar);
    } catch (_) {}

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: buildFormFieldTitle(context, title: S.current.addTransactionSharedFieldTitle),
          flex: _titleFlex,
        ),
        Flexible(
          flex: _textFieldFlex,
          child: Row(
            children: [
              Flexible(
                child: TextFormField(
                  controller: _sharedFieldController,
                  decoration: InputDecoration(
                    helperText: '',
                    prefixIcon: _sharedContact != null
                        ? Container(
                            margin: EdgeInsets.only(
                              top: pixelsToDP(context, 3),
                              right: pixelsToDP(context, 45),
                              bottom: pixelsToDP(context, 3),
                              left: pixelsToDP(context, 5),
                            ),
                            child: CircleAvatar(
                              foregroundImage: _photoProvider,
                              child: FittedBox(
                                child: Container(
                                  padding: EdgeInsets.all(pixelsToDP(context, 20)),
                                  child: Text(
                                    getContactInitials(_sharedContact),
                                    style: addTransactionAvatarTextStyle,
                                  ),
                                ),
                              ),
                            ),
                          )
                        : null,
                  ),
                  onTap: _selectSharedContact,
                  readOnly: true,
                ),
              ),
              Visibility(
                visible: _sharedContact != null,
                child: IconButton(
                  icon: Icon(Icons.close),
                  onPressed: _cancelSelectContact,
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  Widget _locationField(BuildContext _context) {
    return BlocProvider(
      create: (_context) => TransactionLocationBloc(),
      child: BlocBuilder<SettingsBloc, SettingsState>(builder: (_context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: buildFormFieldTitle(_context, title: S.current.addTransactionLocationFieldTitle),
              flex: _titleFlex,
            ),
            Flexible(
              flex: _textFieldFlex,
              child: TextFormField(
                controller: _locationFieldController,
                decoration: InputDecoration(hintText: S.current.addTransactionLocationFieldHint, helperText: ''),
                readOnly: true,
                showCursor: false,
                onTap: () async {
                  String languageCode = 'en';

                  if (state is SettingsState) {
                    // TODO: get correct locale code when implemented
                  }

                  BlocProvider.of<TransactionLocationBloc>(_context).add(TransactionLocationMenuOpened());
                  await _selectLocation(
                      context: _context, languageCode: languageCode, isLocationSelected: _locationValue != null);
                },
              ),
            )
          ],
        );
      }),
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
    return BlocBuilder<SettingsBloc, SettingsState>(builder: (context, state) {
      return ColoredElevatedButton(
          child: Text(
            S.current.addTransactionButtonSave,
          ),
          onPressed: () {
            _saveForms();

            if (_validateForms()) {
              BlocProvider.of<AddTransactionBloc>(context).add(AddTransaction(
                  isAddingCompleted: true,
                  transaction: ExpenseTransaction(
                    currency: state.currency,
                    note: _noteValue,
                    accountOrigin: _accountValue,
                    dateTime: _selectedDateTime,
                    category: _categoryValue,
                    amount: _amountValue,
                    sharedContact: _sharedContact,
                  )));
            }
          });
    });
  }

  Widget _continueButton() {
    return BlocBuilder<SettingsBloc, SettingsState>(builder: (context, state) {
      return StylizedElevatedButton(
          child: Text(
            S.current.addTransactionButtonContinue,
          ),
          onPressed: () {
            _saveForms();

            if (_validateForms()) {
              BlocProvider.of<AddTransactionBloc>(context).add(AddTransaction(
                  isAddingCompleted: false,
                  transaction: ExpenseTransaction(
                    note: _noteValue,
                    accountOrigin: _accountValue,
                    dateTime: _selectedDateTime,
                    category: _categoryValue,
                    amount: _amountValue,
                    sharedContact: _sharedContact,
                    currency: state.currency
                  )));
            }
          });
    });
  }

  Future _selectNewDate() async {
    DateTime result = await showDatePicker(
        context: context, initialDate: DateTime.now(), firstDate: DateTime(1960), lastDate: DateTime.now());
    if (result != null) {
      setState(() {
        _selectedDateTime = result;
        _dateFieldController.text = DateFormatters().dateToTransactionDateString(result);
      });
    }
  }

  Future _selectSharedContact() async {
    final Contact contact = await ContactsService.openDeviceContactPicker();
    if (Platform.isAndroid) {
      contact.avatar = await ContactsService.getAvatar(contact);
    }
    if (contact != null) {
      setState(() {
        _sharedContact = contact;
        _sharedFieldController.text = contact.displayName;
      });
    }
  }

  void _cancelSelectContact() {
    setState(() {
      _sharedContact = null;
      _sharedFieldController.text = "";
    });
  }

  void updateAmountCallback(var value) {
    String amount = getUpdatedAmount(_amountFieldController, value);
    setState(() {
      _amountFieldController.text = amount;
    });
  }

  void _clearFields() {
    setState(() {
      _selectedDateTime = DateTime.now();
      _dateFieldController.text = DateFormatters().dateToTransactionDateString(_selectedDateTime);

      _locationValue = null;
      _locationFieldController.text = '';

      _accountFieldController.text = '';
      _categoryFieldController.text = '';
      _amountFieldController.text = '';
      _noteFieldController.text = '';

      _sharedContact = null;
    });
  }

  Future _selectLocation(
      {@required BuildContext context, @required String languageCode, @required bool isLocationSelected}) async {
    ExpenseLocation _newLocation;

    _newLocation = await _getLocationFromModalBottomSheet(
        xContext: context, languageCode: languageCode, isLocationSelected: isLocationSelected);

    if (_newLocation == null) {
      _locationValue = null;
      _locationFieldController.text = '';
      showSnackBarMessage(context, S.current.addTransactionSnackBarLocationSelectCancelled);
    } else {
      _locationValue = _newLocation;
      _locationFieldController.text = _locationValue.address;
    }
  }

  Future<ExpenseLocation> _getLocationFromModalBottomSheet(
      {@required BuildContext xContext, @required String languageCode, @required bool isLocationSelected}) {
    final transactionLocationBloc = BlocProvider.of<TransactionLocationBloc>(xContext);

    return showModalBottomSheet(
      context: xContext,
      builder: (context) => BlocConsumer<TransactionLocationBloc, TransactionLocationState>(
          bloc: transactionLocationBloc,
          listener: (context, state) async {
            if (state is TransactionLocationSelected) {
              if (state.expenseLocation == null)
                Navigator.pop(context, null);
              else
                Navigator.pop(context, state.expenseLocation);
            }
          },
          builder: (context, state) {
            return Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _locationMenuItem(
                    leading: Icon(Icons.my_location),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(S.current.addTransactionLocationMenuCurrent),
                        if (state is TransactionLocationCurrentLoading) CircularProgressIndicator(),
                      ],
                    ),
                    onSelect: () async {
                      xContext
                          .read<TransactionLocationBloc>()
                          .add(TransactionLocationCurrentPressed(languageCode: languageCode));
                    },
                  ),
                  _locationMenuItem(
                    leading: Icon(Icons.location_pin),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(S.current.addTransactionLocationMenuFromMap),
                        if (state is TransactionLocationFromMapLoading) CircularProgressIndicator(),
                      ],
                    ),
                    onSelect: () async {
                      context.read<TransactionLocationMapBloc>().add(TransactionLocationMapInitialize());
                      var latLng = await Navigator.of(context).pushNamed(Routes.transactionLocationSelectView);
                      xContext
                          .read<TransactionLocationBloc>()
                          .add(TransactionLocationFromMapPressed(languageCode: languageCode, latLng: latLng as LatLng));
                    },
                  ),
                  if (isLocationSelected)
                    _locationMenuItem(
                      leading: Icon(Icons.cancel),
                      title: Text(S.current.addTransactionLocationMenuCancel),
                      onSelect: () {
                        xContext.read<TransactionLocationBloc>().add(TransactionLocationCancelSelected());
                      },
                    )
                ],
              ),
            );
          }),
    );
  }

  Widget _locationMenuItem({@required Widget leading, @required Widget title, @required Function onSelect}) {
    return GestureDetector(
      child: ListTile(
        leading: leading,
        title: title,
      ),
      onTap: onSelect,
    );
  }

  void _saveForms() {
    _accountValueFormKey.currentState.save();
    _categoryValueFormKey.currentState.save();
    _amountValueFormKey.currentState.save();
    _noteValueFormKey.currentState.save();
  }

  bool _validateForms() {
    bool result = true;

    if (!_accountValueFormKey.currentState.validate()) {
      result = false;
    }
    if (!_categoryValueFormKey.currentState.validate()) {
      result = false;
    }
    if (!_amountValueFormKey.currentState.validate()) {
      result = false;
    }
    if (!_noteValueFormKey.currentState.validate()) {
      result = false;
    }

    return result;
  }
}

String getUpdatedAmount(TextEditingController controller, var value) {
  String amount = (controller.text ?? "").toString();

  if (value == CalculatorButton.Back && amount.length > 0) {
    amount = amount.substring(0, amount.length - 1);
  }
  if (RegExp(moneyAmountEditRegExp).hasMatch(amount + value.toString())) {
    amount = amount + value.toString();
  }

  return amount;
}

String getContactInitials(Contact contact) {
  String lastName = contact.familyName ?? "";
  return contact.displayName.trim()[0] + (lastName != "" ? lastName[0] : "");
}
