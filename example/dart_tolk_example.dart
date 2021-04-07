/// A simple tolk example.
import 'dart:ffi';

import 'package:dart_tolk/dart_tolk.dart';

Future<void> main() async {
  final t = Tolk(DynamicLibrary.open('tolk.dll'));
  t.load();
  print('Loaded tolk.');
  t.trySapi(true);
  print('Screen reader: ${t.currentScreenReader}.');
  print('Screen reader ${t.hasBraille ? "has" : "does not have"} braille.');
  print('Screen reader ${t.hasSpeech ? "has" : "does not have"} speech.');
  t.output('Hello from Tolk, speaking through dart.');
  await Future.delayed(Duration(seconds: 2));
  t.Tolk_Unload();
  print('Unloaded Tolk.');
}
