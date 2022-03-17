import "dart:io";

import "../../steam/steam_param.dart";
import "../file_extensions.dart";
import "../string_extensions.dart";

/// Extensions on [SteamParam] to generate ffi code
extension SteamFieldExtensions on SteamParam {
  Future<void> generateImport(
    IOSink fileSink,
    Set<String> enumSet,
    Set<String> structSet,
    Set<String> callbackStructSet,
    Set<String> interfaceSet,
  ) async {
    String checkType = type.clearClassAccess().clearPointerOrConst().trim();

    fileSink.importType(
      checkType,
      enumSet,
      structSet,
      callbackStructSet,
      interfaceSet,
    );
  }

  Future<void> generate(
    IOSink fileSink, {
    bool withType = false,
    bool withFunctionType = false,
    bool withName = false,
  }) async {
    if (withType) {
      fileSink.write("${type.toNativeType()} ");
    }

    if (withFunctionType) {
      fileSink.write("${type.toNativeFunctionType()} ");
    }

    if (withName) {
      fileSink.write(friendlyName);
    }

    fileSink.write(",");
  }

  String get friendlyName {
    String correctedName = name;
    if (name[0].toUpperCase() == name[0]) {
      correctedName = name[0].toLowerCase() + name.substring(1);
    }

    return correctedName;
  }
}

/// Extensions on [Iterable<SteamParam>] to generate ffi code
extension SteamParamIterableExtensions on Iterable<SteamParam> {
  Future<void> generateImport(
    IOSink fileSink,
    Set<String> enumSet,
    Set<String> structSet,
    Set<String> callbackStructSet,
    Set<String> interfaceSet,
  ) async {
    for (SteamParam param in this) {
      await param.generateImport(
        fileSink,
        enumSet,
        structSet,
        callbackStructSet,
        interfaceSet,
      );
    }
  }

  Future<void> generate(
    IOSink fileSink, {
    bool withType = false,
    bool withFunctionType = false,
    bool withName = false,
  }) async {
    for (SteamParam param in this) {
      await param.generate(
        fileSink,
        withType: withType,
        withFunctionType: withFunctionType,
        withName: withName,
      );
    }
  }
}
