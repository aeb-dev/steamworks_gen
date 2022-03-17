import "dart:io";

import "package:path/path.dart" as p;

import "../../steam/steam_interface.dart";
import "../file_extensions.dart";
import "../string_extensions.dart";
import "steam_accessor_extensions.dart";
import "steam_enum_extensions.dart";
import "steam_field_extensions.dart";
import "steam_method_extensions.dart";

/// Extensions on [SteamInterface] to generate ffi code
extension SteamInterfaceExtensions on SteamInterface {
  /// Generates necessary code for a [SteamInterface]
  Future<void> generate(
    IOSink fileSink,
    Set<String> enumSet,
    Set<String> structSet,
    Set<String> callbackStructSet,
    Set<String> interfaceSet,
  ) async {
    fileSink.writeImport("dart:ffi");
    fileSink.writeImport("package:ffi/ffi.dart");
    fileSink.writeImport("../steam_api.dart");
    fileSink.writeImport("../typedefs.dart");

    await fields.generateImport(
      fileSink,
      enumSet,
      structSet,
      callbackStructSet,
      interfaceSet,
    );

    await methods.generateImport(
      fileSink,
      enumSet,
      structSet,
      callbackStructSet,
      interfaceSet,
    );

    String correctedName = name.clearSteamNaming().clearInterfaceName();

    await accessors.generateLookup(fileSink, correctedName);

    fileSink.writeClass(correctedName, "Opaque");
    fileSink.writeStartBlock();

    await accessors.generate(fileSink, correctedName);

    fileSink.writeEndBlock();

    await fields.generate(fileSink);

    if (methods.isNotEmpty) {
      await methods.generateLookup(fileSink, correctedName);

      fileSink.writeExtension(
        "${correctedName}Extensions",
        "Pointer<$correctedName>",
      );
      fileSink.writeStartBlock();

      await methods.generate(fileSink, correctedName);

      fileSink.writeEndBlock();
    }
  }

  Future<void> generateFile(
    String path,
    Set<String> enumSet,
    Set<String> structSet,
    Set<String> callbackStructSet,
    Set<String> interfaceSet,
  ) async {
    await enums.generate(path);

    String fileName = name.clearInterfaceName().toFileName();
    String filePath = p.join(path, "interfaces", "$fileName.dart");
    File file = File(filePath);
    await file.create(recursive: true);

    IOSink fileSink = file.openWrite(mode: FileMode.writeOnly);
    await generate(
      fileSink,
      enumSet,
      structSet,
      callbackStructSet,
      interfaceSet,
    );

    await fileSink.flush();
    await fileSink.close();
  }
}

/// Extensions on [Iterable<SteamInterface>] to generate ffi code
extension SteamInterfaceIterableExtensions on Iterable<SteamInterface> {
  /// Creates a file for each [SteamInterface] and generates respective code
  Future<void> generate(
    String path,
    Set<String> enumSet,
    Set<String> structSet,
    Set<String> callbackStructSet,
    Set<String> interfaceSet,
  ) async {
    for (SteamInterface interface in this) {
      await interface.generateFile(
        path,
        enumSet,
        structSet,
        callbackStructSet,
        interfaceSet,
      );
    }
  }
}
