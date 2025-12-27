import "steam_const.dart";
import "steam_enum.dart";
import "steam_interface.dart";
import "steam_struct.dart";
import "steam_typedef.dart";

/// Holder class for steam_api.json
class SteamApi {
  /// List of callbacks in steam api definition
  late List<SteamStruct> callbackStructs;

  /// List of constants in steam api definition
  late List<SteamConst> consts;

  /// List of enums in steam api definition
  late List<SteamEnum> enums;

  /// List of interfaces in steam api definition
  late List<SteamInterface> interfaces;

  /// List of structs in steam api definition
  late List<SteamStruct> structs;

  /// List of typedef in steam api definition
  late List<SteamTypedef> typedefs;

  /// Creates a [SteamApi] from json
  SteamApi.fromJson(Map<String, dynamic> json) {
    callbackStructs = json["callback_structs"]
        .map<SteamStruct>((dynamic x) => SteamStruct.fromJson(x))
        .toList();

    consts = json["consts"]
        .map<SteamConst>((dynamic x) => SteamConst.fromJson(x))
        .toList();

    enums = json["enums"]
        .map<SteamEnum>((dynamic x) => SteamEnum.fromJson(x))
        .toList();

    interfaces = json["interfaces"]
        .map<SteamInterface>(
          (dynamic x) => SteamInterface.fromJson(x),
        )
        .toList();

    structs = json["structs"]
        .map<SteamStruct>((dynamic x) => SteamStruct.fromJson(x))
        .toList();

    typedefs = json["typedefs"]
        .map<SteamTypedef>((dynamic x) => SteamTypedef.fromJson(x))
        .toList();
  }
}
