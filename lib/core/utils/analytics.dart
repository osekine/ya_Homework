import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:to_do_app/core/utils/firebase_options.dart';

class Analytics {
  static late FirebaseAnalytics _instance;
  static get instance => _instance;
  static Future<void> init() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    _instance = FirebaseAnalytics.instance;
    return;
  }

  static void addChore() {
    _instance.logEvent(name: 'add_chore');
  }

  static void removeChore() {
    _instance.logEvent(name: 'remove_chore');
  }

  static void updateChore() {
    _instance.logEvent(name: 'update_chore');
  }

  static void doneChore() {
    _instance.logEvent(name: 'done_chore');
  }

  static void undoChore() {
    _instance.logEvent(name: 'undo_chore');
  }
}
