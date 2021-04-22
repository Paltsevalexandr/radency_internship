import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import '../../models/user.dart';
import '../../repositories/firebase_auth_repository/firebase_auth_repository.dart';

part 'user_profile_event.dart';
part 'user_profile_state.dart';

class UserProfileBloc extends Bloc<UserProfileEvent, UserProfileState> {
  UserProfileBloc({
    @required AuthenticationRepository authenticationRepository,
  })  : assert(authenticationRepository != null),
        _authenticationRepository = authenticationRepository,
        super(UserProfileState()) {
    _userSubscription = _authenticationRepository.userFromAnyChanges.listen(
      (user) => add(UserProfileEntityChanged(userEntity: user)),
    );
  }

  final AuthenticationRepository _authenticationRepository;
  StreamSubscription<UserEntity> _userSubscription;

  @override
  Future<void> close() {
    _userSubscription?.cancel();
    return super.close();
  }

  @override
  Stream<UserProfileState> mapEventToState(
    UserProfileEvent event,
  ) async* {
    if (event is UserProfileEntityChanged) yield* _mapUserProfileEntityChangedToState(user: event.userEntity);
  }

  Stream<UserProfileState> _mapUserProfileEntityChangedToState({@required UserEntity user}) async* {
    yield state.copyWith(userEntity: user);
  }
}
