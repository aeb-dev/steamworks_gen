import "dart:io";

import "package:recase/recase.dart";

import "../../steam/steam_accessor.dart";
import "../string_extensions.dart";

/// Extensions on [SteamAccessor] to generate ffi code
extension SteamAccessorExtensions on SteamAccessor {
  /// Generates necessary code for lookup functions for [SteamAccessor]
  void generateLookup({
    required IOSink fileSink,
    required String interface,
  }) {
    fileSink.writeln(
      'final _${friendlyName.camelCase} = dl.lookupFunction<Pointer<$interface> Function(),Pointer<$interface> Function()>("$nameFlat");\n',
    );
  }

  /// Generates necessary code for a [SteamAccessor]
  void generate({
    required IOSink fileSink,
    required String interface,
  }) {
    String instance;
    switch (kind) {
      case "user":
        instance = "userInstance";
      case "gameserver":
        instance = "serverInstance";
      case "global":
        instance = "globalInstance";
      default:
        throw Exception("Unknown accessor kind: '$kind'");
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

    return correctedName.clearSteamNaming().camelCase;
  }
}

/// Extensions on [Iterable<SteamAccessor>] to generate ffi code
extension SteamAccessorIterableExtensions on Iterable<SteamAccessor> {
  /// Generates respective lookup function code for each [SteamAccessor]
  void generateLookup({
    required IOSink fileSink,
    required String interface,
  }) {
    for (SteamAccessor accessor in this) {
      accessor.generateLookup(
        fileSink: fileSink,
        interface: interface,
      );
    }
  }

  /// Generates respective code for each [SteamAccessor]
  void generate({
    required IOSink fileSink,
    required String interface,
  }) {
    for (SteamAccessor accessor in this) {
      accessor.generate(
        fileSink: fileSink,
        interface: interface,
      );
    }
  }
}
