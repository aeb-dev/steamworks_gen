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
  void generate({
    required IOSink fileSink,
    Set<String> enumSet = const {},
    Set<String> structSet = const {},
    Set<String> callbackStructSet = const {},
    Set<String> interfaceSet = const {},
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
    fileSink.writeImport(
      packageName: "../dl.dart",
    );
    fileSink.writeImport(
      packageName: "../typedefs.dart",
    );

    fields.generateImport(
      fileSink: fileSink,
      enumSet: enumSet,
      structSet: structSet,
      callbackStructSet: callbackStructSet,
      interfaceSet: interfaceSet,
    );

    methods.generateImport(
      fileSink: fileSink,
      enumSet: enumSet,
      structSet: structSet,
      callbackStructSet: callbackStructSet,
      interfaceSet: interfaceSet,
    );

    String correctedName = name.clearSteamNaming();

    accessors.generateLookup(
      fileSink: fileSink,
      interface: correctedName,
    );

    fileSink.writeClass(
      className: correctedName,
      extend: "Opaque",
      isFinal: true,
    );
    fileSink.writeStartBlock();

    accessors.generate(
      fileSink: fileSink,
      interface: correctedName,
    );

    fileSink.writeEndBlock();

    fields.generate(
      fileSink: fileSink,
    );

    if (methods.isNotEmpty) {
      methods.generateLookup(
        fileSink: fileSink,
        owner: correctedName,
      );

      fileSink.writeExtension(
        extensionName: "${correctedName}Extensions",
        on: "Pointer<$correctedName>",
      );
      fileSink.writeStartBlock();

      methods.generate(
        fileSink: fileSink,
        owner: correctedName,
      );

      fileSink.writeEndBlock();
    }
  }

  /// Generates necessary file and code for a [SteamInterface]
  Future<void> generateFile({
    required String path,
    required IOSink exportSink,
    Set<String> enumSet = const {},
    Set<String> structSet = const {},
    Set<String> callbackStructSet = const {},
    Set<String> interfaceSet = const {},
  }) async {
    await enums.generateFile(
      path: path,
      exportSink: exportSink,
    );

    String fileName = "i${name.clearInterfaceName().toFileName()}";
    String filePath = p.join(path, "interfaces", "$fileName.dart");
    exportSink.writeExport(
      path: "interfaces/$fileName.dart",
    );

    File file = File(filePath);
    await file.create(recursive: true);

    IOSink fileSink = file.openWrite(mode: FileMode.writeOnly);
    generate(
      fileSink: fileSink,
      enumSet: enumSet,
      structSet: structSet,
      callbackStructSet: callbackStructSet,
      interfaceSet: interfaceSet,
    );

    await fileSink.flush();
    await fileSink.close();
  }
}

/// Extensions on [Iterable<SteamInterface>] to generate ffi code
extension SteamInterfaceIterableExtensions on Iterable<SteamInterface> {
  /// Creates a file for each [SteamInterface] and generates respective code
  Future<void> generateFile({
    required String path,
    required IOSink exportSink,
    Set<String> enumSet = const {},
    Set<String> structSet = const {},
    Set<String> callbackStructSet = const {},
    Set<String> interfaceSet = const {},
  }) async {
    for (SteamInterface interface
        in where((i) => i.name != "ISteamController")) {
      await interface.generateFile(
        exportSink: exportSink,
        path: path,
        enumSet: enumSet,
        structSet: structSet,
        callbackStructSet: callbackStructSet,
        interfaceSet: interfaceSet,
      );
    }
  }
}
