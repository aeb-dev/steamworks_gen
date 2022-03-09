import "dart:io";

import "package:recase/recase.dart";

import "../../steam/steam_accessor.dart";
import "../string_extensions.dart";

/// Extensions on [SteamAccessor] to generate ffi code
extension SteamAccessorExtensions on SteamAccessor {
  /// Generates necessary code for a [SteamAccessor]
  Future<void> generate(IOSink fileSink, String interface) async {
    fileSink.write(
      "static Pointer<$interface> ${name.clearSteamNaming().camelCase}() => nullptr;", // TODO: fix nullptr
    );
  }
}

/// Extensions on [Iterable<SteamAccessor>] to generate ffi code
extension SteamAccessorIterableExtensions on Iterable<SteamAccessor> {
  /// Generates respective code for each [SteamAccessor]
  Future<void> generate(
    IOSink fileSink,
    String name,
  ) async {
    for (SteamAccessor accessor in this) {
      await accessor.generate(fileSink, name);
    }
  }
}
