import 'package:mental_floss/objectbox.g.dart';

import '../models.dart';

class FeelingsLogRepository {
  FeelingsLogRepository({
    required this.store,
  });

  final Store store;

  void addFeelingsLog(FeelingsLog feelingsLog) {
    store.box<FeelingsLog>().put(feelingsLog);
  }

  List<FeelingsLog> getAllFeelingsLogs() {
    return store.box<FeelingsLog>().getAll();
  }
}
