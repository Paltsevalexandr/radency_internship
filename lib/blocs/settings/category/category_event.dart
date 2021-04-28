part of 'category_bloc.dart';

abstract class CategoryEvent {
  CategoryEvent({
    this.settingName,
    this.listSettingValue
  });

  String settingName;
  List<dynamic> listSettingValue = List.empty();
}

class ChangeCategory implements CategoryEvent {
  ChangeCategory({
    this.settingName,
    this.listSettingValue
  });

  String settingName;

  @override
  List listSettingValue;

  @override
  int settingValue;
}

class LoadCategoriesFromSharedPreferences implements CategoryEvent {
  @override
  List listSettingValue;

  @override
  String settingName;

  @override
  int settingValue;
}


class ChangeCategoryCounter implements CategoryEvent {
  ChangeCategoryCounter({
    this.settingName,
    this.settingValue
  });

  int settingValue;
  String settingName;

  @override
  List listSettingValue;

}