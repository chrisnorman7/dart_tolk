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
  Tolk(final DynamicLibrary lib) : _tolk = DartTolk(lib);

  /// Create an instance from a path.
  ///
  /// For example:
  ///
  /// ```
  /// final t = Tolk.fromPath('tolk.dll');
  /// ```
  factory Tolk.fromPath(final String path) => Tolk(DynamicLibrary.open(path));

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
  bool output(final String text, {final bool interrupt = false}) {
    final ptr = text.toNativeUtf16().cast<WChar>();
    final value = _tolk.Tolk_Output(ptr, interrupt);
    malloc.free(ptr);
    return value;
  }

  /// Speak some text.
  ///
  /// Pass `interrupt: true` to stop speaking before speaking the new string.
  void speak(final String text, {final bool interrupt = false}) {
    final ptr = text.toNativeUtf16().cast<WChar>();
    _tolk.Tolk_Speak(ptr, interrupt);
    malloc.free(ptr);
  }

  /// Braille some text.
  void braille(final String text) {
    final ptr = text.toNativeUtf16().cast<WChar>();
    _tolk.Tolk_Braille(ptr);
    malloc.free(ptr);
  }

  /// Returns `true` if something is currently being spoken.
  bool get isSpeaking => _tolk.Tolk_IsSpeaking();

  /// Configures whether or not to try SAPI if no other screen reader can be
  /// found.
  set trySapi(final bool value) => _tolk.Tolk_TrySAPI(value);

  /// Configures whether or not SAPI should be preferred over other screen
  /// readers.
  set preferSapi(final bool value) => _tolk.Tolk_PreferSAPI(value);

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
