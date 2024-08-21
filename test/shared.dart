import 'package:logging/logging.dart';

void initializeLogging([List<String>? names]) {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    if (names == null || names.contains(record.loggerName)) {
      print(
          '${record.loggerName} - ${record.level.name}: ${record.time}: ${record.message}');
    }
  });
}
