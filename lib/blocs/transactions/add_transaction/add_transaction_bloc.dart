import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:radency_internship_project_2/blocs/transactions/add_transaction/temp_values.dart';
import 'package:radency_internship_project_2/models/transactions/expense_transaction.dart';
import 'package:radency_internship_project_2/models/transactions/transfer_transaction.dart';

part 'add_transaction_event.dart';

part 'add_transaction_state.dart';

class AddTransactionBloc extends Bloc<AddTransactionEvent, AddTransactionState> {
  AddTransactionBloc() : super(AddTransactionInitial());

  @override
  Stream<AddTransactionState> mapEventToState(
    AddTransactionEvent event,
  ) async* {
    if (event is AddTransactionInitialize) {
      yield* _mapAddTransactionInitializeToState();
    } else if (event is AddExpenseTransaction) {
      yield* _mapAddExpenseTransactionToState(event.expenseTransaction, event.isAddingCompleted);
    } else if (event is AddTransferTransaction) yield* _mapAddTransferTransactionToState(event.transferTransaction, event.isAddingCompleted);
  }

  Stream<AddTransactionState> _mapAddTransactionInitializeToState() async* {
    // TODO: fetch categories, accounts, etc.

    yield AddTransactionLoaded(categories: TempAddTransactionValues().categories, accounts: TempAddTransactionValues().accounts);
  }

  Stream<AddTransactionState> _mapAddExpenseTransactionToState(ExpenseTransaction expenseTransaction, bool isAddingCompleted) async* {
    yield AddTransactionLoaded(
      categories: TempAddTransactionValues().categories,
      accounts: TempAddTransactionValues().accounts,
    );

    //TODO: implement endpoint

    if (isAddingCompleted) {
      yield AddTransactionSuccessfulAndCompleted();
    } else {
      yield (AddTransactionSuccessfulAndContinued());
    }

    yield AddTransactionLoaded(categories: TempAddTransactionValues().categories, accounts: TempAddTransactionValues().accounts);
  }

  Stream<AddTransactionState> _mapAddTransferTransactionToState(TransferTransaction transferTransaction, bool isAddingCompleted) async* {
    yield AddTransactionLoaded(
      categories: TempAddTransactionValues().categories,
      accounts: TempAddTransactionValues().accounts,
    );

    //TODO: implement endpoint

    if (isAddingCompleted) {
      yield AddTransactionSuccessfulAndCompleted();
    } else {
      yield (AddTransactionSuccessfulAndContinued());
    }

    yield AddTransactionLoaded(categories: TempAddTransactionValues().categories, accounts: TempAddTransactionValues().accounts);
  }
}
