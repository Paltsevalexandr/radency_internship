part of 'email_login_bloc.dart';

class EmailLoginState extends Equatable {
  EmailLoginState({this.areDetailsProcessing = false, this.errorMessage});

  final bool areDetailsProcessing;
  final String errorMessage;

  @override
  List<Object> get props => [areDetailsProcessing, errorMessage];

  EmailLoginState setDetailsProcessing() {
    return copyWith(areDetailsProcessing: true);
  }

  EmailLoginState showError({@required String errorMessage}) {
    return copyWith(areDetailsProcessing: false, errorMessage: errorMessage);
  }

  EmailLoginState copyWith({bool areDetailsProcessing, String errorMessage}) {
    return EmailLoginState(
      areDetailsProcessing: areDetailsProcessing ?? this.areDetailsProcessing,
      errorMessage: errorMessage ?? null,
    );
  }
}
