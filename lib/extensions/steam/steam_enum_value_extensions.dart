import "dart:io";

import "package:recase/recase.dart";

import "../../steam/steam_enum_value.dart";
import "../string_extensions.dart";

/// Extensions on [SteamEnumValue] to generate ffi code
extension SteamEnumValueExtensions on SteamEnumValue {
  /// Generates necessary code for a [SteamEnumValue]
  Future<void> generate({
    required IOSink fileSink,
    required String enumName,
    required int nameIndex,
  }) async {
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

    valueName = valueName.camelCase.fixDartConflict();
    fileSink.write("static const int $valueName = $value;");
  }
}
