import "dart:io";

import "package:recase/recase.dart";

import "../../steam/steam_field.dart";
import "../file_extensions.dart";
import "../string_extensions.dart";

/// Extensions on [SteamField] to generate ffi code
extension SteamFieldExtensions on SteamField {
  /// Generates necessary import for a [SteamField]
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

  /// Generates necessary code for accessing a field over .ref
  Future<void> generateFieldAccess({
    required IOSink fileSink,
  }) async {
    String correctedFieldName = name.clearSteamNaming().camelCase;

    fileSink.writeln(
      "${type.toNativeType()} get $correctedFieldName => ref.$correctedFieldName;\n",
    );
  }
}

/// Extensions on [Iterable<SteamField>] to generate ffi code
extension SteamFieldIterableExtensions on Iterable<SteamField> {
  /// Generates respective import for each [SteamField]
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

  /// Generates necessary code for accessing a field over .ref
  /// for each [SteamField]
  Future<void> generateFieldAccess({
    required IOSink fileSink,
  }) async {
    for (SteamField field in where((f) => !f.private)) {
      await field.generateFieldAccess(
        fileSink: fileSink,
      );
    }
  }
}
