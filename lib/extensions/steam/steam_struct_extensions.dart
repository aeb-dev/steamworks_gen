import "dart:io";

import "package:path/path.dart" as p;
import "package:recase/recase.dart";

import "../../steam/steam_const.dart";
import "../../steam/steam_field.dart";
import "../../steam/steam_method.dart";
import "../../steam/steam_param.dart";
import "../../steam/steam_struct.dart";
import "../file_extensions.dart";
import "../string_extensions.dart";
import "steam_const_extensions.dart";
import "steam_enum_extensions.dart";
import "steam_field_extensions.dart";
import "steam_method_extensions.dart";

/// Extensions on [SteamStruct] to generate ffi code
extension SteamStructExtensions on SteamStruct {
  /// Generates necessary code for a [SteamStruct]
  Future<void> generate(
    IOSink fileSink,
    String target,
    // bool isCallback,
    // Set<String> typedefSet,
    Set<String> enumSet,
    Set<String> structSet,
    Set<String> callbackStructSet,
  ) async {
    fileSink.writeImport("dart:ffi");
    fileSink.writeImport("package:ffi/ffi.dart");

    // TODO: create a common function for importing below
    for (SteamField steamField in fields) {
      String checkType =
          steamField.type.clearClassAccess().clearPointerOrConst().trim();
      bool isEnum = enumSet.contains(checkType);
      if (isEnum) {
        fileSink.writeImport("../enums/${checkType.toFileName()}.dart");
        // continue;
      }

      bool isStruct = structSet.contains(checkType);
      if (isStruct) {
        fileSink.writeImport("../structs/${checkType.toFileName()}.dart");
        // continue;
      }

      bool iscallbackStruct = callbackStructSet.contains(checkType);
      if (iscallbackStruct) {
        fileSink
            .writeImport("../callback_structs/${checkType.toFileName()}.dart");
        // continue;
      }
    }

    for (SteamMethod steamMethod in methods) {
      String checkType = steamMethod.returnType
          .clearClassAccess()
          .clearPointerOrConst()
          .trim();
      bool isEnum = enumSet.contains(checkType);
      if (isEnum) {
        fileSink.writeImport("../enums/${checkType.toFileName()}.dart");
        // continue;
      }

      bool isStruct = structSet.contains(checkType);
      if (isStruct) {
        fileSink.writeImport("../structs/${checkType.toFileName()}.dart");
        // continue;
      }

      bool iscallbackStruct = callbackStructSet.contains(checkType);
      if (iscallbackStruct) {
        fileSink
            .writeImport("../callback_structs/${checkType.toFileName()}.dart");
        // continue;
      }

      for (SteamParam param in steamMethod.params) {
        String checkType =
            param.type.clearClassAccess().clearPointerOrConst().trim();
        bool isEnum = enumSet.contains(checkType);
        if (isEnum) {
          fileSink.writeImport("../enums/${checkType.toFileName()}.dart");
          // continue;
        }

        bool isStruct = structSet.contains(checkType);
        if (isStruct) {
          fileSink.writeImport("../structs/${checkType.toFileName()}.dart");
          // continue;
        }

        bool iscallbackStruct = callbackStructSet.contains(checkType);
        if (iscallbackStruct) {
          fileSink.writeImport(
            "../callback_structs/${checkType.toFileName()}.dart",
          );
          // continue;
        }
      }
    }

    fileSink.writeImport("../steam_api.dart");
    fileSink.writeImport("../typedefs.dart");

    String correctedName = name.clearSteamNaming();
    fileSink.write("@Packed(${_getAlignment(target)})");
    fileSink.writeClass(
      correctedName.pascalCase,
      fields.isNotEmpty ? "Struct" : "Opaque",
    );
    fileSink.writeStartBlock();

    for (SteamConst steamConst in consts) {
      await steamConst.generate(fileSink, true);
    }

    await fields.generate(fileSink);

    fileSink.writeEndBlock();

    if (methods.isNotEmpty) {
      await methods.generateLookup(fileSink, correctedName);

      fileSink.writeExtension(
        "${correctedName}Extensions",
        "Pointer<$correctedName>",
      );
      fileSink.writeStartBlock();

      await methods.generate(fileSink, correctedName);

      fileSink.writeEndBlock();
    }

    await fileSink.flush();
    await fileSink.close();
  }

  // TODO not completed
  int _getAlignment(String target) {
    switch (name) {
      case "SteamAppInstalled_t":
      case "SteamAppUninstalled_t":
      case "DlcInstalled_t":
      case "RegisterActivationCodeResponse_t":
      case "AppProofOfPurchaseKeyResponse_t":
      case "FileDetailsResult_t":
      case "TimedTrialStatus_t":
      case "FriendGameInfo_t":
      case "PersonaStateChange_t":
      case "GameOverlayActivated_t": //
      case "GameServerChangeRequested_t":
      case "GameLobbyJoinRequested_t":
      case "AvatarImageLoaded_t":
      case "ClanOfficerListResponse_t":
      case "FriendRichPresenceUpdate_t":
      case "GameRichPresenceJoinRequested_t":
      case "GameConnectedClanChatMsg_t":
      case "GameConnectedChatJoin_t":
      case "GameConnectedChatLeave_t":
      case "DownloadClanActivityCountsResult_t":
      case "JoinClanChatRoomCompletionResult_t":
      case "GameConnectedFriendChatMsg_t":
      case "FriendsGetFollowerCount_t":
      case "FriendsIsFollowing_t":
      case "FriendsEnumerateFollowingList_t":
      case "SetPersonaNameResponse_t":
      case "CallbackMsg_t":
        return _steamPackSize(target);
      case "ControllerAnalogActionData_t":
      case "ControllerDigitalActionData_t":
      case "ControllerMotionData_t":
        return 1;
      default:
        return 4;
    }
  }

  int _steamPackSize(String target) {
    if (target == "win") {
      return 8;
    } else if (target == "linux" || target == "mac") {
      return 4;
    } else {
      throw "Unsupported platform: $target";
    }
  }
}

/// Extensions on [Iterable<SteamStruct>] to generate ffi code
extension SteamStructIterableExtensions on Iterable<SteamStruct> {
  /// Creates a file for each [SteamStruct] and generates respective code
  Future<void> generate(
    String path,
    String target,
    bool isCallback,
    // Set<String> typedefSet,
    Set<String> enumSet,
    Set<String> structSet,
    Set<String> callbackStructSet,
  ) async {
    for (SteamStruct struct in this) {
      await struct.enums.generate(path);

      String filePath;
      String fileName = struct.name.toFileName();
      if (isCallback) {
        filePath = p.join(path, "callback_structs", "$fileName.dart");
      } else {
        filePath = p.join(path, "structs", "$fileName.dart");
      }
      File file = File(filePath);
      await file.create(recursive: true);

      IOSink fileSink = file.openWrite(mode: FileMode.writeOnly);

      await struct.generate(
        fileSink,
        target,
        // isCallback,
        // typedefSet,
        enumSet,
        structSet,
        callbackStructSet,
      );

      await fileSink.flush();
      await fileSink.close();
    }
  }
}
