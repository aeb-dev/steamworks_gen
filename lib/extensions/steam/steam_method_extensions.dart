import "dart:io";

import "package:recase/recase.dart";

import "../../steam/steam_method.dart";
import "../file_extensions.dart";
import "../string_extensions.dart";
import "steam_param_extensions.dart";

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

  Future<void> generateImport(
    IOSink fileSink,
    Set<String> enumSet,
    Set<String> structSet,
    Set<String> callbackStructSet,
    Set<String> interfaceSet,
  ) async {
    String checkType =
        returnType.clearClassAccess().clearPointerOrConst().trim();

    fileSink.importType(
      checkType,
      enumSet,
      structSet,
      callbackStructSet,
      interfaceSet,
    );
  }

  /// Generates necessary code for lookup functions for [SteamMethod]
  Future<void> generateLookup(IOSink fileSink, String owner) async {
    fileSink.write("final _$friendlyName = dl.lookupFunction<");

    fileSink.write(
      "${returnType.toNativeFunctionType()} Function(Pointer<$owner>,",
    );

    await params.generate(
      fileSink,
      withFunctionType: true,
    );

    fileSink.write("),");

    fileSink.write("${returnType.toNativeType()} Function(Pointer<$owner>,");

    await params.generate(
      fileSink,
      withType: true,
    );

    fileSink.writeln(")>(\"$nameFlat\");\n");
  }

  /// Generates necessary code for calling lookup functions for [SteamMethod]
  Future<void> generate(IOSink fileSink, String owner) async {
    fileSink.write("${returnType.toNativeType()} $friendlyName(");

    await params.generate(
      fileSink,
      withType: true,
      withName: true,
    );

    fileSink.write(") => ");

    fileSink.write("_$friendlyName.call(this,");
    await params.generate(
      fileSink,
      withName: true,
    );

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
  /// Generates respective import code for each [SteamMethod]
  Future<void> generateImport(
    IOSink fileSink,
    Set<String> enumSet,
    Set<String> structSet,
    Set<String> callbackStructSet,
    Set<String> interfaceSet,
  ) async {
    for (SteamMethod steamMethod in this.where((sm) => sm._shouldCreate())) {
      await steamMethod.generateImport(
        fileSink,
        enumSet,
        structSet,
        callbackStructSet,
        interfaceSet,
      );

      await steamMethod.params.generateImport(
        fileSink,
        enumSet,
        structSet,
        callbackStructSet,
        interfaceSet,
      );
    }
  }

  /// Generates respective lookup function code for each [SteamMethod]
  Future<void> generateLookup(IOSink fileSink, String struct) async {
    for (SteamMethod steamMethod in this.where((sm) => sm._shouldCreate())) {
      await steamMethod.generateLookup(fileSink, struct);
    }
  }

  /// Generates respective code for calling lookup function code for each [SteamMethod]
  Future<void> generate(IOSink fileSink, String struct) async {
    for (SteamMethod steamMethod in this.where((sm) => sm._shouldCreate())) {
      await steamMethod.generate(fileSink, struct);
    }
  }
}
