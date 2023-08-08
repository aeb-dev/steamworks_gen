import "dart:io";

import "package:path/path.dart" as p;
import "package:recase/recase.dart";

import "../../steam/steam_initalizer.dart";
import "../file_extensions.dart";
import "../string_extensions.dart";
import "steam_method_extensions.dart";

/// Extensions on [SteamInitializer] to generate ffi code
extension SteamInitializerExtensions on SteamInitializer {
  /// Generates necessary code for a [SteamInitializer]
  void generate({
    required IOSink fileSink,
    Set<String> enumSet = const {},
    Set<String> structSet = const {},
    Set<String> callbackStructSet = const {},
  }) {
    fileSink.writeln(
      "// ignore_for_file: public_member_api_docs, always_specify_types, avoid_positional_boolean_parameters, avoid_classes_with_only_static_members",
    );
    fileSink.writeImport(
      packageName: "dart:ffi",
    );
    fileSink.writeImport(
      packageName: "package:ffi/ffi.dart",
    );

    methods.generateImport(
      fileSink: fileSink,
      enumSet: enumSet,
      structSet: structSet,
      callbackStructSet: callbackStructSet,
    );

    fileSink.writeImport(
      packageName: "../dl.dart",
    );
    fileSink.writeImport(
      packageName: "../typedefs.dart",
    );

    String correctedName = name.clearSteamNaming().pascalCase;

    methods.generateLookup(
      fileSink: fileSink,
      owner: correctedName,
      isStatic: true,
    );

    fileSink.writeClass(
      className: correctedName,
    );
    fileSink.writeStartBlock();

    methods.generate(
      fileSink: fileSink,
      owner: correctedName,
      isStatic: true,
    );

    fileSink.writeEndBlock();
  }

  /// Generates necessary file and code for a [SteamInitializer]
  Future<void> generateFile({
    required String path,
    required IOSink exportSink,
    Set<String> enumSet = const {},
    Set<String> structSet = const {},
    Set<String> callbackStructSet = const {},
  }) async {
    String fileName = name.toFileName();
    String filePath = p.join(path, "initializers", "$fileName.dart");
    exportSink.writeExport(
      path: "initializers/$fileName.dart",
    );

    File file = File(filePath);
    await file.create(recursive: true);

    IOSink fileSink = file.openWrite(mode: FileMode.writeOnly);

    generate(
      fileSink: fileSink,
      enumSet: enumSet,
      structSet: structSet,
      callbackStructSet: callbackStructSet,
    );

    await fileSink.flush();
    await fileSink.close();
  }
}

/// Extensions on [Iterable<SteamInitializer>] to generate ffi code
extension SteamInitializerIterableExtensions on Iterable<SteamInitializer> {
  /// Creates a file for each [SteamInitializer] and generates respective code
  Future<void> generateFile({
    required String path,
    required IOSink exportSink,
    Set<String> enumSet = const {},
    Set<String> structSet = const {},
    Set<String> callbackStructSet = const {},
  }) async {
    for (SteamInitializer initializer in this) {
      await initializer.generateFile(
        path: path,
        exportSink: exportSink,
        enumSet: enumSet,
        structSet: structSet,
        callbackStructSet: callbackStructSet,
      );
    }
  }
}
