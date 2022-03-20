import "dart:io";

import "package:recase/recase.dart";

import "../../steam/steam_field.dart";
import "../file_extensions.dart";
import "../string_extensions.dart";

/// Extensions on [SteamField] to generate ffi code
extension SteamFieldExtensions on SteamField {
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

  /// Generates necessary code for a [SteamField]
  Future<void> generate({
    required IOSink fileSink,
  }) async {
    String correctedFieldName = name.clearSteamNaming().camelCase;

    String nativeType = type.toNativeType();
    String annotation = type.toNativeTypeAnnotation();

    fileSink.writeStructField(
      fieldName: correctedFieldName,
      fieldType: nativeType,
      annotation: annotation,
      isPrivate: private,
    );
  }
}

/// Extensions on [Iterable<SteamField>] to generate ffi code
extension SteamFieldIterableExtensions on Iterable<SteamField> {
  Future<void> generateImport({
    required IOSink fileSink,
    Set<String> enumSet = const {},
    Set<String> structSet = const {},
    Set<String> callbackStructSet = const {},
    Set<String> interfaceSet = const {},
  }) async {
    for (SteamField field in this) {
      await field.generateImport(
        fileSink: fileSink,
        enumSet: enumSet,
        structSet: structSet,
        callbackStructSet: callbackStructSet,
        interfaceSet: interfaceSet,
      );
    }
  }

  /// Generates respective code for each [SteamField]
  Future<void> generate({
    required IOSink fileSink,
  }) async {
    for (SteamField field in this) {
      await field.generate(
        fileSink: fileSink,
      );
    }
  }
}
