import "dart:io";

import "package:recase/recase.dart";

import "../../steam/steam_param.dart";
import "../file_extensions.dart";
import "../string_extensions.dart";

/// Extensions on [SteamParam] to generate ffi code
extension SteamFieldExtensions on SteamParam {
  Future<void> generateImport({
    required IOSink fileSink,
    Set<String> enumSet = const {},
    Set<String> structSet = const {},
    Set<String> callbackStructSet = const {},
    Set<String> interfaceSet = const {},
  }) async {
    String checkType = type.clearClassAccess().clearPointerOrConst().trim();

    fileSink.importType(
      type: checkType,
      enumSet: enumSet,
      structSet: structSet,
      callbackStructSet: callbackStructSet,
      interfaceSet: interfaceSet,
    );
  }

  /// /// Generates necessary code for a [SteamParam]
  Future<void> generate({
    required IOSink fileSink,
    bool withType = false,
    bool withFunctionType = false,
    bool withName = false,
  }) async {
    if (withType) {
      fileSink.write(type.toNativeType());
    }

    if (withFunctionType) {
      fileSink.write(type.toNativeFunctionType());
    }

    if (withName) {
      fileSink.write(" ${name.clearSteamNaming().camelCase}");
    }

    fileSink.write(",");
  }
}

/// Extensions on [Iterable<SteamParam>] to generate ffi code
extension SteamParamIterableExtensions on Iterable<SteamParam> {
  Future<void> generateImport({
    required IOSink fileSink,
    Set<String> enumSet = const {},
    Set<String> structSet = const {},
    Set<String> callbackStructSet = const {},
    Set<String> interfaceSet = const {},
  }) async {
    for (SteamParam param in this) {
      await param.generateImport(
        fileSink: fileSink,
        enumSet: enumSet,
        structSet: structSet,
        callbackStructSet: callbackStructSet,
        interfaceSet: interfaceSet,
      );
    }
  }

  Future<void> generate({
    required IOSink fileSink,
    bool withType = false,
    bool withFunctionType = false,
    bool withName = false,
  }) async {
    for (SteamParam param in this) {
      await param.generate(
        fileSink: fileSink,
        withType: withType,
        withFunctionType: withFunctionType,
        withName: withName,
      );
    }
  }
}
