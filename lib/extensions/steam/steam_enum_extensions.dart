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
  Future<void> generate(IOSink fileSink) async {
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

    fileSink.writeTypedef(correctedName, "int");

    fileSink.writeEnum("${correctedName}Enum");
    fileSink.writeStartBlock();

    for (SteamEnumValue enumValue
        in values.where((val) => !val.name.contains("Force32Bit"))) {
      await enumValue.generate(fileSink, correctedName, indexOfCommonPartEnd);
    }

    fileSink.writeEndBlock();
  }

  Future<void> generateFile(String path) async {
    String fileName = name.toFileName();

    // TODO create enum without E. There is a struct that has the same name
    // when is E is subtracted, need to find a way to solve the conflict
    // before doing this
    String filePath = p.join(path, "enums", "$fileName.dart");
    File file = File(filePath);
    await file.create(recursive: true);

    IOSink fileSink = file.openWrite(mode: FileMode.writeOnly);

    await generate(fileSink);

    await fileSink.flush();
    await fileSink.close();
  }
}

/// Extensions on [Iterable<SteamEnum>] to generate ffi code
extension SteamEnumIterableExtensions on Iterable<SteamEnum> {
  /// Creates a file for each [SteamEnum] and generates respective code
  Future<void> generate(String path) async {
    for (SteamEnum steamEnum in this) {
      await steamEnum.generateFile(path);
    }
  }
}
