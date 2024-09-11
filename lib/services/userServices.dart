// import 'package:shared_preferences/shared_preferences.dart';
// import 'dart:async';
//
// class UserServices {
//   static final UserServices _instance = UserServices._internal();
//   late SharedPreferences _prefs;
//   final Completer<void> _prefsCompleter = Completer<void>();
//
//   factory UserServices() {
//     return _instance;
//   }
//
//   UserServices._internal() {
//     _initPrefs();
//   }
//
//   Future<void> _initPrefs() async {
//     _prefs = await SharedPreferences.getInstance();
//     _prefsCompleter.complete();
//   }
//
//   Future<void> _ensurePrefsInitialized() async {
//     await _prefsCompleter.future;
//   }
//
//   static const String _onboardingKey = 'onboardingCompleted';
//   static const String _loggedInKey = 'loggedIn';
//
//   Future<void> setOnboardingCompleted(bool value) async {
//     await _ensurePrefsInitialized();
//     await _prefs.setBool(_onboardingKey, value);
//   }
//
//   Future<void> setLoggedIn(bool value) async {
//     await _ensurePrefsInitialized();
//     await _prefs.setBool(_loggedInKey, value);
//   }
//
//   Future<bool> getOnboardingCompleted() async {
//     await _ensurePrefsInitialized();
//     return _prefs.getBool(_onboardingKey) ?? false;
//   }
//
//   Future<bool> getLoggedIn() async {
//     await _ensurePrefsInitialized();
//     return _prefs.getBool(_loggedInKey) ?? false;
//   }
// }