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
  void generate({
    required IOSink fileSink,
  }) {
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

    fileSink.writeln(
      "// ignore_for_file: public_member_api_docs, always_specify_types, avoid_positional_boolean_parameters, avoid_classes_with_only_static_members, unreachable_switch_case",
    );
    fileSink.writeImport(packageName: "dart:ffi");
    fileSink.writeImport(
      packageName: "../unknown_enum_value_exception.dart",
    );
    fileSink.writeTypedef(
      alias: "${correctedName}AliasDart",
      of: "int",
    );

    fileSink.writeTypedef(
      alias: "${correctedName}AliasC",
      of: "Int32",
    );

    fileSink.writeEnum(
      enumName: correctedName,
    );
    fileSink.writeStartBlock();

    for (SteamEnumValue enumValue
        in values.where((val) => !val.name.contains("Force32Bit"))) {
      enumValue.generate(
        fileSink: fileSink,
        enumName: correctedName,
        nameIndex: indexOfCommonPartEnd,
      );
    }

    fileSink.writeln(";");

    fileSink.writeln("final int value;\n");

    fileSink.writeln("const $correctedName(this.value);\n");

    fileSink.write("factory $correctedName.fromValue(int value)");

    fileSink.writeStartBlock();

    fileSink.write("switch (value)");

    fileSink.writeStartBlock();

    for (SteamEnumValue enumValue
        in values.where((val) => !val.name.contains("Force32Bit"))) {
      enumValue.generateSwitch(
        fileSink: fileSink,
        enumName: correctedName,
        nameIndex: indexOfCommonPartEnd,
      );
    }

    fileSink.write(
      "default: throw UnknownEnumValueException(\"Unknown value for '$correctedName'. The value was: '\$value'\");",
    );

    fileSink.writeEndBlock();

    fileSink.writeEndBlock();

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

    generate(
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
