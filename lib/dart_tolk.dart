/// Use the popular [Tolk](https://github.com/dkager/tolk/) library from Dart.
///
/// Before doing anything else, you must create a [Tolk] instance, and call
/// [Tolk.load].
library dart_tolk;

import 'dart:ffi';

import 'package:ffi/ffi.dart';

import 'tolk_bindings.dart';

/// The main tolk object.
///
/// An instance of this class must be created in order to use screen reading
/// functionality.
class Tolk {
  /// Create an instance.
  ///
  /// If you do not wish to pass a [DynamicLibrary] instance, you can use
  /// [Tolk.fromPath].
  Tolk(DynamicLibrary lib) : _tolk = DartTolk(lib);

  /// Create an instance from a path.
  ///
  /// For example:
  ///
  /// ```
  /// final t = Tolk.fromPath('tolk.dll');
  /// ```
  factory Tolk.fromPath(String path) => Tolk(DynamicLibrary.open(path));

  /// Create an instance from "tolk.dll".
  ///
  /// Note: At time of writing, Windows is the only supported platform on which
  /// Tolk runs. Nothing in the tolk source code indicates this is likely to
  /// change.
  factory Tolk.windows() => Tolk.fromPath('tolk.dll');

  /// The tolk instance to use.
  final DartTolk _tolk;

  /// Load the C portions of the library.
  ///
  /// This function must be called before doing anything else.
  void load() => _tolk.Tolk_Load();

  /// Returns `true` if the C portion of the library has been loaded.
  bool get isLoaded => _tolk.Tolk_IsLoaded();

  /// Unload the library.
  ///
  /// This function must be called when the library is no longer needed.
  void unload() => _tolk.Tolk_Unload();

  /// Output some text.
  ///
  /// The provided string will be both spoken and brailled.
  ///
  /// Pass `interrupt: true` to interrupt speech before speaking.
  void output(String text, {bool interrupt = false}) =>
      _tolk.Tolk_Output(text.toNativeUtf16().cast<Uint16>(), interrupt);

  /// Speak some text.
  ///
  /// Pass `interrupt: true` to stop speaking before speaking the new string.
  void speak(String text, {bool interrupt = false}) =>
      _tolk.Tolk_Speak(text.toNativeUtf16().cast<Uint16>(), interrupt);

  /// Braille some text.
  void braille(String text) =>
      _tolk.Tolk_Braille(text.toNativeUtf16().cast<Uint16>());

  /// Returns `true` if something is currently being spoken.
  bool get isSpeaking => _tolk.Tolk_IsSpeaking();

  /// Configures whether or not to try SAPI if no other screen reader can be
  /// found.
  void trySapi(bool value) => _tolk.Tolk_TrySAPI(value);

  /// Configures whether or not SAPI should be preferred over other screen
  /// readers.
  void preferSapi(bool value) => _tolk.Tolk_PreferSAPI(value);

  /// Returns `true` if the current screen reader supports speech.
  bool get hasSpeech => _tolk.Tolk_HasSpeech();

  /// Returns `true` if the current screen reader supports braille.
  bool get hasBraille => _tolk.Tolk_HasBraille();

  /// Silences the screen reader.
  void silence() => _tolk.Tolk_Silence();

  /// Returns the name of the current screenreader.
  String? get currentScreenReader {
    final ptr = _tolk.Tolk_DetectScreenReader();
    if (ptr == nullptr) {
      return null;
    }
    return ptr.cast<Utf16>().toDartString();
  }
}
