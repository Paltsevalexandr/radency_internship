import 'package:flutter/material.dart';

class LanguageSettingPage extends StatefulWidget{
  LanguageSettingPage({Key key, this.language, this.changeLanguage}):super(key:key);

  final String language;
  final Function changeLanguage;

  _LanguageState createState() => _LanguageState(language, changeLanguage);
}

class _LanguageState extends State<LanguageSettingPage> {
  
  String language;
  Function changeLanguage;

  _LanguageState(this.language, this.changeLanguage);

  void changeAppLanguage(value) {
    changeLanguage(value);
    setState(() {
      language = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Language')),
      body: ListView(
        children: [
          RadioListTile(
            title: Text('English'),
            value: 'English',
            groupValue: language,
            onChanged: changeAppLanguage
          ),
          RadioListTile(
            title: Text('Ukrainian'),
            value: 'Ukrainian',
            groupValue: language,
            onChanged: changeAppLanguage,
          ),
        ],
      )
    );
  }
}
