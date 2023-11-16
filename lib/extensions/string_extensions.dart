import "package:recase/recase.dart";

import "token.dart";

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
  String clearPointerOrConst() =>
      replaceAll(RegExp(r"(\*|&|const|(\[.+\]))"), "");

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

      // the reason we did is GetTicketForWebApiResponse_t ticket field
      result += "AsArray";
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
    } else if (result.startsWith("pvec")) {
      result = result.replaceFirst("pvec", "");
    } else if (result.startsWith("pun")) {
      result = result.replaceFirst("pun", "");
    } else if (result.startsWith("nAppId")) {
      result = result.replaceFirst("nAppId", "appId");
    } else if (result.startsWith("pnAppId")) {
      result = result.replaceFirst("pnAppId", "appId");
    }

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

  /// converts the current [String] into [Token] which can be used
  /// to generate code
  Token toToken() {
    String type = clearClassAccess();

    // we assume that [] and pointers will not exist at the same time in a steam type
    Iterable<RegExpMatch> pointerMatches = RegExp(r"(\*|&)").allMatches(type);
    Iterable<RegExpMatch> arrayMatches =
        RegExp(r"(?:\[(.*?)\])").allMatches(type);

    type = type.clearPointerOrConst().trim();

    String typeDart;
    String typeFfiDart;
    String typeFfiC;
    String typeAnnotation;
    String fieldAccessor = "{0}";
    String caller = "{0}";
    TokenType tokenType;
    switch (type) {
      // primitives
      case "void":
        typeDart = "void";
        typeFfiDart = typeDart;
        typeFfiC = "Void";
        typeAnnotation = "$typeFfiC()";
        tokenType = TokenType.primitive;
      case "bool":
        typeDart = "bool";
        typeFfiDart = typeDart;
        typeFfiC = "Bool";
        typeAnnotation = "$typeFfiC()";
        tokenType = TokenType.primitive;
      case "size_t":
        typeDart = "int";
        typeFfiDart = typeDart;
        typeFfiC = "Size";
        typeAnnotation = "$typeFfiC()";
        tokenType = TokenType.primitive;
      case "unsigned char":
      case "uint8":
        typeDart = "int";
        typeFfiDart = typeDart;
        typeFfiC = "UnsignedChar";
        typeAnnotation = "$typeFfiC()";
        tokenType = TokenType.primitive;
      case "signed char":
      case "int8":
        typeDart = "int";
        typeFfiDart = typeDart;
        typeFfiC = "SignedChar";
        typeAnnotation = "$typeFfiC()";
        tokenType = TokenType.primitive;
      case "short":
      case "int16":
        typeDart = "int";
        typeFfiDart = typeDart;
        typeFfiC = "Short";
        typeAnnotation = "$typeFfiC()";
        tokenType = TokenType.primitive;
      case "unsigned short":
      case "uint16":
        typeDart = "int";
        typeFfiDart = typeDart;
        typeFfiC = "UnsignedShort";
        typeAnnotation = "$typeFfiC()";
        tokenType = TokenType.primitive;
      case "int":
        typeDart = "int";
        typeFfiDart = typeDart;
        typeFfiC = "Int";
        typeAnnotation = "$typeFfiC()";
        tokenType = TokenType.primitive;
      case "unsigned int":
      case "uint32":
        typeDart = "int";
        typeFfiDart = typeDart;
        typeFfiC = "UnsignedInt";
        typeAnnotation = "$typeFfiC()";
        tokenType = TokenType.primitive;
      case "long long":
      case "intp":
      case "int64":
        typeDart = "int";
        typeFfiDart = typeDart;
        typeFfiC = "LongLong";
        typeAnnotation = "$typeFfiC()";
        tokenType = TokenType.primitive;
      case "unsigned long long":
      case "uintp":
      case "uint64":
        typeDart = "int";
        typeFfiDart = typeDart;
        typeFfiC = "UnsignedLongLong";
        typeAnnotation = "$typeFfiC()";
        tokenType = TokenType.primitive;
      case "uint32_t":
        typeDart = "int";
        typeFfiDart = typeDart;
        typeFfiC = "UInt32";
        typeAnnotation = "$typeFfiC()";
        tokenType = TokenType.primitive;
      case "uint16_t":
        typeDart = "int";
        typeFfiDart = typeDart;
        typeFfiC = "UInt16";
        typeAnnotation = "$typeFfiC()";
        tokenType = TokenType.primitive;
      case "int32":
        typeDart = "int";
        typeFfiDart = typeDart;
        typeFfiC = "Int";
        typeAnnotation = "$typeFfiC()";
        tokenType = TokenType.primitive;
      case "int32_t":
        typeDart = "int";
        typeFfiDart = typeDart;
        typeFfiC = "Int32";
        typeAnnotation = "$typeFfiC()";
        tokenType = TokenType.primitive;
      // case "uint":
      case "int64_t":
        typeDart = "int";
        typeFfiDart = typeDart;
        typeFfiC = "Int64";
        typeAnnotation = "$typeFfiC()";
        tokenType = TokenType.primitive;
      case "uint64_t":
        typeDart = "int";
        typeFfiDart = typeDart;
        typeFfiC = "UInt64";
        typeAnnotation = "$typeFfiC()";
        tokenType = TokenType.primitive;
      case "int16_t":
        typeDart = "int";
        typeFfiDart = typeDart;
        typeFfiC = "Int16";
        typeAnnotation = "$typeFfiC()";
        tokenType = TokenType.primitive;
      case "int8_t":
        typeDart = "int";
        typeFfiDart = typeDart;
        typeFfiC = "Int8";
        typeAnnotation = "$typeFfiC()";
        tokenType = TokenType.primitive;
      case "uint8_t":
        typeDart = "int";
        typeFfiDart = typeDart;
        typeFfiC = "UInt8";
        typeAnnotation = "$typeFfiC()";
        tokenType = TokenType.primitive;
      case "char":
        typeDart = "int";
        typeFfiDart = typeDart;
        typeFfiC = "Char";
        typeAnnotation = "$typeFfiC()";
        tokenType = TokenType.primitive;
      case "intptr_t":
        typeDart = "int";
        typeFfiDart = typeDart;
        typeFfiC = "IntPtr";
        typeAnnotation = "$typeFfiC()";
        tokenType = TokenType.primitive;
      case "double":
        typeDart = "double";
        typeFfiDart = typeDart;
        typeFfiC = "Double";
        typeAnnotation = "$typeFfiC()";
        tokenType = TokenType.primitive;
      case "float":
        typeDart = "double";
        typeFfiDart = typeDart;
        typeFfiC = "Float";
        typeAnnotation = "$typeFfiC()";
        tokenType = TokenType.primitive;

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
      case "ECommunityProfileItemType":
      case "ECommunityProfileItemProperty":
      case "EUGCContentDescriptorID":
      case "ETimelineGame":
      case "ETimelineGameMode":
        typeDart = type.clearSteamNaming();
        typeFfiDart = "${typeDart}AliasDart";
        typeFfiC = "${typeDart}AliasC";
        typeAnnotation = "Int32()";

        if (pointerMatches.isEmpty && arrayMatches.isEmpty) {
          fieldAccessor = "$typeDart.fromValue({0})";
          caller = "{0}.value";
        }

        tokenType = TokenType.enums;

      // typedefs
      case "HSteamPipe":
      case "HSteamUser":
      case "HServerQuery":
      case "SteamItemDef_t":
      case "SteamInventoryResult_t":
        typeDart = type.clearSteamNaming();
        typeFfiDart = typeDart;
        typeFfiC = "Int";
        typeAnnotation = "$typeFfiC()";
        tokenType = TokenType.typedefs;
      case "FriendsGroupID_t":
        typeDart = type.clearSteamNaming();
        typeFfiDart = typeDart;
        typeFfiC = "Short";
        typeAnnotation = "$typeFfiC()";
        tokenType = TokenType.typedefs;
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
        typeDart = type.clearSteamNaming();
        typeFfiDart = typeDart;
        typeFfiC = "UnsignedInt";
        typeAnnotation = "$typeFfiC()";
        tokenType = TokenType.typedefs;
      case "CSteamID":
      case "CGameID":
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
        typeDart = type.clearSteamNaming();
        typeFfiDart = typeDart;
        typeFfiC = "UnsignedLongLong";
        typeAnnotation = "$typeFfiC()";
        tokenType = TokenType.typedefs;
      case "SteamNetworkingMicroseconds":
        typeDart = type.clearSteamNaming();
        typeFfiDart = typeDart;
        typeFfiC = "LongLong";
        typeAnnotation = "$typeFfiC()";
        tokenType = TokenType.typedefs;
      case "HServerListRequest":
        typeDart = type.clearSteamNaming();
        typeFfiDart = typeDart;
        typeFfiC = "Pointer<Void>";
        typeAnnotation = "";
        tokenType = TokenType.typedefs;
      case "SteamNetworkingErrMsg":
        typeDart = type.clearSteamNaming();
        typeFfiDart = typeDart;
        typeFfiC = "Pointer<Utf8>";
        typeAnnotation = "";
        tokenType = TokenType.typedefs;

      //functions
      // TODO pointers gets lost so we can not distinguish SteamNetworkingMessage_t vs SteamNetworkingMessage_t *
      case "void ()(SteamNetworkingMessage_t )":
        typeDart =
            "Pointer<NativeFunction<Pointer<Void> Function(Pointer<SteamNetworkingMessage>)>>";
        typeFfiDart = typeDart;
        typeFfiC = typeDart;
        typeAnnotation = "";
        tokenType = TokenType.function;

      // structs or interfaces
      default:
        typeDart = type.clearSteamNaming();
        typeFfiDart = typeDart;
        typeFfiC = typeDart;
        typeAnnotation = "";
        tokenType = TokenType.structOrInterface;
    }

    if (tokenType != TokenType.function) {
      if (pointerMatches.isNotEmpty) {
        String prefix = pointerMatches.map((m) => "Pointer<").join();
        String postfix = pointerMatches.map((m) => ">").join();

        if (typeFfiC == "Char") {
          typeFfiC = "Utf8";
        }

        typeFfiC = "$prefix$typeFfiC$postfix";
        typeDart = typeFfiC;
        typeFfiDart = typeFfiC;
        typeAnnotation = "";
      } else if (arrayMatches.isNotEmpty) {
        String prefix = arrayMatches.map((m) => "Array<").join();
        String postfix = arrayMatches.map((e) => ">").join();
        String arrayDimensions = arrayMatches.map((m) => m.group(1)!).join(",");

        typeFfiC = "$prefix$typeFfiC$postfix";
        typeDart = typeFfiC;
        typeFfiDart = typeFfiC;
        typeAnnotation = "$typeFfiC($arrayDimensions)";
      }
    }

    Token token = Token(
      typeDart: typeDart,
      typeFfiDart: typeFfiDart,
      typeFfiC: typeFfiC,
      typeAnnotation: typeAnnotation,
      fieldAccessor: fieldAccessor,
      caller: caller,
      tokenType: tokenType,
    );

    return token;
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

  /// returns the path of type in order to import
  String importPath({
    String relativeness = "../",
    Set<String> enumSet = const {},
    Set<String> structSet = const {},
    Set<String> callbackStructSet = const {},
    Set<String> interfaceSet = const {},
  }) {
    String packageName = "";
    if (enumSet.contains(this)) {
      packageName =
          "${relativeness}enums/e${this.clearEnumName().toFileName()}.dart";
    } else if (structSet.contains(this)) {
      packageName = "${relativeness}structs/${this.toFileName()}.dart";
    } else if (callbackStructSet.contains(this)) {
      packageName = "${relativeness}callback_structs/${this.toFileName()}.dart";
    } else if (interfaceSet.contains(this)) {
      packageName =
          "${relativeness}interfaces/i${this.clearInterfaceName().toFileName()}.dart";
    }

    return packageName;
  }
}
