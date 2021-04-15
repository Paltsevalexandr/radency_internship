import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ExamplePage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => ExamplePage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: Text(AppLocalizations.of(context).exampleTitle))
    );
  }
}