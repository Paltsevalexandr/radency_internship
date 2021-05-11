part of 'sign_up_email_bloc.dart';

class SignUpEmailState extends Equatable {
  SignUpEmailState({this.areDetailsProcessing = false, this.errorMessage});

  final bool areDetailsProcessing;
  final String errorMessage;

  @override
  List<Object> get props => [areDetailsProcessing, errorMessage];

  SignUpEmailState setDetailsProcessing() {
    return copyWith(areDetailsProcessing: true);
  }

  SignUpEmailState showError({@required String errorMessage}) {
    return copyWith(areDetailsProcessing: false, errorMessage: errorMessage);
  }

  SignUpEmailState copyWith({bool areDetailsProcessing, String errorMessage}) {
    return SignUpEmailState(
      areDetailsProcessing: areDetailsProcessing ?? this.areDetailsProcessing,
      errorMessage: errorMessage ?? null,
    );
  }
}
