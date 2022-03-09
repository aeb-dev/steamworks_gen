import "dart:io";

import "package:recase/recase.dart";

import "../../steam/steam_enum_value.dart";
import "../string_extensions.dart";

/// Extensions on [SteamEnumValue] to generate ffi code
extension SteamEnumValueExtensions on SteamEnumValue {
  /// Generates necessary code for a [SteamEnumValue]
  Future<void> generate(IOSink fileSink, String enumName, int nameIndex) async {
    String valueName = name.substring(nameIndex);
    int? valueAsInt = int.tryParse(valueName[0]);
    if (valueAsInt != null) {
      switch (enumName) {
        case "ESteamIpType":
          valueName = "V$valueName";
          break;
        case "EHttpStatusCode":
          valueName = "StatusCode$valueName";
          break;
        case "EDurationControlNotification":
          valueName = "Duration$valueName";
          break;
        default:
          throw "What happened";
      }
    }

    valueName = valueName.camelCase.fixDartConflict();
    fileSink.write("static const int $valueName = $value;");
  }
}
