// ignore_for_file: constant_identifier_names

import 'package:colorize/colorize.dart';
//import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

enum Level { verbose, debug, info, warning, error, nothing }

/// This class can be used to log various kind of information into the logs
/// Use this import in your file to use Log
///
/// We can use logs as follows in the code
///   Log.d('debug message');
//    Log.e('error message');
//    Log.i('information message');
//    Log.w('warning message');
//    Log.v('verbose message');
class Log {
  /// This can be used to log any information which is used for debugging only.
  static d(String message) {
    _log(message, level: Level.debug, style: Styles.BG_DARK_GRAY);
  }

  /// You can log errors or any kind of serious events that happened during the run.
  static e(String message, {StackTrace? stackTrace}) {
    _log(
      message,
      level: Level.error,
      stackTrace: stackTrace,
      style: Styles.RED,
    );
  }

  /// Any informative logs which does not leak user data can be logged using this.
  static i(String message) {
    _log(message, level: Level.info, style: Styles.LIGHT_BLUE);
  }

  /// You can log as much information as you possibly can about events that occur while the run.
  static v(String message, {StackTrace? stackTrace}) {
    _log(
      message,
      level: Level.verbose,
      stackTrace: stackTrace,
      style: Styles.GREEN,
    );
  }

  /// You can log warning messages using this log.
  static w(String message) {
    _log(message, level: Level.warning, style: Styles.YELLOW);
  }

  static _log(
    String message, {
    StackTrace? stackTrace,
    required Level level,
    required Styles style,
  }) {
    /* if (FlavorConfig.instance.name == 'PRODUCTION') {
      return;
    }*/

    if (kDebugMode) {
      print(
        Colorize().apply(style, '[${level.name.toUpperCase()}]  $message \n'),
      );
    }
  }
}
