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
  Future<void> generate({
    required IOSink fileSink,
    Set<String> enumSet = const {},
    Set<String> structSet = const {},
    Set<String> callbackStructSet = const {},
  }) async {
    fileSink.writeImport(
      packageName: "dart:ffi",
    );
    fileSink.writeImport(
      packageName: "package:ffi/ffi.dart",
    );

    String correctedName = name.clearSteamNaming();

    await methods.generateImport(
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

    await methods.generateLookup(
      fileSink: fileSink,
      owner: correctedName,
      isStatic: true,
    );

    fileSink.writeClass(
      className: correctedName.pascalCase,
    );
    fileSink.writeStartBlock();

    await methods.generate(
      fileSink: fileSink,
      owner: correctedName,
      isStatic: true,
    );

    fileSink.writeEndBlock();

    await fileSink.flush();
    await fileSink.close();
  }

  /// Generates necessary code for a [SteamInitializer]
  Future<void> generateFile({
    required String path,
    // Set<String> typedefSet,
    Set<String> enumSet = const {},
    Set<String> structSet = const {},
    Set<String> callbackStructSet = const {},
  }) async {
    String fileName = name.toFileName();
    String filePath = p.join(path, "global_interfaces", "$fileName.dart");
    File file = File(filePath);
    await file.create(recursive: true);

    IOSink fileSink = file.openWrite(mode: FileMode.writeOnly);

    await generate(
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
  Future<void> generate({
    required String path,
    Set<String> enumSet = const {},
    Set<String> structSet = const {},
    Set<String> callbackStructSet = const {},
  }) async {
    for (SteamInitializer initializer in this) {
      await initializer.generateFile(
        path: path,
        enumSet: enumSet,
        structSet: structSet,
        callbackStructSet: callbackStructSet,
      );
    }
  }
}
