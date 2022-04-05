import "dart:io";

import "package:path/path.dart" as p;
import "package:recase/recase.dart";

import "../../steam/steam_const.dart";
import "../file_extensions.dart";
import "../string_extensions.dart";

/// Extensions on [SteamConst] to generate ffi code
extension SteamConstExtensions on SteamConst {
  /// Generates necessary code for a [SteamConst]
  Future<void> generate({
    required IOSink fileSink,
  }) async {
    String correctedName = name.clearSteamNaming().afterFirstCapital();
    String correctedType = type.toDartType();

    String correctedValue = value.replaceAll("ull", "");
    correctedValue = correctedValue.replaceAll(" (uint32) ", "");
    correctedValue = correctedValue.replaceAll(
      "( ( uint32 ) 'd' << 16U ) | ( ( uint32 ) 'e' << 8U ) | ( uint32 ) 'v'",
      "6579574",
    );
    correctedValue =
        correctedValue.replaceAll("( SteamItemInstanceID_t ) ~ 0", "~0");
    correctedValue = correctedValue.clearSteamNaming();

    if (int.tryParse(correctedValue[0]) == null) {
      correctedValue = correctedValue.splitMapJoin(
        "|",
        onMatch: (m) => m[0].toString(),
        onNonMatch: (nm) => nm.trim().afterFirstCapital().snakeCase,
      );
    }

    fileSink.writeConst(
      type: correctedType,
      name: correctedName.camelCase,
      value: correctedValue.camelCase,
    );
  }

  /// Generates code for each [SteamConst] in
  /// a single file (steam_constants.dart)
  Future<void> generateFile({
    required String path,
    required FileMode fileMode,
    required IOSink exportSink,
  }) async {
    String filePath = p.join(path, "steam_constants.dart");
    exportSink.writeExport(
      path: "steam_constants.dart",
    );

    File file = File(filePath);
    await file.create(recursive: true);

    IOSink fileSink = file.openWrite(mode: fileMode);

    fileSink.writeln("// ignore_for_file: public_member_api_docs");
    if (fileMode == FileMode.writeOnly) {
      fileSink.writeImport(
        packageName: "typedefs.dart",
      );
    }

    fileSink.writeClass(
      className: "SteamConstants",
    );

    fileSink.writeStartBlock();

    await generate(
      fileSink: fileSink,
    );

    fileSink.writeEndBlock();

    await fileSink.flush();
    await fileSink.close();
  }
}

/// Extensions on [Iterable<SteamConst>] to generate ffi code
extension SteamConstIterableExtensions on Iterable<SteamConst> {
  /// Generates respective code for each [SteamConst]
  Future<void> generateFile({
    required String path,
    required FileMode fileMode,
    required IOSink exportSink,
  }) async {
    for (SteamConst steamConst in this) {
      await steamConst.generateFile(
        path: path,
        fileMode: fileMode,
        exportSink: exportSink,
      );
    }
  }

  /// Generates respective code for each [SteamConst]
  Future<void> generate({
    required IOSink fileSink,
  }) async {
    for (SteamConst steamConst in this) {
      await steamConst.generate(
        fileSink: fileSink,
      );
    }
  }
}

extension on String {
  String afterFirstCapital() {
    for (int index = 0; index < length; ++index) {
      String original = this[index];
      String upper = this[index].toUpperCase();
      if (original == upper) {
        String remaning = substring(index);
        if (int.tryParse(remaning[0]) != null) {
          return this;
        }

        return remaning;
      }
    }

    return this;
  }
}
