import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'transactions_summary_state.dart';

class TransactionsSummaryCubit extends Cubit<TransactionsSummaryState> {
  TransactionsSummaryCubit() : super(TransactionsSummaryInitial());


}
