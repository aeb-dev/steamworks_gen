import "steam_const.dart";
import "steam_enum.dart";
import "steam_field.dart";
import "steam_method.dart";

/// Struct and CallbackStruct definition for steam api
class SteamStruct {
  /// callback id of the callback struct, if it is not
  /// a callback struct this is filled with -1
  late int callbackId;

  /// list of [SteamField]s of the struct
  late List<SteamField> fields;

  /// list of [SteamMethod]s of the struct
  late List<SteamMethod> methods;

  /// name of the struct
  late String name;

  /// list of [SteamEnum]s of the struct
  late List<SteamEnum> enums;

  /// list of [SteamConst]s of the struct
  late List<SteamConst> consts;

  /// Creates a [SteamStruct]. This constructor is used
  /// for manual [SteamStruct] creation
  SteamStruct({
    required this.name,
    this.callbackId = -1,
    this.fields = const [],
    this.methods = const [],
    this.enums = const [],
    this.consts = const [],
  });

  /// Creates a [SteamStruct] from json
  SteamStruct.fromJson(Map<String, dynamic> json) {
    callbackId = json["callback_id"] ?? -1;
    fields = json["fields"]
        .map<SteamField>((dynamic v) => SteamField.fromJson(v))
        .toList();
    methods = json["methods"]
            ?.map<SteamMethod>(
              (dynamic v) => SteamMethod.fromJson(v),
            )
            ?.toList() ??
        [];
    name = json["struct"];
    enums = json["enums"]
            ?.map<SteamEnum>((dynamic v) => SteamEnum.fromJson(v))
            ?.toList() ??
        [];
    consts = json["consts"]
            ?.map<SteamConst>(
              (dynamic v) => SteamConst.fromJson(v),
            )
            ?.toList() ??
        [];
  }
}
