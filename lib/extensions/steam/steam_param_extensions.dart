import "dart:io";

import "package:recase/recase.dart";

import "../../steam/steam_param.dart";
import "../file_extensions.dart";
import "../string_extensions.dart";

/// Extensions on [SteamParam] to generate ffi code
extension SteamFieldExtensions on SteamParam {
  /// Generates necessary imports for a [SteamParam]
  Future<void> generateImport({
    required IOSink fileSink,
    Set<String> enumSet = const {},
    Set<String> structSet = const {},
    Set<String> callbackStructSet = const {},
    Set<String> interfaceSet = const {},
  }) async {
    String importPath =
        type.clearClassAccess().clearPointerOrConst().trim().importPath(
              enumSet: enumSet,
              structSet: structSet,
              callbackStructSet: callbackStructSet,
              interfaceSet: interfaceSet,
            );

    if (importPath.isNotEmpty) {
      fileSink.writeImport(packageName: importPath);
    }
  }

  /// Generates necessary code for a [SteamParam]
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
  /// Generates respective imports for each [SteamParam]
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

  /// Generates respective code for each [SteamParam]
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
