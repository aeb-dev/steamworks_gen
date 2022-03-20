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

  Future<void> generateImport({
    required IOSink fileSink,
    Set<String> enumSet = const {},
    Set<String> structSet = const {},
    Set<String> callbackStructSet = const {},
    Set<String> interfaceSet = const {},
  }) async {
    String checkType =
        returnType.clearClassAccess().clearPointerOrConst().trim();

    fileSink.importType(
      type: checkType,
      enumSet: enumSet,
      structSet: structSet,
      callbackStructSet: callbackStructSet,
      interfaceSet: interfaceSet,
    );
  }

  /// Generates necessary code for lookup functions for [SteamMethod]
  Future<void> generateLookup({
    required IOSink fileSink,
    required String owner,
    bool isStatic = false,
  }) async {
    fileSink.write("final _$friendlyName = dl.lookupFunction<");

    fileSink.write("${returnType.toNativeFunctionType()} Function(");

    if (!isStatic) {
      fileSink.write("Pointer<$owner>,");
    }

    await params.generate(
      fileSink: fileSink,
      withFunctionType: true,
    );

    fileSink.write("),");

    fileSink.write("${returnType.toNativeType()} Function(");
    if (!isStatic) {
      fileSink.write("Pointer<$owner>,");
    }

    await params.generate(
      fileSink: fileSink,
      withType: true,
    );

    fileSink.writeln(")>(\"$nameFlat\");\n");
  }

  /// Generates necessary code for calling lookup functions for [SteamMethod]
  Future<void> generate({
    required IOSink fileSink,
    required String owner,
    bool isStatic = false,
  }) async {
    if (isStatic) {
      fileSink.write("static ");
    }
    fileSink.write("${returnType.toNativeType()} $friendlyName(");

    await params.generate(
      fileSink: fileSink,
      withType: true,
      withName: true,
    );

    fileSink.write(") => ");

    fileSink.write("_$friendlyName.call(");
    if (!isStatic) {
      fileSink.write("this,");
    }

    await params.generate(
      fileSink: fileSink,
      withName: true,
    );

    fileSink.writeln(");\n");
  }

  /// darty name of a steam method name
  String get friendlyName {
    String correctedName = nameFlat;
    if (correctedName.startsWith("SteamAPI_")) {
      correctedName = correctedName.replaceFirst("SteamAPI_", "");
    }

    // if no underscore is found (-1) get whole string
    int underScoreIndex = correctedName.indexOf("_");
    correctedName = correctedName.substring(underScoreIndex + 1);
    correctedName =
        correctedName.clearSteamNaming().camelCase.fixDartConflict();

    return correctedName;
  }
}

/// Extensions on [Iterable<SteamMethod>] to generate ffi code
extension SteamMethodIterableExtensions on Iterable<SteamMethod> {
  /// Generates respective import code for each [SteamMethod]
  Future<void> generateImport({
    required IOSink fileSink,
    Set<String> enumSet = const {},
    Set<String> structSet = const {},
    Set<String> callbackStructSet = const {},
    Set<String> interfaceSet = const {},
  }) async {
    for (SteamMethod steamMethod in this.where((sm) => sm._shouldCreate())) {
      await steamMethod.generateImport(
        fileSink: fileSink,
        enumSet: enumSet,
        structSet: structSet,
        callbackStructSet: callbackStructSet,
        interfaceSet: interfaceSet,
      );

      await steamMethod.params.generateImport(
        fileSink: fileSink,
        enumSet: enumSet,
        structSet: structSet,
        callbackStructSet: callbackStructSet,
        interfaceSet: interfaceSet,
      );
    }
  }

  /// Generates respective lookup function code for each [SteamMethod]
  Future<void> generateLookup({
    required IOSink fileSink,
    required String owner,
    bool isStatic = false,
  }) async {
    for (SteamMethod steamMethod in this.where((sm) => sm._shouldCreate())) {
      await steamMethod.generateLookup(
        fileSink: fileSink,
        owner: owner,
        isStatic: isStatic,
      );
    }
  }

  /// Generates respective code for calling lookup function code for each [SteamMethod]
  Future<void> generate({
    required IOSink fileSink,
    required String owner,
    bool isStatic = false,
  }) async {
    for (SteamMethod steamMethod in this.where((sm) => sm._shouldCreate())) {
      await steamMethod.generate(
        fileSink: fileSink,
        owner: owner,
        isStatic: isStatic,
      );
    }
  }
}
