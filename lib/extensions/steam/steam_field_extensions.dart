import "dart:io";

import "package:recase/recase.dart";

import "../../steam/steam_field.dart";
import "../file_extensions.dart";
import "../string_extensions.dart";

/// Extensions on [SteamField] to generate ffi code
extension SteamFieldExtensions on SteamField {
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

  /// Generates necessary code for a [SteamField]
  Future<void> generate(IOSink fileSink) async {
    String correctedFieldName = name.clearSteamNaming().camelCase;

    String nativeType = type.toNativeType();
    String annotation = type.toNativeTypeAnnotation();

    fileSink.writeStructField(
      correctedFieldName,
      nativeType,
      annotation,
      isPrivate: private,
    );
  }
}

/// Extensions on [Iterable<SteamField>] to generate ffi code
extension SteamFieldIterableExtensions on Iterable<SteamField> {
  Future<void> generateImport(
    IOSink fileSink,
    Set<String> enumSet,
    Set<String> structSet,
    Set<String> callbackStructSet,
    Set<String> interfaceSet,
  ) async {
    for (SteamField field in this) {
      await field.generateImport(
        fileSink,
        enumSet,
        structSet,
        callbackStructSet,
        interfaceSet,
      );
    }
  }

  /// Generates respective code for each [SteamField]
  Future<void> generate(IOSink fileSink) async {
    for (SteamField field in this) {
      await field.generate(fileSink);
    }
  }
}
