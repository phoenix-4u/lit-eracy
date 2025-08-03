//## File: frontend/lib/core/di.dart

import 'package:get_it/get_it.dart';
import 'di/injection_container.dart' as di;

final sl = GetIt.instance;

Future<void> init() async {
  await di.init();
}
