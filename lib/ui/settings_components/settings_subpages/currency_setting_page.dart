import 'package:flutter/material.dart';

class CurrencySettingPage extends StatefulWidget {
  CurrencySettingPage({
    Key key, 
    this.currency, 
    this.changeCurrency
  }) : super(key:key);

  final String currency;
  final Function changeCurrency;

  _CurrencyState createState() => _CurrencyState(currency, changeCurrency);
}

class _CurrencyState extends State<CurrencySettingPage> {
  String currency;
  Function changeCurrency;

  _CurrencyState(this.currency, this.changeCurrency);

  void changeAppCurrency(value) {
    changeCurrency(value);
    setState(() {
      currency = value;
    });
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: Text('Currency')),
      body: ListView(
        children: [
          RadioListTile(
            title: Text('USD'),
            value: 'USD',
            groupValue: currency,
            onChanged: changeAppCurrency,
          ),
          RadioListTile(
            title: Text('UAH'),
            value: 'UAH',
            groupValue: currency,
            onChanged: changeAppCurrency,
          ),
        ],
      )
    );
  }
}

