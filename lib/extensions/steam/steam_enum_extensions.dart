import "dart:io";

import "package:path/path.dart" as p;

import "../../steam/steam_enum.dart";
import "../../steam/steam_enum_value.dart";
import "../file_extensions.dart";
import "../string_extensions.dart";
import "steam_enum_value_extensions.dart";

/// Extensions on [SteamEnum] to generate ffi code
extension SteamEnumExtensions on SteamEnum {
  /// Generates necessary code for a [SteamEnum]
  Future<void> generate({
    required IOSink fileSink,
  }) async {
    values.sort((a, b) => a.value.compareTo(b.value));

    String firstKey = values.first.name;

    int indexOfCommonPartEnd = 0;

    chars:
    for (; indexOfCommonPartEnd < firstKey.length; ++indexOfCommonPartEnd) {
      String char = firstKey[indexOfCommonPartEnd];
      for (SteamEnumValue enumValue in values.skip(1)) {
        if (char != enumValue.name[indexOfCommonPartEnd]) {
          break chars;
        }
      }
    }

    String correctedName = name.clearSteamNaming();

    fileSink.writeln("// ignore_for_file: public_member_api_docs");
    fileSink.writeTypedef(
      alias: correctedName,
      of: "int",
    );

    fileSink.writeEnum(
      enumName: "${correctedName}Enum",
    );
    fileSink.writeStartBlock();

    for (SteamEnumValue enumValue
        in values.where((val) => !val.name.contains("Force32Bit"))) {
      await enumValue.generate(
        fileSink: fileSink,
        enumName: correctedName,
        nameIndex: indexOfCommonPartEnd,
      );
    }

    fileSink.writeEndBlock();
  }

  /// Creates a file for the [SteamEnum] and generates respective code
  Future<void> generateFile({
    required String path,
    required IOSink exportSink,
  }) async {
    String fileName = "e${name.clearEnumName().toFileName()}";
    String filePath = p.join(path, "enums", "$fileName.dart");
    exportSink.writeExport(
      path: "enums/$fileName.dart",
    );

    File file = File(filePath);
    await file.create(recursive: true);

    IOSink fileSink = file.openWrite(mode: FileMode.writeOnly);

    await generate(
      fileSink: fileSink,
    );

    await fileSink.flush();
    await fileSink.close();
  }
}

/// Extensions on [Iterable<SteamEnum>] to generate ffi code
extension SteamEnumIterableExtensions on Iterable<SteamEnum> {
  /// Creates a file for each [SteamEnum] and generates respective code
  Future<void> generateFile({
    required String path,
    required IOSink exportSink,
  }) async {
    for (SteamEnum steamEnum in this) {
      await steamEnum.generateFile(
        path: path,
        exportSink: exportSink,
      );
    }
  }
}
