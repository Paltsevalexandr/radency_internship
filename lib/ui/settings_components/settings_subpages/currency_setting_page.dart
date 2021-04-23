import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/settings/settings_bloc.dart';
import 'package:radency_internship_project_2/generated/l10n.dart';
import 'package:radency_internship_project_2/utils/ui_utils.dart';
import '../../../temp_data/currencies.dart';

class CurrencySettingPage extends StatefulWidget {

  CurrensyPageState createState() => CurrensyPageState();

}
class CurrensyPageState extends State<CurrencySettingPage> {

  String thisCurrency = '';

  List<Widget> createListOfCurrencies(context, settingsBloc, state) {

      return [
        for(String currency in currencies)

          GestureDetector(
            child: Container(
            padding: EdgeInsets.symmetric(
              vertical: pixelsToDP(context, 30), 
              horizontal: pixelsToDP(context, 20)
            ),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(width: 1, color: Colors.grey)
              ),
              color: state.currency == currency ? Colors.red[50] : Colors.blueGrey[50]
            ), 
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(currency),
                  state.currency == currency ? Icon(Icons.check) : Container()
                ],              
              )
            ),
            onTap: () {
              settingsBloc.add(ChangeCurrency(newCurrencyValue: currency));
              //Navigator.pop(context);
            }
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
          appBar: AppBar(title: Text(S.current.currency)),
          body: Container(
            margin: EdgeInsets.only(top: pixelsToDP(context, 20)),
            decoration: BoxDecoration(
              border: Border.symmetric(
                horizontal: BorderSide(
                  color: Colors.grey, 
                  width: pixelsToDP(context, 2))
              )
            ),
            child: ListView(
              children: createListOfCurrencies(context, settingsBloc, state)
            )
          )
        );
      }
    );
  }
}
