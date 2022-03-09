import "steam_enum_value.dart";

/// Enum definition for steam api
class SteamEnum {
  /// name of the enum
  late String name;

  /// full qualified name of the enum
  String? fqName;

  /// List of values that enum holds
  late List<SteamEnumValue> values;

  /// Creates a [SteamEnum] from json
  SteamEnum.fromJson(Map<String, dynamic> json) {
    name = json["enumname"];
    fqName = json["fqname"];
    values = json["values"]
        .map<SteamEnumValue>((v) => SteamEnumValue.fromJson(v))
        .toList();
  }
}
