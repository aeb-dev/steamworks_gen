import "dart:io";

import "package:recase/recase.dart";

import "../../steam/steam_accessor.dart";
import "../string_extensions.dart";

/// Extensions on [SteamAccessor] to generate ffi code
extension SteamAccessorExtensions on SteamAccessor {
  /// Generates necessary code for lookup functions for [SteamAccessor]
  Future<void> generateLookup(IOSink fileSink, String interface) async {
    fileSink.writeln(
      "final _${friendlyName.camelCase} = dl.lookupFunction<Pointer<$interface> Function(),Pointer<$interface> Function()>(\"$nameFlat\");\n",
    );
  }

  /// Generates necessary code for a [SteamAccessor]
  Future<void> generate(IOSink fileSink, String interface) async {
    fileSink.writeln(
      "static Pointer<$interface> ${friendlyName.camelCase}() => _${friendlyName.camelCase}();\n",
    );
  }

  String get friendlyName {
    String correctedName = name.clearSteamNaming();
    if (correctedName.contains("_SteamAPI")) {
      correctedName.replaceAll("_SteamAPI", "");
    }

    return correctedName;
  }
}

/// Extensions on [Iterable<SteamAccessor>] to generate ffi code
extension SteamAccessorIterableExtensions on Iterable<SteamAccessor> {
  /// Generates respective lookup function code for each [SteamAccessor]
  Future<void> generateLookup(
    IOSink fileSink,
    String interface,
  ) async {
    for (SteamAccessor accessor in this) {
      await accessor.generateLookup(fileSink, interface);
    }
  }

  /// Generates respective code for each [SteamAccessor]
  Future<void> generate(
    IOSink fileSink,
    String interface,
  ) async {
    for (SteamAccessor accessor in this) {
      await accessor.generate(fileSink, interface);
    }
  }
}
