// ignore_for_file: avoid_print
/// A simple tolk example.
import 'package:dart_tolk/dart_tolk.dart';

Future<void> main() async {
  final t = Tolk.fromPath('tolk.dll')..load();
  print('Loaded tolk.');
  print('Screen reader: ${t.currentScreenReader}.');
  print('Screen reader ${t.hasBraille ? "has" : "does not have"} braille.');
  print('Screen reader ${t.hasSpeech ? "has" : "does not have"} speech.');
  t.trySapi = true;
  print('Trying SAPI.');
  t.output('Hello from Tolk, speaking through dart.');
  await Future<void>.delayed(const Duration(seconds: 2));
  t.unload();
  print('Unloaded Tolk.');
}
