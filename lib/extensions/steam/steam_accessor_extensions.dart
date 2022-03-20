import "dart:io";

import "package:recase/recase.dart";

import "../../steam/steam_accessor.dart";
import "../string_extensions.dart";

/// Extensions on [SteamAccessor] to generate ffi code
extension SteamAccessorExtensions on SteamAccessor {
  /// Generates necessary code for lookup functions for [SteamAccessor]
  Future<void> generateLookup({
    required IOSink fileSink,
    required String interface,
  }) async {
    fileSink.writeln(
      "final _${friendlyName.camelCase} = dl.lookupFunction<Pointer<$interface> Function(),Pointer<$interface> Function()>(\"$nameFlat\");\n",
    );
  }

  /// Generates necessary code for a [SteamAccessor]
  Future<void> generate({
    required IOSink fileSink,
    required String interface,
  }) async {
    String instance;
    switch (kind) {
      case "user":
        instance = "userInstance";
        break;
      case "gameserver":
        instance = "serverInstance";
        break;
      case "global":
        instance = "globalInstance";
        break;
      default:
        throw "Unknown accessor kind: '$kind'";
    }
    fileSink.writeln(
      "static Pointer<$interface> get $instance => _$friendlyName();\n",
    );
  }

  /// darty name of a steam accessor name
  String get friendlyName {
    String correctedName = name;
    if (correctedName.contains("_SteamAPI")) {
      correctedName.replaceAll("_SteamAPI", "");
    }

    correctedName = correctedName.clearSteamNaming().camelCase;

    return correctedName;
  }
}

/// Extensions on [Iterable<SteamAccessor>] to generate ffi code
extension SteamAccessorIterableExtensions on Iterable<SteamAccessor> {
  /// Generates respective lookup function code for each [SteamAccessor]
  Future<void> generateLookup({
    required IOSink fileSink,
    required String interface,
  }) async {
    for (SteamAccessor accessor in this) {
      await accessor.generateLookup(
        fileSink: fileSink,
        interface: interface,
      );
    }
  }

  /// Generates respective code for each [SteamAccessor]
  Future<void> generate({
    required IOSink fileSink,
    required String interface,
  }) async {
    for (SteamAccessor accessor in this) {
      await accessor.generate(
        fileSink: fileSink,
        interface: interface,
      );
    }
  }
}
