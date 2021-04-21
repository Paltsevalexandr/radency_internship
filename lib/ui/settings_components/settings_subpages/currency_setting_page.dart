import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/settings/settings_bloc.dart';

import '../../../temp_data/currencies.dart';

class CurrencySettingPage extends StatelessWidget {

  List<Widget> createListOfCurrencies(context) {
    SettingsBloc settingsBloc = BlocProvider.of<SettingsBloc>(context);
      return [
        for(String currency in currencies)

          Container(
            margin: EdgeInsets.only(bottom: 2),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(width: 1, color: Colors.grey[200])
              )
            ),
            child: ListTile(
              title: Text(currency),
              hoverColor: Colors.blueGrey[800],
              onTap: () {
                settingsBloc.add(ChangeCurrency(newSettingValue: currency));
                Navigator.pop(context);
              },
            )
          )
    ];
  }

  @override
  Widget build(BuildContext context) {
    var settingsBloc = BlocProvider.of<SettingsBloc>(context);
    
    return BlocBuilder<SettingsBloc, SettingsState>(
      bloc: settingsBloc,
      builder: (BuildContext context, state) {
        return Scaffold(
          appBar: AppBar(title: Text('Currency')),
          body: Container(
            child: ListView(
              children: createListOfCurrencies(context)
            )
          )
        );
      }
    );
  }
}
