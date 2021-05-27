import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:radency_internship_project_2/blocs/settings/styles/styles_bloc.dart';

import 'package:radency_internship_project_2/generated/l10n.dart';

import '../../../utils/styles.dart';
import '../../../utils/ui_utils.dart';

class StyleSettingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StylesBloc, StylesState>(builder: (context, state) {
      var colorsArray = List<Widget>.empty(growable: true);

      primaryColorsArray.forEach((element) {
        colorsArray.add(
            buildRoundColorButton(context, element, state.themeColors.accentColor));
      });

      return Scaffold(
          appBar: AppBar(title: Text(S.current.stylePageTitle)),
          body: Column(
            children: <Widget>[
              buildThemeGroupItem(
                  context,
                  S.current.systemTheme,
                  IconData(59987, fontFamily: 'MaterialIcons'),
                  "system",
                  state.theme),
              Divider(),
              buildThemeGroupItem(
                  context,
                  S.current.darkTheme,
                  IconData(59566, fontFamily: 'MaterialIcons'),
                  "dark",
                  state.theme),
              Divider(),
              buildThemeGroupItem(
                  context,
                  S.current.lightTheme,
                  IconData(60130, fontFamily: 'MaterialIcons'),
                  "light",
                  state.theme),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: pixelsToDP(context, 48),
                    vertical: pixelsToDP(context, 32)),
                child: Row(
                  children: colorsArray,
                ),
              ),
              Divider(),
            ],
          ));
    });
  }

  Widget buildRoundColorButton(
      BuildContext context, String buttonColor, String activeColor) {
    Color accentColor = Theme.of(context).accentColor;

    return Expanded(
        child: GestureDetector(
            onTap: () {
              context
                  .read<StylesBloc>()
                  .add(ChangePrimaryColor(newSettingValue: buttonColor));
            },
            child: Container(
              width: pixelsToDP(context, 100),
              height: pixelsToDP(context, 100),
              child: Center(
                child: buttonColor == activeColor
                    ? Container(
                        width: pixelsToDP(context, 90),
                        height: pixelsToDP(context, 90),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.white,
                                width: pixelsToDP(context, 10)),
                            shape: BoxShape.circle,
                            color: HexColor(buttonColor)))
                    : null,
              ),
              decoration: BoxDecoration(
                  border: buttonColor == activeColor
                      ? Border.all(
                          color: accentColor, width: pixelsToDP(context, 4))
                      : null,
                  shape: BoxShape.circle,
                  color: HexColor(buttonColor)),
            )));
  }

  Widget buildThemeGroupItem(BuildContext context, String itemName, IconData iconData,
      String value, String groupValue) {
    return GestureDetector(
        onTap: () {
          context.read<StylesBloc>().add(ChangeTheme(newSettingValue: value));
        },
        child: ListTile(
          title: Row(
            children: [
              Icon(iconData),
              Expanded(
                child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: pixelsToDP(context, 24)),
                    child: Text(itemName)),
              ),
            ],
          ),
          leading: Radio<String>(
            value: value,
            groupValue: groupValue,
            onChanged: (value) {
              context
                  .read<StylesBloc>()
                  .add(ChangeTheme(newSettingValue: value));
            },
          ),
        ));
  }
}
