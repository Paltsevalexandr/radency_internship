import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../models/user.dart';
import '../../repositories/firebase_auth_repository/firebase_auth_repository.dart';
import 'package:meta/meta.dart';

part 'user_profile_state.dart';

class UserProfileCubit extends Cubit<UserProfileState> {
  UserProfileCubit({
    @required AuthenticationRepository authenticationRepository,
  })  : assert(authenticationRepository != null),
        _authenticationRepository = authenticationRepository,
        super(UserProfileState()) {
    _userSubscription = _authenticationRepository.userFromAnyChanges.listen(
      (user) => emit(state.copyWith(userEntity: user)),
    );
  }

  final AuthenticationRepository _authenticationRepository;
  StreamSubscription<UserEntity> _userSubscription;

  @override
  Future<void> close() {
    _userSubscription?.cancel();
    return super.close();
  }
}
