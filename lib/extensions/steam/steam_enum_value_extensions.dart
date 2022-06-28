import "dart:io";

import "package:recase/recase.dart";

import "../../steam/steam_enum_value.dart";
import "../string_extensions.dart";

/// Extensions on [SteamEnumValue] to generate ffi code
extension SteamEnumValueExtensions on SteamEnumValue {
  /// Generates necessary code for a [SteamEnumValue]
  void generate({
    required IOSink fileSink,
    required String enumName,
    required int nameIndex,
  }) {
    String valueName = _getValueName(
      enumName: enumName,
      nameIndex: nameIndex,
    );

    fileSink.write("$valueName($value),");
  }

  /// Generated necessary code for factory consturctor of [SteamEnumValue]
  /// in order to generate enum from a value
  void generateSwitch({
    required IOSink fileSink,
    required String enumName,
    required int nameIndex,
  }) {
    String valueName = _getValueName(
      enumName: enumName,
      nameIndex: nameIndex,
    );

    fileSink.write("case $value:");
    fileSink.write("return $enumName.$valueName;");
  }

  String _getValueName({
    required String enumName,
    required int nameIndex,
  }) {
    String valueName = name.substring(nameIndex).clearSteamNaming();
    int? valueAsInt = int.tryParse(valueName[0]);
    if (valueAsInt != null) {
      switch (enumName) {
        case "ESteamIpType":
        case "SteamIpType":
          valueName = "V$valueName";
          break;
        case "EHttpStatusCode":
        case "HttpStatusCode":
          valueName = "StatusCode$valueName";
          break;
        case "EDurationControlNotification":
        case "DurationControlNotification":
          valueName = "Duration$valueName";
          break;
        default:
          throw "What happened";
      }
    }

    return valueName.camelCase.fixDartConflict();
  }
}
