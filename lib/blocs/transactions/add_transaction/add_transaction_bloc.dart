import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:radency_internship_project_2/blocs/transactions/add_transaction/temp_values.dart';
import 'package:radency_internship_project_2/models/transactions/transaction.dart';

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
    } else if (event is AddTransaction) {
      yield* _mapAddTransactionToState(event.transaction, event.isAddingCompleted);
    }
  }

  Stream<AddTransactionState> _mapAddTransactionInitializeToState() async* {
    // TODO: fetch categories, accounts, etc.

    yield AddTransactionLoaded(
      incomeCategories: TempAddTransactionValues().incomeCategories,
      expenseCategories: TempAddTransactionValues().expenseCategories,
      accounts: TempAddTransactionValues().accounts
    );
  }

  Stream<AddTransactionState> _mapAddTransactionToState(Transaction transaction, bool isAddingCompleted) async* {
    yield AddTransactionLoaded(
      incomeCategories: TempAddTransactionValues().incomeCategories,
      expenseCategories: TempAddTransactionValues().expenseCategories,
      accounts: TempAddTransactionValues().accounts,
    );

    //TODO: implement endpoint

    if (isAddingCompleted) {
      yield AddTransactionSuccessfulAndCompleted();
    } else {
      yield (AddTransactionSuccessfulAndContinued());
    }

    yield AddTransactionLoaded(
      incomeCategories: TempAddTransactionValues().incomeCategories,
      expenseCategories: TempAddTransactionValues().expenseCategories,
      accounts: TempAddTransactionValues().accounts
    );
  }
}
