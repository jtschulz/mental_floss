import 'package:flutter/material.dart';
import 'package:mental_floss/app/app.dart';
import 'package:mental_floss/feelings_log_model.dart';
import 'package:provider/provider.dart';

import 'object_box.dart';

late ObjectBox objectbox;

Future<void> main() async {
  // This is required so ObjectBox can get the application directory
  // to store the database in.
  WidgetsFlutterBinding.ensureInitialized();

  objectbox = await ObjectBox.create();

  runApp(ChangeNotifierProvider(
    create: (context) => FeelingsLogModel(),
    child: const App(),
  ));
}
