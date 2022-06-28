import "dart:io";

import "package:recase/recase.dart";

import "../../steam/steam_field.dart";
import "../file_extensions.dart";
import "../string_extensions.dart";
import "../token.dart";

/// Extensions on [SteamField] to generate ffi code
extension SteamFieldExtensions on SteamField {
  /// Generates necessary import for a [SteamField]
  void generateImport({
    required IOSink fileSink,
    Set<String> enumSet = const {},
    Set<String> structSet = const {},
    Set<String> callbackStructSet = const {},
    Set<String> interfaceSet = const {},
  }) {
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
  void generate({
    required IOSink fileSink,
  }) {
    String correctedFieldName = name.clearSteamNaming().camelCase;

    Token token = type.toToken();

    fileSink.writeStructField(
      fieldName: correctedFieldName,
      fieldType: token.typeFfiDart,
      annotation: token.typeAnnotation,
      isPrivate: private,
    );
  }

  /// Generates necessary code for accessing a field over .ref
  void generateFieldAccess({
    required IOSink fileSink,
  }) {
    String correctedFieldName = name.clearSteamNaming().camelCase;

    Token token = type.toToken();

    String fieldAccessor =
        token.fieldAccessor.replaceAll("{0}", "ref.$correctedFieldName");

    fileSink.writeln(
      "${token.typeDart} get $correctedFieldName => $fieldAccessor;\n",
    );
  }
}

/// Extensions on [Iterable<SteamField>] to generate ffi code
extension SteamFieldIterableExtensions on Iterable<SteamField> {
  /// Generates respective import for each [SteamField]
  void generateImport({
    required IOSink fileSink,
    Set<String> enumSet = const {},
    Set<String> structSet = const {},
    Set<String> callbackStructSet = const {},
    Set<String> interfaceSet = const {},
  }) {
    for (SteamField field in this) {
      field.generateImport(
        fileSink: fileSink,
        enumSet: enumSet,
        structSet: structSet,
        callbackStructSet: callbackStructSet,
        interfaceSet: interfaceSet,
      );
    }
  }

  /// Generates respective code for each [SteamField]
  void generate({
    required IOSink fileSink,
  }) {
    for (SteamField field in this) {
      field.generate(
        fileSink: fileSink,
      );
    }
  }

  /// Generates necessary code for accessing a field over .ref
  /// for each [SteamField]
  void generateFieldAccess({
    required IOSink fileSink,
  }) {
    for (SteamField field in where((f) => !f.private)) {
      field.generateFieldAccess(
        fileSink: fileSink,
      );
    }
  }
}
