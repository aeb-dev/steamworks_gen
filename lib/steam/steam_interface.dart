import "steam_accessor.dart";
import "steam_enum.dart";
import "steam_field.dart";
import "steam_method.dart";

/// Interface definition for steam api
class SteamInterface {
  /// name of the interface
  late String name;

  /// version of the interface
  late String versionString;

  /// list of [SteamField]s of the interface
  late List<SteamField> fields;

  /// list of [SteamMethod]s of the interface
  late List<SteamMethod> methods;

  /// list of [SteamAccessor]s of the interface
  late List<SteamAccessor> accessors;

  /// list of [SteamEnum]s of the interface
  late List<SteamEnum> enums;

  /// Creates a [SteamInterface]. This constructor is used
  /// for manual [SteamInterface] creation
  SteamInterface({
    required this.name,
    this.versionString = "",
    this.fields = const [],
    this.methods = const [],
    this.accessors = const [],
    this.enums = const [],
  });

  /// Creates a [SteamInterface] from json
  SteamInterface.fromJson(Map<String, dynamic> json) {
    name = json["classname"];
    fields = json["fields"]
        .map<SteamField>((dynamic v) => SteamField.fromJson(v))
        .toList();
    methods = json["methods"]
        .map<SteamMethod>((dynamic v) => SteamMethod.fromJson(v))
        .toList();
    accessors = json["accessors"]
            ?.map<SteamAccessor>(
              (dynamic v) => SteamAccessor.fromJson(v),
            )
            ?.toList() ??
        [];
    versionString = json["version_string"] ?? "";
    enums = json["enums"]
            ?.map<SteamEnum>((dynamic v) => SteamEnum.fromJson(v))
            ?.toList() ??
        [];
  }
}
