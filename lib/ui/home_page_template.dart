import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:radency_internship_project_2/blocs/authentication/authentication_bloc.dart';
import 'package:radency_internship_project_2/blocs/user_profile/user_profile_cubit.dart';
import 'package:radency_internship_project_2/ui/widgets/avatar.dart';


class HomePage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => HomePage());
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: <Widget>[
          IconButton(
            key: const Key('homePage_logout_iconButton'),
            icon: const Icon(Icons.exit_to_app),
            onPressed: () => context
                .read<AuthenticationBloc>()
                .add(AuthenticationLogoutRequested()),
          )
        ],
      ),
      body: BlocBuilder<UserProfileCubit, UserProfileState>(
        builder: (context, state) {
          return Align(
            alignment: const Alignment(0, -1 / 3),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Avatar(photo: state.userEntity?.photo),
                const SizedBox(height: 4.0),
                Text(state.userEntity?.email ?? '', style: textTheme.headline6),
                const SizedBox(height: 4.0),
                Text(state.userEntity?.name ?? '', style: textTheme.headline5),
              ],
            ),
          );
        },
      ),
    );
  }
}