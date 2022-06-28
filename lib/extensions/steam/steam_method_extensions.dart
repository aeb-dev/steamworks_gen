import "dart:io";

import "package:recase/recase.dart";

import "../../steam/steam_method.dart";
import "../file_extensions.dart";
import "../string_extensions.dart";
import "../token.dart";
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
    "GetISteamController",
  };

  bool _shouldCreate() => !(_ignoreList.contains(name) ||
      nameFlat.contains(RegExp(r"(deprecated|DEPRECATED|Deprecated)")));

  /// Generates necessary import for a [SteamMethod]
  void generateImport({
    required IOSink fileSink,
    Set<String> enumSet = const {},
    Set<String> structSet = const {},
    Set<String> callbackStructSet = const {},
    Set<String> interfaceSet = const {},
  }) {
    String importPath =
        returnType.clearClassAccess().clearPointerOrConst().trim().importPath(
              enumSet: enumSet,
              structSet: structSet,
              callbackStructSet: callbackStructSet,
              interfaceSet: interfaceSet,
            );

    if (importPath.isNotEmpty) {
      fileSink.writeImport(packageName: importPath);
    }
  }

  /// Generates necessary code for lookup functions for [SteamMethod]
  void generateLookup({
    required IOSink fileSink,
    required String owner,
    bool isStatic = false,
  }) {
    fileSink.write("final _$friendlyName = dl.lookupFunction<");

    Token token = returnType.toToken();

    fileSink.write("${token.typeFfiC} Function(");

    if (!isStatic) {
      fileSink.write("Pointer<$owner>,");
    }

    params.generate(
      fileSink: fileSink,
      withFunctionC: true,
    );

    fileSink.write("),");

    fileSink.write("${token.typeFfiDart} Function(");
    if (!isStatic) {
      fileSink.write("Pointer<$owner>,");
    }

    params.generate(
      fileSink: fileSink,
      withFunctionDart: true,
    );

    fileSink.writeln(")>(\"$nameFlat\");\n");
  }

  /// Generates necessary code for calling lookup functions for [SteamMethod]
  void generate({
    required IOSink fileSink,
    required String owner,
    bool isStatic = false,
  }) {
    if (isStatic) {
      fileSink.write("static ");
    }

    Token token = returnType.toToken();
    fileSink.write("${token.typeDart} $friendlyName(");

    params.generate(
      fileSink: fileSink,
      withDart: true,
      withName: true,
    );

    fileSink.write(") => ");

    fileSink.write(
      token.fieldAccessor.replaceAll(
        "{0}",
        "_$friendlyName.call(${!isStatic ? 'this,' : ''}${params.generateString(withCaller: true)})",
      ),
    );

    fileSink.writeln(";\n");
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
  void generateImport({
    required IOSink fileSink,
    Set<String> enumSet = const {},
    Set<String> structSet = const {},
    Set<String> callbackStructSet = const {},
    Set<String> interfaceSet = const {},
  }) {
    for (SteamMethod steamMethod in this.where((sm) => sm._shouldCreate())) {
      steamMethod.generateImport(
        fileSink: fileSink,
        enumSet: enumSet,
        structSet: structSet,
        callbackStructSet: callbackStructSet,
        interfaceSet: interfaceSet,
      );

      steamMethod.params.generateImport(
        fileSink: fileSink,
        enumSet: enumSet,
        structSet: structSet,
        callbackStructSet: callbackStructSet,
        interfaceSet: interfaceSet,
      );
    }
  }

  /// Generates respective lookup function code for each [SteamMethod]
  void generateLookup({
    required IOSink fileSink,
    required String owner,
    bool isStatic = false,
  }) {
    for (SteamMethod steamMethod in this.where((sm) => sm._shouldCreate())) {
      steamMethod.generateLookup(
        fileSink: fileSink,
        owner: owner,
        isStatic: isStatic,
      );
    }
  }

  /// Generates respective code for calling lookup function code for each [SteamMethod]
  void generate({
    required IOSink fileSink,
    required String owner,
    bool isStatic = false,
  }) {
    for (SteamMethod steamMethod in this.where((sm) => sm._shouldCreate())) {
      steamMethod.generate(
        fileSink: fileSink,
        owner: owner,
        isStatic: isStatic,
      );
    }
  }
}
