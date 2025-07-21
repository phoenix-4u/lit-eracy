import 'package:hive_flutter/hive_flutter.dart';
import '../../core/constants.dart';

class HiveBoxes {
  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox(AppConstants.hiveBoxUser);
    await Hive.openBox(AppConstants.hiveBoxSettings);
  }

  static Box get userBox => Hive.box(AppConstants.hiveBoxUser);
  static Box get settingsBox => Hive.box(AppConstants.hiveBoxSettings);
}
