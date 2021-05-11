import 'package:bloc/bloc.dart';
import 'package:radency_internship_project_2/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../utils/styles.dart';

part 'styles_event.dart';
part 'styles_state.dart';

class StylesBloc extends Bloc<StylesEvent, StylesState> {
  SharedPreferences prefs;

  StylesBloc() : super(StylesState(theme: 'system', lightPrimaryColor: primaryColorsArray[3])) {
    add(LoadSharedPreferences());
  }

  StylesState changeTheme(value) {
    prefs.setString(cAppThemeKey, value);

    return StylesState(theme: value, lightPrimaryColor: state.lightPrimaryColor);
  }

  StylesState loadFromPreferences() {
    var theme = prefs.getString(cAppThemeKey);
    var primaryColor = prefs.getString(cLightThemePrimaryColorKey);

    return StylesState(theme: theme != null ? theme : "system", lightPrimaryColor: primaryColor != null ? primaryColor : primaryColorsArray[3]);
  }

  StylesState changePrimaryColor(value) {
    prefs.setString(cLightThemePrimaryColorKey, value);

    return StylesState(theme: state.theme, lightPrimaryColor: value);
  }

  @override
  Stream<StylesState> mapEventToState(StylesEvent event) async* {
    if (event is ChangeTheme) {
      yield changeTheme(event.newSettingValue);
    }

    if (event is ChangePrimaryColor) {
      yield changePrimaryColor(event.newSettingValue);
    }

    if (event is LoadSharedPreferences) {
      prefs = await SharedPreferences.getInstance();

      yield loadFromPreferences();
    }
  }
}
