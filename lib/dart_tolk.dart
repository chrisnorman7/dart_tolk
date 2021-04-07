/// Use the popular [Tolk](https://github.com/dkager/tolk/) library from Dart.
///
/// Before doing anything else, you must create a [Tolk] instance, and call [Tolk.load].
library dart_tolk;

import 'dart:ffi';

import 'package:ffi/ffi.dart';

import 'tolk_bindings.dart';

/// The main tolk object.
///
/// An instance of this class must be created in order to use screen reading functionality.
class Tolk extends DartTolk {
  Tolk(DynamicLibrary lib) : super(lib);

  /// Load the C portions of the library.
  ///
  /// This function must be called before doing anything else.
  void load() => Tolk_Load();

  /// Returns `true` if the C portion of the library has been loaded.
  bool get isLoaded => Tolk_IsLoaded();

  /// Unload the library.
  ///
  /// This function must be called when the library is no longer needed.
  void unload() => Tolk_Unload();

  /// Output some text.
  ///
  /// The provided string will be both spoken and brailled.
  ///
  /// Pass `interrupt: true` to interrupt speech before speaking.
  void output(String text, {bool interrupt = false}) =>
      Tolk_Output(text.toNativeUtf16().cast<Uint16>(), interrupt);

  /// Speak some text.
  ///
  /// Pass `interrupt: true` to stop speaking before speaking the new string.
  void speak(String text, {bool interrupt = false}) =>
      Tolk_Speak(text.toNativeUtf16().cast<Uint16>(), interrupt);

  /// Braille some text.
  void braille(String text) =>
      Tolk_Braille(text.toNativeUtf16().cast<Uint16>());

  /// Returns `true` if something is currently being spoken.
  bool get isSpeaking => Tolk_IsSpeaking();

  /// Configures whether or not to try SAPI if no other screen reader can be found.
  void trySapi(bool value) => Tolk_TrySAPI(value);

  /// Configures whether or not SAPI should be preferred over other screen readers.
  void preferSapi(bool value) => Tolk_PreferSAPI(value);

  /// Returns `true` if the current screen reader supports speech.
  bool get hasSpeech => Tolk_HasSpeech();

  /// Returns `true` if the current screen reader supports braille.
  bool get hasBraille => Tolk_HasBraille();

  /// Silences the screen reader.
  void silence() => Tolk_Silence();

  /// Returns the name of the current screenreader.
  String? get currentScreenReader {
    final ptr = Tolk_DetectScreenReader();
    if (ptr == nullptr) {
      return null;
    }
    return ptr.cast<Utf16>().toDartString();
  }
}
