import "dart:io";

import "package:recase/recase.dart";

import "../../steam/steam_field.dart";
import "../file_extensions.dart";
import "../string_extensions.dart";

/// Extensions on [SteamField] to generate ffi code
extension SteamFieldExtensions on SteamField {
  /// Generates necessary code for a [SteamField]
  Future<void> generate(IOSink fileSink) async {
    String correctedFieldName = name.clearSteamNaming().camelCase;

    if (private) {
      correctedFieldName = "_$correctedFieldName";
    }

    String nativeType = type.toNativeType();
    String annotation = type.toNativeTypeAnnotation();

    fileSink.writeStructField(correctedFieldName, nativeType, annotation);
  }
}

/// Extensions on [Iterable<SteamField>] to generate ffi code
extension SteamFieldIterableExtensions on Iterable<SteamField> {
  /// Generates respective code for each [SteamField]
  Future<void> generate(IOSink fileSink) async {
    for (SteamField field in this) {
      await field.generate(fileSink);
    }
  }
}
