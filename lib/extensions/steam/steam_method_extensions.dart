import "dart:io";

import "package:recase/recase.dart";

import "../../steam/steam_method.dart";
import "../../steam/steam_param.dart";
import "../string_extensions.dart";

/// Extensions on [SteamMethod] to generate ffi code
extension SteamMethodExtensions on SteamMethod {
  static const Set<String> _ignoreList = {
    "SetWarningMessageHook",
    "SetDebugOutputFunction",
    "EnableActionEventCallbacks",
    "SetGlobalCallback_SteamNetConnectionStatusChanged",
    "SetGlobalCallback_SteamNetAuthenticationStatusChanged",
    "SetGlobalCallback_SteamRelayNetworkStatusChanged",
    "SetGlobalCallback_FakeIPResult",
    "SetGlobalCallback_MessagesSessionRequest",
    "SetGlobalCallback_MessagesSessionFailed",
  };

  bool _shouldCreate() => !(_ignoreList.contains(name) ||
      nameFlat.contains(RegExp(r"(deprecated|DEPRECATED|Deprecated)")));

  /// Generates necessary code for lookup functions for [SteamMethod]
  Future<void> generateLookup(IOSink fileSink, String owner) async {
    if (!_shouldCreate()) {
      return;
    }

    // fileSink
    //     .write("final ${returnType.toNativeType()} Function(Pointer<$owner>,");
    // // if (params.isNotEmpty) {
    // //   for (SteamParam steamParam in params) {
    // //     fileSink.write(
    // //       "${steamParam.paramType.toNativeType()} ${steamParam.paramName},",
    // //     );
    // //   }
    // // }

    // fileSink.write(") ");

    // fileSink.write("_$friendlyName = dl.lookupFunction<");
    fileSink.write("final _$friendlyName = dl.lookupFunction<");

    fileSink.write(
      "${returnType.toNativeFunctionType()} Function(Pointer<$owner>,",
    );
    if (params.isNotEmpty) {
      for (SteamParam steamParam in params) {
        fileSink.write("${steamParam.type.toNativeFunctionType()},");
      }
    }

    fileSink.write("),");

    fileSink.write("${returnType.toNativeType()} Function(Pointer<$owner>,");

    if (params.isNotEmpty) {
      for (SteamParam steamParam in params) {
        fileSink.write("${steamParam.type.toNativeType()},");
      }
    }

    fileSink.writeln(")>(\"$nameFlat\");\n");
  }

  /// Generates necessary code for calling lookup functions for [SteamMethod]
  Future<void> generate(IOSink fileSink, String owner) async {
    if (!_shouldCreate()) {
      return;
    }

    fileSink.write("${returnType.toNativeType()} $friendlyName(");

    if (params.isNotEmpty) {
      for (SteamParam steamParam in params) {
        fileSink.write(
          "${steamParam.type.toNativeType()} ${steamParam.name},",
        );
      }
    }

    fileSink.write(") => ");

    fileSink.write("_$friendlyName.call(this,");
    if (params.isNotEmpty) {
      for (SteamParam steamParam in params) {
        fileSink.write("${steamParam.name},");
      }
    }

    fileSink.writeln(");\n");
  }

  /// darty name of a steam method name
  String get friendlyName {
    int secondUnderScoreIndex =
        nameFlat.indexOf("_", nameFlat.indexOf("_") + 1);

    String correctedName = nameFlat.substring(secondUnderScoreIndex + 1);
    if (correctedName.startsWith("t_")) {
      correctedName = correctedName.replaceFirst("t_", "");
    }
    correctedName = correctedName.camelCase.fixDartConflict();

    return correctedName;
  }
}

/// Extensions on [Iterable<SteamMethod>] to generate ffi code
extension SteamMethodIterableExtensions on Iterable<SteamMethod> {
  /// Generates respective lookup function code for each [SteamMethod]
  Future<void> generateLookup(IOSink fileSink, String struct) async {
    for (SteamMethod steamMethod in this) {
      await steamMethod.generateLookup(fileSink, struct);
    }
  }

  /// Generates respective code for calling lookup function code for each [SteamMethod]
  Future<void> generate(IOSink fileSink, String struct) async {
    for (SteamMethod steamMethod in this) {
      await steamMethod.generate(fileSink, struct);
    }
  }
}
