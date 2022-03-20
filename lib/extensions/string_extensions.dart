import "package:recase/recase.dart";

/// Extensions for manipulating steam types with ease
extension StringExtensions on String {
  static const Set<String> _dartKeywords = {
    "abstract",
    "else",
    "import",
    "super",
    "as",
    "enum",
    "in",
    "switch",
    "assert",
    "export",
    "interface2",
    "sync",
    "async",
    "extends",
    "is",
    "this",
    "await",
    "extension",
    "library",
    "throw",
    "break",
    "external",
    "mixin",
    "true",
    "case",
    "factory",
    "new",
    "try",
    "catch",
    "false",
    "null",
    "typedef",
    "class",
    "final",
    "on",
    "var",
    "const",
    "finally",
    "operator",
    "void",
    "continue",
    "for",
    "part",
    "while",
    "covarient",
    "Function",
    "rethrow",
    "with",
    "default",
    "get",
    "return",
    "yield",
    "deffered",
    "hide",
    "set",
    "do",
    "if",
    "show",
    "dynamic",
    "implenets",
    "static",
    "late",
    "toString"
  };

  /// clears the const keyword or pointers on a string
  String clearPointerOrConst() => replaceAll(RegExp(r"(\*|&|const)"), "");

  /// clears the steam naming to make it more darty
  String clearSteamNaming() {
    String result = clearClassAccess();
    if (result == "m_pubParam") {
      return "paramPtr";
    } else if (result == "m_cubParam") {
      return "paramSize";
    } else if (result == "ullUniqueGameID") {
      return "uniqueGameId";
    } else if (result.startsWith("m_sz") &&
        result[4].toUpperCase() == result[4]) {
      result = result.replaceFirst("m_sz", "");
    } else if (result.startsWith("m_h") &&
        result[3].toUpperCase() == result[3]) {
      result = result.replaceFirst("m_h", "");
    } else if (result.startsWith("m_pp") &&
        result[4].toUpperCase() == result[4]) {
      result = result.replaceFirst("m_pp", "");
    } else if (result.startsWith("m_e") &&
        result[3].toUpperCase() == result[3]) {
      result = result.replaceFirst("m_e", "");
    } else if (result.startsWith("m_un") &&
        result[4].toUpperCase() == result[4]) {
      result = result.replaceFirst("m_un", "");
    } else if (result.startsWith("m_usec") &&
        result[6].toUpperCase() == result[6]) {
      result = result.replaceFirst("m_usec", "");
    } else if (result.startsWith("m_us") &&
        result[4].toUpperCase() == result[4]) {
      result = result.replaceFirst("m_us", "");
    } else if (result.startsWith("m_ull") &&
        result[5].toUpperCase() == result[5]) {
      result = result.replaceFirst("m_ull", "");
    } else if (result.startsWith("m_ul") &&
        result[4].toUpperCase() == result[4]) {
      result = result.replaceFirst("m_ul", "");
    } else if (result.startsWith("m_u") &&
        result[3].toUpperCase() == result[3]) {
      result = result.replaceFirst("m_u", "");
    } else if (result.startsWith("m_fl") &&
        result[4].toUpperCase() == result[4]) {
      result = result.replaceFirst("m_fl", "");
    } else if (result.startsWith("m_b") &&
        result[3].toUpperCase() == result[3]) {
      result = result.replaceFirst("m_b", "");
    } else if (result.startsWith("m_i") &&
        result[3].toUpperCase() == result[3]) {
      result = result.replaceFirst("m_i", "");
    } else if (result.startsWith("m_pub") &&
        result[5].toUpperCase() == result[5]) {
      result = result.replaceFirst("m_pub", "");
    } else if (result.startsWith("m_cub") &&
        result[5].toUpperCase() == result[5]) {
      result = result.replaceFirst("m_cub", "");
    } else if (result.startsWith("m_n") &&
        result[3].toUpperCase() == result[3]) {
      result = result.replaceFirst("m_n", "");
    } else if (result.startsWith("m_rtime") &&
        result.length > 7 &&
        result[7].toUpperCase() == result[7]) {
      result = result.replaceFirst("m_rtime", "Time");
    } else if (result.startsWith("m_rgch") &&
        result[6].toUpperCase() == result[6]) {
      result = result.replaceFirst("m_rgch", "");
    } else if (result.startsWith("m_rgub") &&
        result[6].toUpperCase() == result[6]) {
      result = result.replaceFirst("m_rgub", "");
    } else if (result.startsWith("m_rgf") &&
        result[5].toUpperCase() == result[5]) {
      result = result.replaceFirst("m_rgf", "");
    } else if (result.startsWith("m_pch") &&
        result[5].toUpperCase() == result[5]) {
      result = result.replaceFirst("m_pch", "");
    } else if (result.startsWith("m_cch") &&
        result[5].toUpperCase() == result[5]) {
      result = result.replaceFirst("m_cch", "");
    } else if (result.startsWith("m_rg") &&
        result[4].toUpperCase() == result[4]) {
      result = result.replaceFirst("m_rg", "");
    } else if (result.startsWith("m_rt") &&
        result[4].toUpperCase() == result[4]) {
      result = result.replaceFirst("m_rt", "");
    } else if (result.startsWith("m_r") &&
        result[3].toUpperCase() == result[3]) {
      result = result.replaceFirst("m_r", "");
    } else if (result.startsWith("m_cday") &&
        result[6].toUpperCase() == result[6]) {
      result = result.replaceFirst("m_cday", "");
    } else if (result.startsWith("m_cb") &&
        result[4].toUpperCase() == result[4]) {
      result = result.replaceFirst("m_cb", "");
      if (!result.contains("Size")) {
        result += "Size";
      }
    } else if (result.startsWith("m_c") &&
        result[3].toUpperCase() == result[3]) {
      result = result.replaceFirst("m_c", "");
    } else if (result.startsWith("m_")) {
      result = result.replaceFirst("m_", "");
    } else if (result.startsWith("t_")) {
      result = result.replaceFirst("t_", "");
    } else if (result.endsWith("_t")) {
      result = result.replaceFirst("_t", "");
    } else if (result.startsWith("k_") &&
        result[2].toUpperCase() == result[2]) {
      result = result.replaceFirst("k_", "");
    } else if (result.startsWith("b") && result[1].toUpperCase() == result[1]) {
      result = result.replaceFirst("b", "");
    } else if (result.startsWith("e") && result[1].toUpperCase() == result[1]) {
      result = result.replaceFirst("e", "");
    } else if (result.startsWith("pch") &&
        result[3].toUpperCase() == result[3]) {
      result = result.replaceFirst("pch", "");
    } else if (result.startsWith("un") &&
        result[2].toUpperCase() == result[2]) {
      result = result.replaceFirst("un", "");
    } else if (result.startsWith("us") &&
        result[2].toUpperCase() == result[2]) {
      result = result.replaceFirst("us", "");
    } else if (result.startsWith("pfl") &&
        result[3].toUpperCase() == result[3]) {
      result = result.replaceFirst("pfl", "");
    } else if (result.startsWith("fl") &&
        result[2].toUpperCase() == result[2]) {
      result = result.replaceFirst("fl", "");
    } else if (result.startsWith("BIs")) {
      result = result.replaceFirst("BIs", "is");
    }

    // m_c, cPlayersMax, cPlayers, enum, flPageScale, eresult

    result = result.replaceAll("_", "");

    result = result.replaceAll("servernetadr", "ServerNetAdr");
    result = result.replaceAll("gameserveritem", "GameServerItem");

    result = result.replaceAll("ID", "Id");
    result = result.replaceAll("HTTP", "Http");
    result = result.replaceAll("P2P", "P2p");
    result = result.replaceAll("SNet", "Snet");
    result = result.replaceAll("API", "Api");
    result = result.replaceAll("LED", "Led");
    result = result.replaceAll("IPC", "Ipc");
    result = result.replaceAll("IP", "Ip");
    result = result.replaceAll("UGC", "Ugc");
    result = result.replaceAll("FPS", "Fps");
    result = result.replaceAll("IPC", "Ipc");
    result = result.replaceAll("PSN", "Psn");
    result = result.replaceAll("PS", "Ps");
    result = result.replaceAll("EULA", "Eula");
    result = result.replaceAll("URL", "Url");
    result = result.replaceAll("HTML", "Html");
    result = result.replaceAll("OPF", "Opf");
    result = result.replaceAll("GS", "Gs");
    result = result.replaceAll("JS", "Js");
    result = result.replaceAll("VR", "Vr");
    result = result.replaceAll("UDP", "Udp");
    result = result.replaceAll("POP", "Pop");
    result = result.replaceAll("ICE", "Ice");
    result = result.replaceAll("NAT", "Nat");
    result = result.replaceAll("CEG", "Ceg");
    result = result.replaceAll("IPT", "Ipt");
    result = result.replaceAll("SSA", "Ssa");
    result = result.replaceAll("SDR", "Sdr");
    result = result.replaceAll("DELETED", "Deleted");

    return result;
  }

  /// clears c++ class acccess(::)
  String clearClassAccess() {
    int index = lastIndexOf(":");
    if (index != -1) {
      return substring(index + 1);
    }

    return this;
  }

  /// converts a steam name to proper dart file name
  String toFileName() => clearSteamNaming().snakeCase;

  /// clears prefix I from interfaces
  String clearInterfaceName() {
    if (this[0] == "I" || this[0] == "i") {
      return substring(1);
    }

    return this;
  }

  /// clears prefix E from enums
  String clearEnumName() {
    if (this[0] == "E" || this[0] == "e") {
      return substring(1);
    }

    return this;
  }

  /// convert a steam type to a string that is usable for
  /// dart functions
  String toDartType() {
    String result = this;
    switch (result) {
      case "void *":
        result = "Pointer<Void>";
        break;

      case "void":
        result = "void";
        break;

      case "bool":
        result = "bool";
        break;

      case "unsigned char":
      case "signed char":
      case "short":
      case "unsigned short":
      case "int":
      case "unsigned int":
      case "long long":
      case "unsigned long long":
      case "intp":
      case "uint32":
      case "uint16":
      case "int32":
      case "int32_t":
      case "int64":
      case "int64_t":
      case "uint64":
      case "int16":
      case "int8":
      case "uint8":
      case "char":
        result = "int";
        break;
      case "float":
      case "double":
        result = "double";
        break;
      case "char [1024]":
        result = "String";
        break;

      default:
        break;
    }

    return result.clearSteamNaming();
  }

  // TODO: parse type to create function instead of putting
  // everything under a switch. This is also true for
  // toNativeTypeAnnotation, toNativeFunctionType

  /// convert a steam type to a string that is usable for
  /// dart counterpart of ffi functions
  String toNativeType() {
    String type = clearClassAccess();
    switch (type) {
      case "void":
        type = "void";
        break;
      case "bool":
        type = "bool";
        break;
      case "size_t":
      case "unsigned char":
      case "signed char":
      case "short":
      case "unsigned short":
      case "int":
      case "unsigned int":
      case "long long":
      case "unsigned long long":
      case "intp":
      case "uintp":
      case "uint32":
      case "uint32_t":
      case "uint16":
      case "uint16_t":
      case "int32":
      case "int32_t":
      case "uint":
      case "int64":
      case "int64_t":
      case "uint64":
      case "uint64_t":
      case "int16":
      case "int16_t":
      case "int8":
      case "int8_t":
      case "uint8":
      case "uint8_t":
      case "char":
      case "intptr_t":
        type = "int";
        break;
      case "float":
      case "double":
        type = "double";
        break;

      // arrays
      case "uint8 [16]":
      case "uint8 [20]":
      case "uint8 [512]":
        type = "Array<UnsignedChar>";
        break;
      case "uint16 [8]":
        type = "Array<UnsignedShort>";
        break;
      case "uint32 [10]":
      case "uint32 [16]":
      case "uint32 [50]":
      case "uint32 [63]":
      case "AppId_t [32]":
        type = "Array<UnsignedInt>";
        break;
      case "PublishedFileId_t [50]":
      case "CSteamID [50]":
        type = "Array<UnsignedLongLong>";
        break;
      case "float [50]":
        type = "Array<Float>";
        break;

      // pointers
      case "void *":
      case "const void *":
        type = "Pointer<Void>";
        break;
      case "bool *":
        type = "Pointer<Bool>";
        break;
      case "size_t *":
        type = "Pointer<Size>";
        break;
      case "int &":
      case "int *":
      case "const int *":
      case "int32 *":
      case "const int32 *":
        type = "Pointer<Int>";
        break;
      case "int64 *":
        type = "Pointer<LongLong>";
        break;
      case "uint8 *":
      case "const uint8 *":
        type = "Pointer<UnsignedChar>";
        break;
      case "uint16 *":
      case "const uint16 *":
        type = "Pointer<UnsignedShort>";
        break;
      case "float *":
        type = "Pointer<Float>";
        break;
      case "double *":
        type = "Pointer<Double>";
        break;
      case "char *":
      case "char [4]":
      case "char [32]":
      case "char [64]":
      case "char [128]":
      case "char [129]":
      case "char [240]":
      case "char [256]":
      case "char [260]":
      case "char [512]":
      case "char [1024]":
      case "char [1025]":
      case "char [2048]":
      case "char [8000]":
      case "const char *":
        type = "Pointer<Utf8>";
        break;
      case "char **":
      case "const char **":
        type = "Pointer<Pointer<Utf8>>";
        break;
      case "const servernetadr_t &":
        type = "Pointer<ServerNetAdr>";
        break;
      case "SteamNetworkingIPAddr *":
      case "SteamNetworkingIPAddr &":
      case "const SteamNetworkingIPAddr *":
      case "const SteamNetworkingIPAddr &":
        type = "Pointer<SteamNetworkingIPAddr>";
        break;
      case "SteamNetworkingIdentity *":
      case "const SteamNetworkingIdentity &":
      case "const SteamNetworkingIdentity *":
        type = "Pointer<SteamNetworkingIdentity>";
        break;
      case "FriendGameInfo_t *":
        type = "Pointer<FriendGameInfo>";
        break;
      case "LeaderboardEntry_t *":
        type = "Pointer<LeaderboardEntry>";
        break;
      case "SteamParamStringArray_t *":
      case "const SteamParamStringArray_t *":
        type = "Pointer<SteamParamStringArray>";
        break;
      case "SteamPartyBeaconLocation_t *":
        type = "Pointer<SteamPartyBeaconLocation>";
        break;
      case "P2PSessionState_t *":
        type = "Pointer<P2PSessionState>";
        break;
      case "SteamUGCDetails_t *":
        type = "Pointer<SteamUGCDetails>";
        break;
      case "SteamIPAddress_t *":
      case "const SteamIPAddress_t &":
        type = "Pointer<SteamIPAddress>";
        break;
      case "SteamNetworkingMessage_t *":
        type = "Pointer<SteamNetworkingMessage>";
        break;
      case "SteamNetworkingMessage_t **":
      case "SteamNetworkingMessage_t *const *":
        type = "Pointer<Pointer<SteamNetworkingMessage>>";
        break;
      case "SteamNetworkPingLocation_t &":
      case "const SteamNetworkPingLocation_t &":
        type = "Pointer<SteamNetworkPingLocation>";
        break;
      case "SteamItemDetails_t *":
        type = "Pointer<SteamItemDetails>";
        break;
      case "MatchMakingKeyValuePair_t **":
        type = "Pointer<Pointer<MatchMakingKeyValuePair>>";
        break;
      case "gameserveritem_t *":
      case "gameserveritem_t &":
        type = "Pointer<GameServerItem>";
        break;
      case "SteamNetConnectionInfo_t *":
        type = "Pointer<SteamNetConnectionInfo>";
        break;
      case "SteamNetConnectionRealTimeStatus_t *":
        type = "Pointer<SteamNetConnectionRealTimeStatus>";
        break;
      case "SteamNetworkingConfigValue_t *":
      case "const SteamNetworkingConfigValue_t *":
      case "const SteamNetworkingConfigValue_t &":
        type = "Pointer<SteamNetworkingConfigValue>";
        break;
      case "SteamNetConnectionRealTimeLaneStatus_t *":
        type = "Pointer<SteamNetConnectionRealTimeLaneStatus>";
        break;
      case "SteamNetAuthenticationStatus_t *":
        type = "Pointer<SteamNetAuthenticationStatus>";
        break;
      case "SteamNetworkingFakeIPResult_t *":
        type = "Pointer<SteamNetworkingFakeIPResult>";
        break;
      case "SteamRelayNetworkStatus_t *":
        type = "Pointer<SteamRelayNetworkStatus>";
        break;
      case "SteamDatagramRelayAuthTicket *":
        type = "Pointer<SteamDatagramRelayAuthTicket>";
        break;
      case "SteamDatagramGameCoordinatorServerLogin *":
        type = "Pointer<SteamDatagramGameCoordinatorServerLogin>";
        break;
      case "SteamDatagramHostedAddress *":
        type = "Pointer<SteamDatagramHostedAddress>";
        break;
      case "CallbackMsg_t *":
        type = "Pointer<CallbackMsg>";
        break;
      case "ISteamMatchmaking *":
        type = "Pointer<SteamMatchmaking>";
        break;
      case "ISteamMatchmakingServers *":
        type = "Pointer<SteamMatchmakingServers>";
        break;
      case "ISteamMatchmakingServerListResponse *":
        type = "Pointer<SteamMatchmakingServerListResponse>";
        break;
      case "ISteamUser *":
        type = "Pointer<SteamUser>";
        break;
      case "ISteamFriends *":
        type = "Pointer<SteamFriends>";
        break;
      case "ISteamUtils *":
        type = "Pointer<SteamUtils>";
        break;
      case "ISteamUserStats *":
        type = "Pointer<SteamUserStats>";
        break;
      case "ISteamGameServerStats *":
        type = "Pointer<SteamGameServerStats>";
        break;
      case "ISteamRemoteStorage *":
        type = "Pointer<SteamRemoteStorage>";
        break;
      case "ISteamGameServer *":
        type = "Pointer<SteamGameServer>";
        break;
      case "ISteamNetworking *":
        type = "Pointer<SteamNetworking>";
        break;
      case "ISteamApps *":
        type = "Pointer<SteamApps>";
        break;
      case "ISteamScreenshots *":
        type = "Pointer<SteamScreenshots>";
        break;
      case "ISteamVideo *":
        type = "Pointer<SteamVideo>";
        break;
      case "ISteamGameSearch *":
        type = "Pointer<SteamGameSearch>";
        break;
      case "ISteamHTTP *":
        type = "Pointer<SteamHTTP>";
        break;
      case "ISteamController *":
        type = "Pointer<SteamController>";
        break;
      case "ISteamUGC *":
        type = "Pointer<SteamUGC>";
        break;
      case "ISteamAppList *":
        type = "Pointer<SteamAppList>";
        break;
      case "ISteamMusic *":
        type = "Pointer<SteamMusic>";
        break;
      case "ISteamHTMLSurface *":
        type = "Pointer<SteamHTMLSurface>";
        break;
      case "ISteamInventory *":
        type = "Pointer<SteamInventory>";
        break;
      case "ISteamParentalSettings *":
        type = "Pointer<SteamParentalSettings>";
        break;
      case "ISteamInput *":
        type = "Pointer<SteamInput>";
        break;
      case "ISteamRemotePlay *":
        type = "Pointer<SteamRemotePlay>";
        break;
      case "ISteamMatchmakingPlayersResponse *":
        type = "Pointer<SteamMatchmakingPlayersResponse>";
        break;
      case "ISteamMatchmakingPingResponse *":
        type = "Pointer<SteamMatchmakingPingResponse>";
        break;
      case "ISteamNetworkingFakeUDPPort *":
        type = "Pointer<SteamNetworkingFakeUDPPort>";
        break;
      case "ISteamNetworkingSignalingRecvContext *":
        type = "Pointer<SteamNetworkingSignalingRecvContext>";
        break;
      case "ISteamNetworkingConnectionSignaling *":
        type = "Pointer<SteamNetworkingConnectionSignaling>";
        break;
      case "ISteamMatchmakingRulesResponse *":
        type = "Pointer<SteamMatchmakingRulesResponse>";
        break;
      case "ISteamMusicRemote *":
        type = "Pointer<SteamMusicRemote>";
        break;
      case "ISteamParties *":
        type = "Pointer<SteamParties>";
        break;
      case "AppId_t *":
      case "DepotId_t *":
      case "uint32 *":
      case "const uint32 *":
      case "SNetSocket_t *":
      case "SteamNetworkingPOPID *":
      case "HSteamNetConnection *":
        type = "Pointer<UnsignedInt>";
        break;
      case "uint64 *":
      case "ControllerHandle_t *":
      case "ControllerActionSetHandle_t *":
      case "CSteamID *":
      case "CGameID *":
      case "SteamAPICall_t *":
      case "InputActionSetHandle_t *":
      case "PublishedFileId_t *":
      case "InputHandle_t *":
      case "SteamItemInstanceID_t *":
      case "const SteamItemInstanceID_t *":
        type = "Pointer<UnsignedLongLong>";
        break;
      case "ControllerActionOrigin *":
      case "EControllerActionOrigin *":
      case "EChatEntryType *":
      case "EItemPreviewType *":
      case "ERemoteStorageFilePathType *":
      case "ERemoteStorageLocalFileChange *":
      case "ESteamNetworkingConfigDataType *":
      case "EInputActionOrigin *":
      case "ESteamNetworkingConfigScope *":
      case "SteamInventoryResult_t *":
      case "SteamItemDef_t *":
      case "const SteamItemDef_t *":
      case "HSteamPipe *":
        type = "Pointer<Int32>";
        break;
      case "SteamNetworkingErrMsg &":
        type = "Pointer<Pointer<Utf8>>";
        break;
      case "void (*)(SteamNetworkingMessage_t *)":
        type =
            "Pointer<NativeFunction<Pointer<Void> Function(Pointer<SteamNetworkingMessage>)>>";
        break;

      // enums, typedefs, structs
      default:
        break;

      // return clearSteamNaming().clearEnumName();
      // return type.clearSteamNaming();
    }

    return type.clearSteamNaming();
  }

  /// convert a steam type to a string that is usable for
  /// struct annotations
  String toNativeTypeAnnotation() {
    String type = clearClassAccess();
    switch (type) {
      case "void":
        type = "Void()";
        break;
      case "bool":
        type = "Bool()";
        break;
      case "size_t":
        type = "Size()";
        break;
      case "char":
        type = "Char()";
        break;
      case "uint8_t":
        type = "Uint8()";
        break;
      case "uint8":
      case "unsigned char":
        type = "UnsignedChar()";
        break;
      case "int8_t":
        type = "Int8()";
        break;
      case "int8":
      case "signed char":
        type = "SignedChar()";
        break;
      case "int16_t":
        type = "Int16()";
        break;
      case "int16":
      case "short":
        type = "Short()";
        break;
      case "uint16_t":
        type = "Uint16()";
        break;
      case "uint16":
      case "unsigned short":
        type = "UnsignedShort()";
        break;
      case "int32_t":
        type = "Int32()";
        break;
      case "int32":
      case "int":
        type = "Int()";
        break;
      case "uint32_t":
        type = "Uint32()";
        break;
      case "uint32":
      case "unsigned int":
        type = "UnsignedInt()";
        break;
      case "int64_t":
        type = "Int64()";
        break;
      case "int64":
      case "long long":
        type = "LongLong()";
        break;
      case "uint64_t":
        type = "Uint64()";
        break;
      case "unsigned long long":
      case "uint64":
        type = "UnsignedLongLong()";
        break;
      case "intp":
        type = "LongLong()";
        break;
      case "uintp":
        type = "UnsignedLongLong()";
        break;
      case "intptr_t":
        type = "IntPtr()";
        break;
      case "float":
        type = "Float()";
        break;
      case "double":
        type = "Double()";
        break;

      // arrays
      case "uint8 [16]":
        type = "Array<UnsignedChar>(16)";
        break;
      case "uint8 [20]":
        type = "Array<UnsignedChar>(20)";
        break;
      case "uint8 [512]":
        type = "Array<UnsignedChar>(512)";
        break;
      case "uint16 [8]":
        type = "Array<UnsignedShort>(8)";
        break;
      case "uint32 [10]":
        type = "Array<UnsignedInt>(10)";
        break;
      case "uint32 [16]":
        type = "Array<UnsignedInt>(16)";
        break;
      case "uint32 [50]":
        type = "Array<UnsignedInt>(50)";
        break;
      case "uint32 [63]":
        type = "Array<UnsignedInt>(63)";
        break;
      case "AppId_t [32]":
        type = "Array<UnsignedInt>(32)";
        break;
      case "PublishedFileId_t [50]":
      case "CSteamID [50]":
        type = "Array<UnsignedLongLong>(50)";
        break;
      case "float [50]":
        type = "Array<Float>(50)";
        break;

      // pointers, structs
      case "void *":
      case "const void *":
      case "bool *":
      case "size_t *":
      case "int &":
      case "int *":
      case "const int *":
      case "int32 *":
      case "const int32 *":
      case "int64 *":
      case "uint8 *":
      case "const uint8 *":
      case "uint16 *":
      case "const uint16 *":
      case "float *":
      case "double *":
      case "char *":
      case "char [4]":
      case "char [32]":
      case "char [64]":
      case "char [128]":
      case "char [129]":
      case "char [240]":
      case "char [256]":
      case "char [260]":
      case "char [512]":
      case "char [1024]":
      case "char [1025]":
      case "char [2048]":
      case "char [8000]":
      case "const char *":
      case "char **":
      case "const char **":
      case "SteamNetworkingIdentity *":
      case "const SteamNetworkingIdentity &":
      case "const SteamNetworkingIdentity *":
      case "FriendGameInfo_t *":
      case "const servernetadr_t &":
      case "SteamNetworkingIPAddr *":
      case "SteamNetworkingIPAddr &":
      case "const SteamNetworkingIPAddr *":
      case "const SteamNetworkingIPAddr &":
      case "LeaderboardEntry_t *":
      case "SteamParamStringArray_t *":
      case "const SteamParamStringArray_t *":
      case "SteamPartyBeaconLocation_t *":
      case "P2PSessionState_t *":
      case "SteamUGCDetails_t *":
      case "SteamIPAddress_t *":
      case "const SteamIPAddress_t &":
      case "SteamNetworkingMessage_t *":
      case "SteamNetworkingMessage_t **":
      case "SteamNetworkingMessage_t *const *":
      case "SteamNetworkPingLocation_t &":
      case "const SteamNetworkPingLocation_t &":
      case "SteamItemDetails_t *":
      case "MatchMakingKeyValuePair_t **":
      case "gameserveritem_t *":
      case "gameserveritem_t &":
      case "SteamNetConnectionInfo_t *":
      case "SteamNetConnectionRealTimeStatus_t *":
      case "SteamNetworkingConfigValue_t *":
      case "const SteamNetworkingConfigValue_t *":
      case "const SteamNetworkingConfigValue_t &":
      case "SteamNetConnectionRealTimeLaneStatus_t *":
      case "SteamNetAuthenticationStatus_t *":
      case "SteamNetworkingFakeIPResult_t *":
      case "SteamRelayNetworkStatus_t *":
      case "SteamDatagramRelayAuthTicket *":
      case "SteamDatagramGameCoordinatorServerLogin *":
      case "SteamDatagramHostedAddress *":
      case "CallbackMsg_t *":
      case "ISteamMatchmaking *":
      case "ISteamMatchmakingServers *":
      case "ISteamMatchmakingServerListResponse *":
      case "ISteamUser *":
      case "ISteamFriends *":
      case "ISteamUtils *":
      case "ISteamUserStats *":
      case "ISteamGameServerStats *":
      case "ISteamRemoteStorage *":
      case "ISteamGameServer *":
      case "ISteamNetworking *":
      case "ISteamApps *":
      case "ISteamScreenshots *":
      case "ISteamVideo *":
      case "ISteamGameSearch *":
      case "ISteamHTTP *":
      case "ISteamController *":
      case "ISteamUGC *":
      case "ISteamAppList *":
      case "ISteamMusic *":
      case "ISteamHTMLSurface *":
      case "ISteamInventory *":
      case "ISteamParentalSettings *":
      case "ISteamInput *":
      case "ISteamRemotePlay *":
      case "ISteamMatchmakingPlayersResponse *":
      case "ISteamMatchmakingPingResponse *":
      case "ISteamNetworkingFakeUDPPort *":
      case "ISteamNetworkingSignalingRecvContext *":
      case "ISteamNetworkingConnectionSignaling *":
      case "ISteamMatchmakingRulesResponse *":
      case "ISteamMusicRemote *":
      case "ISteamParties *":
      case "AppId_t *":
      case "DepotId_t *":
      case "uint32 *":
      case "const uint32 *":
      case "SNetSocket_t *":
      case "SteamNetworkingPOPID *":
      case "HSteamNetConnection *":
      case "uint64 *":
      case "ControllerHandle_t *":
      case "ControllerActionOrigin *":
      case "ControllerActionSetHandle_t *":
      case "EControllerActionOrigin *":
      case "EChatEntryType *":
      case "EItemPreviewType *":
      case "ERemoteStorageFilePathType *":
      case "ERemoteStorageLocalFileChange *":
      case "ESteamNetworkingConfigDataType *":
      case "EInputActionOrigin *":
      case "ESteamNetworkingConfigScope *":
      case "SteamInventoryResult_t *":
      case "SteamItemDef_t *":
      case "const SteamItemDef_t *":
      case "HSteamPipe *":
      case "SteamNetworkingErrMsg &":
      case "CSteamID *":
      case "CGameID *":
      case "SteamAPICall_t *":
      case "InputActionSetHandle_t *":
      case "PublishedFileId_t *":
      case "InputHandle_t *":
      case "SteamItemInstanceID_t *":
      case "const SteamItemInstanceID_t *":
      case "SteamDatagramHostedAddress":
      case "SteamNetworkingIPAddr":
      case "SteamNetworkingIdentity":
      case "servernetadr_t":
      case "SteamUGCDetails_t":
      case "SteamNetConnectionInfo_t":
      case "InputAnalogActionData_t":
      case "InputMotionData_t":
      case "FriendGameInfo_t":
      case "SteamIPAddress_t":
      case "AnalogAction_t":
      case "InputDigitalActionData_t":
      case "void (*)(SteamNetworkingMessage_t *)":
        type = "";
        break;

      // enums
      case "EFailureType":
      case "PlayerAcceptState_t":
      case "ESteamIPType":
      case "EUniverse":
      case "EResult":
      case "EVoiceResult":
      case "EDenyReason":
      case "EBeginAuthSessionResult":
      case "EAuthSessionResponse":
      case "EUserHasLicenseForAppResult":
      case "EAccountType":
      case "EChatEntryType":
      case "EChatRoomEnterResponse":
      case "EChatSteamIDInstanceFlags":
      case "ENotificationPosition":
      case "EBroadcastUploadResult":
      case "EMarketNotAllowedReasonFlags":
      case "EDurationControlProgress":
      case "EDurationControlNotification":
      case "EDurationControlOnlineState":
      case "EGameSearchErrorCode_t":
      case "EPlayerResult_t":
      case "ESteamIPv6ConnectivityProtocol":
      case "ESteamIPv6ConnectivityState":
      case "EFriendRelationship":
      case "EPersonaState":
      case "EFriendFlags":
      case "EUserRestriction":
      case "EOverlayToStoreFlag":
      case "EActivateGameOverlayToWebPageMode":
      case "EPersonaChange":
      case "ESteamAPICallFailure":
      case "EGamepadTextInputMode":
      case "EGamepadTextInputLineMode":
      case "EFloatingGamepadTextInputMode":
      case "ETextFilteringContext":
      case "ECheckFileSignature":
      case "EMatchMakingServerResponse":
      case "ELobbyType":
      case "ELobbyComparison":
      case "ELobbyDistanceFilter":
      case "EChatMemberStateChange":
      case "ESteamPartyBeaconLocationType":
      case "ESteamPartyBeaconLocationData":
      case "ERemoteStoragePlatform":
      case "ERemoteStoragePublishedFileVisibility":
      case "EWorkshopFileType":
      case "EWorkshopVote":
      case "EWorkshopFileAction":
      case "EWorkshopEnumerationType":
      case "EWorkshopVideoProvider":
      case "EUGCReadAction":
      case "ERemoteStorageLocalFileChange":
      case "ERemoteStorageFilePathType":
      case "ELeaderboardDataRequest":
      case "ELeaderboardSortMethod":
      case "ELeaderboardDisplayType":
      case "ELeaderboardUploadScoreMethod":
      case "ERegisterActivationCodeResult":
      case "EP2PSessionError":
      case "EP2PSend":
      case "ESNetSocketState":
      case "ESNetSocketConnectionType":
      case "EVRScreenshotType":
      case "AudioPlayback_Status":
      case "EHTTPMethod":
      case "EHTTPStatusCode":
      case "EInputSourceMode":
      case "EInputActionOrigin":
      case "EXboxOrigin":
      case "ESteamControllerPad":
      case "EControllerHapticLocation":
      case "EControllerHapticType":
      case "ESteamInputType":
      case "ESteamInputConfigurationEnableType":
      case "ESteamInputLEDFlag":
      case "ESteamInputGlyphSize":
      case "ESteamInputGlyphStyle":
      case "ESteamInputActionEventType":
      case "EControllerActionOrigin":
      case "ESteamControllerLEDFlag":
      case "EUGCMatchingUGCType":
      case "EUserUGCList":
      case "EUserUGCListSortOrder":
      case "EUGCQuery":
      case "EItemUpdateStatus":
      case "EItemState":
      case "EItemStatistic":
      case "EItemPreviewType":
      case "ESteamItemFlags":
      case "EParentalFeature":
      case "ESteamDeviceFormFactor":
      case "ESteamNetworkingAvailability":
      case "ESteamNetworkingIdentityType":
      case "ESteamNetworkingFakeIPType":
      case "ESteamNetworkingConnectionState":
      case "ESteamNetConnectionEnd":
      case "ESteamNetworkingConfigScope":
      case "ESteamNetworkingConfigDataType":
      case "ESteamNetworkingConfigValue":
      case "ESteamNetworkingGetConfigValueResult":
      case "ESteamNetworkingSocketsDebugOutputType":
      case "EServerMode":
      case "EHTMLMouseButton":
      case "EMouseCursor":
      case "EHTMLKeyModifiers":
        type = "Int32()";
        break;

      // typedefs
      case "HSteamPipe":
      case "HSteamUser":
      case "HServerQuery":
      case "SteamItemDef_t":
      case "SteamInventoryResult_t":
        type = "Int()";
        break;
      case "FriendsGroupID_t":
        type = "Short()";
        break;
      case "AppId_t":
      case "DepotId_t":
      case "RTime32":
      case "AccountID_t":
      case "HAuthTicket":
      case "SNetSocket_t":
      case "SNetListenSocket_t":
      case "ScreenshotHandle":
      case "HTTPRequestHandle":
      case "HTTPCookieContainerHandle":
      case "HHTMLBrowser":
      case "RemotePlaySessionID_t":
      case "HSteamNetConnection":
      case "HSteamListenSocket":
      case "HSteamNetPollGroup":
      case "SteamNetworkingPOPID":
        type = "UnsignedInt()";
        break;
      case "CSteamID":
      case "CGameID":
        type = "UnsignedLongLong()";
        break;
      case "SteamAPICall_t":
      case "PartyBeaconID_t":
      case "UGCHandle_t":
      case "PublishedFileUpdateHandle_t":
      case "PublishedFileId_t":
      case "UGCFileWriteStreamHandle_t":
      case "SteamLeaderboard_t":
      case "SteamLeaderboardEntries_t":
      case "InputHandle_t":
      case "InputActionSetHandle_t":
      case "InputDigitalActionHandle_t":
      case "InputAnalogActionHandle_t":
      case "ControllerHandle_t":
      case "ControllerActionSetHandle_t":
      case "ControllerDigitalActionHandle_t":
      case "ControllerAnalogActionHandle_t":
      case "UGCQueryHandle_t":
      case "UGCUpdateHandle_t":
      case "SteamItemInstanceID_t":
      case "SteamInventoryUpdateHandle_t":
        type = "UnsignedLongLong()";
        break;
      case "SteamNetworkingMicroseconds":
        type = "LongLong()";
        break;
      case "HServerListRequest":
        type = "Pointer<Void>";
        break;
      case "SteamNetworkingErrMsg":
        type = "Pointer<Utf8>";
        break;

      default:
        break;
      // return type.clearSteamNaming();
    }

    return type.clearSteamNaming();
  }

  /// convert a steam type to a string that is usable for
  /// native counterpart ffi functions
  String toNativeFunctionType() {
    String type = clearClassAccess();
    switch (type) {
      case "void":
        type = "Void";
        break;
      case "bool":
        type = "Bool";
        break;
      case "size_t":
        type = "Size";
        break;
      case "char":
        type = "Char";
        break;
      case "uint8_t":
        type = "Uint8";
        break;
      case "uint8":
      case "unsigned char":
        type = "UnsignedChar";
        break;
      case "int8_t":
        type = "Int8";
        break;
      case "int8":
      case "signed char":
        type = "SignedChar";
        break;
      case "int16_t":
        type = "Int16";
        break;
      case "int16":
      case "short":
        type = "Short";
        break;
      case "uint16_t":
        type = "Uint16";
        break;
      case "uint16":
      case "unsigned short":
        type = "UnsignedShort";
        break;
      case "int32_t":
        type = "Int32";
        break;
      case "int32":
      case "int":
        type = "Int";
        break;
      case "uint32_t":
        type = "Uint32";
        break;
      case "uint32":
      case "unsigned int":
        type = "UnsignedInt";
        break;
      case "int64_t":
        type = "Int64";
        break;
      case "int64":
      case "long long":
        type = "LongLong";
        break;
      case "uint64_t":
        type = "Uint64";
        break;
      case "unsigned long long":
      case "uint64":
        type = "UnsignedLongLong";
        break;
      case "intp":
        type = "LongLong";
        break;
      case "uintp":
        type = "UnsignedLongLong";
        break;
      case "intptr_t":
        type = "IntPtr";
        break;
      case "float":
        type = "Float";
        break;
      case "double":
        type = "Double";
        break;

      // arrays
      case "uint8 [16]":
      case "uint8 [20]":
      case "uint8 [512]":
        type = "Array<UnsignedChar>";
        break;
      case "uint16 [8]":
        type = "Array<UnsignedShort>";
        break;
      case "uint32 [10]":
      case "uint32 [16]":
      case "uint32 [50]":
      case "uint32 [63]":
      case "AppId_t [32]":
        type = "Array<UnsignedInt>";
        break;
      case "PublishedFileId_t [50]":
      case "CSteamID [50]":
        type = "Array<UnsignedLongLong>";
        break;
      case "float [50]":
        type = "Array<Float>";
        break;

      // pointers
      case "void *":
      case "const void *":
        type = "Pointer<Void>";
        break;
      case "bool *":
        type = "Pointer<Bool>";
        break;
      case "size_t *":
        type = "Pointer<Size>";
        break;
      case "int &":
      case "int *":
      case "const int *":
      case "int32 *":
      case "const int32 *":
        type = "Pointer<Int>";
        break;
      case "int64 *":
        type = "Pointer<LongLong>";
        break;
      case "uint8 *":
      case "const uint8 *":
        type = "Pointer<UnsignedChar>";
        break;
      case "uint16 *":
      case "const uint16 *":
        type = "Pointer<UnsignedShort>";
        break;
      case "float *":
        type = "Pointer<Float>";
        break;
      case "double *":
        type = "Pointer<Double>";
        break;
      case "char *":
      case "char [4]":
      case "char [32]":
      case "char [64]":
      case "char [128]":
      case "char [129]":
      case "char [240]":
      case "char [256]":
      case "char [260]":
      case "char [512]":
      case "char [1024]":
      case "char [1025]":
      case "char [2048]":
      case "char [8000]":
      case "const char *":
        type = "Pointer<Utf8>";
        break;
      case "char **":
      case "const char **":
        type = "Pointer<Pointer<Utf8>>";
        break;
      case "const servernetadr_t &":
        type = "Pointer<servernetadr>";
        break;
      case "SteamNetworkingIPAddr *":
      case "SteamNetworkingIPAddr &":
      case "const SteamNetworkingIPAddr *":
      case "const SteamNetworkingIPAddr &":
        type = "Pointer<SteamNetworkingIPAddr>";
        break;
      case "SteamNetworkingIdentity *":
      case "const SteamNetworkingIdentity &":
      case "const SteamNetworkingIdentity *":
        type = "Pointer<SteamNetworkingIdentity>";
        break;
      case "FriendGameInfo_t *":
        type = "Pointer<FriendGameInfo>";
        break;
      case "LeaderboardEntry_t *":
        type = "Pointer<LeaderboardEntry>";
        break;
      case "SteamParamStringArray_t *":
      case "const SteamParamStringArray_t *":
        type = "Pointer<SteamParamStringArray>";
        break;
      case "SteamPartyBeaconLocation_t *":
        type = "Pointer<SteamPartyBeaconLocation>";
        break;
      case "P2PSessionState_t *":
        type = "Pointer<P2PSessionState>";
        break;
      case "SteamUGCDetails_t *":
        type = "Pointer<SteamUGCDetails>";
        break;
      case "SteamIPAddress_t *":
      case "const SteamIPAddress_t &":
        type = "Pointer<SteamIPAddress>";
        break;
      case "SteamNetworkingMessage_t *":
        type = "Pointer<SteamNetworkingMessage>";
        break;
      case "SteamNetworkingMessage_t **":
      case "SteamNetworkingMessage_t *const *":
        type = "Pointer<Pointer<SteamNetworkingMessage>>";
        break;
      case "SteamNetworkPingLocation_t &":
      case "const SteamNetworkPingLocation_t &":
        type = "Pointer<SteamNetworkPingLocation>";
        break;
      case "SteamItemDetails_t *":
        type = "Pointer<SteamItemDetails>";
        break;
      case "MatchMakingKeyValuePair_t **":
        type = "Pointer<Pointer<MatchMakingKeyValuePair>>";
        break;
      case "gameserveritem_t *":
      case "gameserveritem_t &":
        type = "Pointer<GameServerItem>";
        break;
      case "SteamNetConnectionInfo_t *":
        type = "Pointer<SteamNetConnectionInfo>";
        break;
      case "SteamNetConnectionRealTimeStatus_t *":
        type = "Pointer<SteamNetConnectionRealTimeStatus>";
        break;
      case "SteamNetworkingConfigValue_t *":
      case "const SteamNetworkingConfigValue_t *":
      case "const SteamNetworkingConfigValue_t &":
        type = "Pointer<SteamNetworkingConfigValue>";
        break;
      case "SteamNetConnectionRealTimeLaneStatus_t *":
        type = "Pointer<SteamNetConnectionRealTimeLaneStatus>";
        break;
      case "SteamNetAuthenticationStatus_t *":
        type = "Pointer<SteamNetAuthenticationStatus>";
        break;
      case "SteamNetworkingFakeIPResult_t *":
        type = "Pointer<SteamNetworkingFakeIPResult>";
        break;
      case "SteamRelayNetworkStatus_t *":
        type = "Pointer<SteamRelayNetworkStatus>";
        break;
      case "SteamDatagramRelayAuthTicket *":
        type = "Pointer<SteamDatagramRelayAuthTicket>";
        break;
      case "SteamDatagramGameCoordinatorServerLogin *":
        type = "Pointer<SteamDatagramGameCoordinatorServerLogin>";
        break;
      case "SteamDatagramHostedAddress *":
        type = "Pointer<SteamDatagramHostedAddress>";
        break;
      case "CallbackMsg_t *":
        type = "Pointer<CallbackMsg>";
        break;
      case "ISteamMatchmaking *":
        type = "Pointer<SteamMatchmaking>";
        break;
      case "ISteamMatchmakingServers *":
        type = "Pointer<SteamMatchmakingServers>";
        break;
      case "ISteamMatchmakingServerListResponse *":
        type = "Pointer<SteamMatchmakingServerListResponse>";
        break;
      case "ISteamUser *":
        type = "Pointer<SteamUser>";
        break;
      case "ISteamFriends *":
        type = "Pointer<SteamFriends>";
        break;
      case "ISteamUtils *":
        type = "Pointer<SteamUtils>";
        break;
      case "ISteamUserStats *":
        type = "Pointer<SteamUserStats>";
        break;
      case "ISteamGameServerStats *":
        type = "Pointer<SteamGameServerStats>";
        break;
      case "ISteamRemoteStorage *":
        type = "Pointer<SteamRemoteStorage>";
        break;
      case "ISteamGameServer *":
        type = "Pointer<SteamGameServer>";
        break;
      case "ISteamNetworking *":
        type = "Pointer<SteamNetworking>";
        break;
      case "ISteamApps *":
        type = "Pointer<SteamApps>";
        break;
      case "ISteamScreenshots *":
        type = "Pointer<SteamScreenshots>";
        break;
      case "ISteamVideo *":
        type = "Pointer<SteamVideo>";
        break;
      case "ISteamGameSearch *":
        type = "Pointer<SteamGameSearch>";
        break;
      case "ISteamHTTP *":
        type = "Pointer<SteamHTTP>";
        break;
      case "ISteamController *":
        type = "Pointer<SteamController>";
        break;
      case "ISteamUGC *":
        type = "Pointer<SteamUGC>";
        break;
      case "ISteamAppList *":
        type = "Pointer<SteamAppList>";
        break;
      case "ISteamMusic *":
        type = "Pointer<SteamMusic>";
        break;
      case "ISteamHTMLSurface *":
        type = "Pointer<SteamHTMLSurface>";
        break;
      case "ISteamInventory *":
        type = "Pointer<SteamInventory>";
        break;
      case "ISteamParentalSettings *":
        type = "Pointer<SteamParentalSettings>";
        break;
      case "ISteamInput *":
        type = "Pointer<SteamInput>";
        break;
      case "ISteamRemotePlay *":
        type = "Pointer<SteamRemotePlay>";
        break;
      case "ISteamMatchmakingPlayersResponse *":
        type = "Pointer<SteamMatchmakingPlayersResponse>";
        break;
      case "ISteamMatchmakingPingResponse *":
        type = "Pointer<SteamMatchmakingPingResponse>";
        break;
      case "ISteamNetworkingFakeUDPPort *":
        type = "Pointer<SteamNetworkingFakeUDPPort>";
        break;
      case "ISteamNetworkingSignalingRecvContext *":
        type = "Pointer<SteamNetworkingSignalingRecvContext>";
        break;
      case "ISteamNetworkingConnectionSignaling *":
        type = "Pointer<SteamNetworkingConnectionSignaling>";
        break;
      case "ISteamMatchmakingRulesResponse *":
        type = "Pointer<SteamMatchmakingRulesResponse>";
        break;
      case "ISteamMusicRemote *":
        type = "Pointer<SteamMusicRemote>";
        break;
      case "ISteamParties *":
        type = "Pointer<SteamParties>";
        break;
      case "AppId_t *":
      case "DepotId_t *":
      case "uint32 *":
      case "const uint32 *":
      case "SNetSocket_t *":
      case "SteamNetworkingPOPID *":
      case "HSteamNetConnection *":
        type = "Pointer<UnsignedInt>";
        break;
      case "uint64 *":
      case "ControllerHandle_t *":
      case "ControllerActionSetHandle_t *":
      case "CSteamID *":
      case "CGameID *":
      case "SteamAPICall_t *":
      case "InputActionSetHandle_t *":
      case "PublishedFileId_t *":
      case "InputHandle_t *":
      case "SteamItemInstanceID_t *":
      case "const SteamItemInstanceID_t *":
        type = "Pointer<UnsignedLongLong>";
        break;
      case "ControllerActionOrigin *":
      case "EControllerActionOrigin *":
      case "EChatEntryType *":
      case "EItemPreviewType *":
      case "ERemoteStorageFilePathType *":
      case "ERemoteStorageLocalFileChange *":
      case "ESteamNetworkingConfigDataType *":
      case "EInputActionOrigin *":
      case "ESteamNetworkingConfigScope *":
      case "SteamInventoryResult_t *":
      case "SteamItemDef_t *":
      case "const SteamItemDef_t *":
      case "HSteamPipe *":
        type = "Pointer<Int32>";
        break;
      case "SteamNetworkingErrMsg &":
        type = "Pointer<Pointer<Utf8>>";
        break;
      case "void (*)(SteamNetworkingMessage_t *)":
        type =
            "Pointer<NativeFunction<Pointer<Void> Function(Pointer<SteamNetworkingMessage>)>>";
        break;

      // enums
      case "EFailureType":
      case "PlayerAcceptState_t":
      case "ESteamIPType":
      case "EUniverse":
      case "EResult":
      case "EVoiceResult":
      case "EDenyReason":
      case "EBeginAuthSessionResult":
      case "EAuthSessionResponse":
      case "EUserHasLicenseForAppResult":
      case "EAccountType":
      case "EChatEntryType":
      case "EChatRoomEnterResponse":
      case "EChatSteamIDInstanceFlags":
      case "ENotificationPosition":
      case "EBroadcastUploadResult":
      case "EMarketNotAllowedReasonFlags":
      case "EDurationControlProgress":
      case "EDurationControlNotification":
      case "EDurationControlOnlineState":
      case "EGameSearchErrorCode_t":
      case "EPlayerResult_t":
      case "ESteamIPv6ConnectivityProtocol":
      case "ESteamIPv6ConnectivityState":
      case "EFriendRelationship":
      case "EPersonaState":
      case "EFriendFlags":
      case "EUserRestriction":
      case "EOverlayToStoreFlag":
      case "EActivateGameOverlayToWebPageMode":
      case "EPersonaChange":
      case "ESteamAPICallFailure":
      case "EGamepadTextInputMode":
      case "EGamepadTextInputLineMode":
      case "EFloatingGamepadTextInputMode":
      case "ETextFilteringContext":
      case "ECheckFileSignature":
      case "EMatchMakingServerResponse":
      case "ELobbyType":
      case "ELobbyComparison":
      case "ELobbyDistanceFilter":
      case "EChatMemberStateChange":
      case "ESteamPartyBeaconLocationType":
      case "ESteamPartyBeaconLocationData":
      case "ERemoteStoragePlatform":
      case "ERemoteStoragePublishedFileVisibility":
      case "EWorkshopFileType":
      case "EWorkshopVote":
      case "EWorkshopFileAction":
      case "EWorkshopEnumerationType":
      case "EWorkshopVideoProvider":
      case "EUGCReadAction":
      case "ERemoteStorageLocalFileChange":
      case "ERemoteStorageFilePathType":
      case "ELeaderboardDataRequest":
      case "ELeaderboardSortMethod":
      case "ELeaderboardDisplayType":
      case "ELeaderboardUploadScoreMethod":
      case "ERegisterActivationCodeResult":
      case "EP2PSessionError":
      case "EP2PSend":
      case "ESNetSocketState":
      case "ESNetSocketConnectionType":
      case "EVRScreenshotType":
      case "AudioPlayback_Status":
      case "EHTTPMethod":
      case "EHTTPStatusCode":
      case "EInputSourceMode":
      case "EInputActionOrigin":
      case "EXboxOrigin":
      case "ESteamControllerPad":
      case "EControllerHapticLocation":
      case "EControllerHapticType":
      case "ESteamInputType":
      case "ESteamInputConfigurationEnableType":
      case "ESteamInputLEDFlag":
      case "ESteamInputGlyphSize":
      case "ESteamInputGlyphStyle":
      case "ESteamInputActionEventType":
      case "EControllerActionOrigin":
      case "ESteamControllerLEDFlag":
      case "EUGCMatchingUGCType":
      case "EUserUGCList":
      case "EUserUGCListSortOrder":
      case "EUGCQuery":
      case "EItemUpdateStatus":
      case "EItemState":
      case "EItemStatistic":
      case "EItemPreviewType":
      case "ESteamItemFlags":
      case "EParentalFeature":
      case "ESteamDeviceFormFactor":
      case "ESteamNetworkingAvailability":
      case "ESteamNetworkingIdentityType":
      case "ESteamNetworkingFakeIPType":
      case "ESteamNetworkingConnectionState":
      case "ESteamNetConnectionEnd":
      case "ESteamNetworkingConfigScope":
      case "ESteamNetworkingConfigDataType":
      case "ESteamNetworkingConfigValue":
      case "ESteamNetworkingGetConfigValueResult":
      case "ESteamNetworkingSocketsDebugOutputType":
      case "EServerMode":
      case "EHTMLMouseButton":
      case "EMouseCursor":
      case "EHTMLKeyModifiers":
        type = "Int32";
        break;

      // typedefs
      case "HSteamPipe":
      case "HSteamUser":
      case "HServerQuery":
      case "SteamItemDef_t":
      case "SteamInventoryResult_t":
        type = "Int";
        break;
      case "FriendsGroupID_t":
        type = "Short";
        break;
      case "AppId_t":
      case "DepotId_t":
      case "RTime32":
      case "AccountID_t":
      case "HAuthTicket":
      case "SNetSocket_t":
      case "SNetListenSocket_t":
      case "ScreenshotHandle":
      case "HTTPRequestHandle":
      case "HTTPCookieContainerHandle":
      case "HHTMLBrowser":
      case "RemotePlaySessionID_t":
      case "HSteamNetConnection":
      case "HSteamListenSocket":
      case "HSteamNetPollGroup":
      case "SteamNetworkingPOPID":
        type = "UnsignedInt";
        break;
      case "CSteamID":
      case "CGameID":
        type = "UnsignedLongLong";
        break;
      case "SteamAPICall_t":
      case "PartyBeaconID_t":
      case "UGCHandle_t":
      case "PublishedFileUpdateHandle_t":
      case "PublishedFileId_t":
      case "UGCFileWriteStreamHandle_t":
      case "SteamLeaderboard_t":
      case "SteamLeaderboardEntries_t":
      case "InputHandle_t":
      case "InputActionSetHandle_t":
      case "InputDigitalActionHandle_t":
      case "InputAnalogActionHandle_t":
      case "ControllerHandle_t":
      case "ControllerActionSetHandle_t":
      case "ControllerDigitalActionHandle_t":
      case "ControllerAnalogActionHandle_t":
      case "UGCQueryHandle_t":
      case "UGCUpdateHandle_t":
      case "SteamItemInstanceID_t":
      case "SteamInventoryUpdateHandle_t":
        type = "UnsignedLongLong";
        break;
      case "SteamNetworkingMicroseconds":
        type = "LongLong";
        break;
      case "HServerListRequest":
        type = "Pointer<Void>";
        break;
      case "SteamNetworkingErrMsg":
        type = "Pointer<Utf8>";
        break;

      // structs
      default:
        break;
      // return type.clearSteamNaming();
    }

    return type.clearSteamNaming();
  }

  /// appends a underscore to a cleaned steam keyword if
  /// it conflicts with a dart keyword, or function
  String fixDartConflict() {
    String newString = this;
    bool isDartKeyword = _dartKeywords.contains(newString);
    if (isDartKeyword) {
      newString = "${newString}_";
    }

    return newString;
  }
}
