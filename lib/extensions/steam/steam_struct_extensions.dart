import "dart:io";

import "package:path/path.dart" as p;
import "package:recase/recase.dart";

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
  Future<void> generate({
    required IOSink fileSink,
    required String target,
    Set<String> enumSet = const {},
    Set<String> structSet = const {},
    Set<String> callbackStructSet = const {},
  }) async {
    fileSink.writeImport(packageName: "dart:ffi");
    fileSink.writeImport(packageName: "package:ffi/ffi.dart");

    await fields.generateImport(
      fileSink: fileSink,
      enumSet: enumSet,
      structSet: structSet,
      callbackStructSet: callbackStructSet,
    );

    await methods.generateImport(
      fileSink: fileSink,
      enumSet: enumSet,
      structSet: structSet,
      callbackStructSet: callbackStructSet,
    );

    fileSink.writeImport(
      packageName: "../dl.dart",
    );
    fileSink.writeImport(
      packageName: "../typedefs.dart",
    );

    String correctedName = name.clearSteamNaming().pascalCase;

    fileSink.write("@Packed(${_getAlignment(target: target)})");
    fileSink.writeClass(
      className: correctedName,
      extend: fields.isNotEmpty ? "Struct" : "Opaque",
    );
    fileSink.writeStartBlock();

    // write callback id before everything
    if (callbackId != -1) {
      fileSink.writeln("static int get callbackId => $callbackId;\n");
    }

    await consts.generate(
      fileSink: fileSink,
    );

    await fields.generate(
      fileSink: fileSink,
    );

    fileSink.writeEndBlock();

    if (methods.isNotEmpty || fields.isNotEmpty) {
      await methods.generateLookup(
        fileSink: fileSink,
        owner: correctedName,
      );

      fileSink.writeExtension(
        extensionName: "${correctedName}Extensions",
        on: "Pointer<$correctedName>",
      );

      fileSink.writeStartBlock();

      await methods.generate(
        fileSink: fileSink,
        owner: correctedName,
      );

      await fields.generateFieldAccess(
        fileSink: fileSink,
      );

      fileSink.writeEndBlock();
    }

    await fileSink.flush();
    await fileSink.close();
  }

  /// Generates necessary file and code for a [SteamStruct]
  Future<void> generateFile({
    required String path,
    required String target,
    Set<String> enumSet = const {},
    Set<String> structSet = const {},
    Set<String> callbackStructSet = const {},
  }) async {
    await enums.generate(
      path: path,
    );

    String filePath;
    String fileName = name.toFileName();
    if (callbackId != -1) {
      filePath = p.join(path, "callback_structs", "$fileName.dart");
    } else {
      filePath = p.join(path, "structs", "$fileName.dart");
    }
    File file = File(filePath);
    await file.create(recursive: true);

    IOSink fileSink = file.openWrite(mode: FileMode.writeOnly);

    await generate(
      fileSink: fileSink,
      target: target,
      enumSet: enumSet,
      structSet: structSet,
      callbackStructSet: callbackStructSet,
    );

    await fileSink.flush();
    await fileSink.close();
  }

  int _getAlignment({
    required String target,
  }) {
    switch (name) {
      // isteamapplist
      case "SteamAppInstalled_t":
      case "SteamAppUninstalled_t":

      // isteamapps
      case "DlcInstalled_t":
      case "RegisterActivationCodeResponse_t":
      // case "NewUrlLaunchParameters_t":
      case "AppProofOfPurchaseKeyResponse_t":
      case "FileDetailsResult_t":
      case "TimedTrialStatus_t":

      // isteamfriends
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
      // case "UnreadChatMessagesChanged_t":
      case "OverlayBrowserProtocolNavigation_t":

      // isteamgamecoordinator
      case "GCMessageAvailable_t":
      // case "GCMessageFailed_t":

      // isteamgameserver
      case "GSClientApprove_t":
      case "GSClientDeny_t":
      case "GSClientKick_t":
      case "GSClientAchievementStatus_t":
      case "GSPolicyResponse_t":
      case "GSGameplayStats_t":
      case "GSClientGroupStatus_t":
      case "GSReputation_t":
      case "AssociateWithClanResult_t":
      case "ComputeNewPlayerCompatibilityResult_t":

      // isteamgameserverstats
      case "GSStatsReceived_t":
      case "GSStatsStored_t":
      case "GSStatsUnloaded_t":

      // isteamhtmlsurface
      case "HTML_BrowserReady_t":
      case "HTML_NeedsPaint_t":
      case "HTML_StartRequest_t":
      case "HTML_CloseBrowser_t":
      case "HTML_URLChanged_t":
      case "HTML_FinishedRequest_t":
      case "HTML_OpenLinkInNewTab_t":
      case "HTML_ChangedTitle_t":
      case "HTML_SearchResults_t":
      case "HTML_CanGoBackAndForward_t":
      case "HTML_HorizontalScroll_t":
      case "HTML_VerticalScroll_t":
      case "HTML_LinkAtPosition_t":
      case "HTML_JSAlert_t":
      case "HTML_JSConfirm_t":
      case "HTML_FileOpenDialog_t":
      case "HTML_NewWindow_t":
      case "HTML_SetCursor_t":
      case "HTML_StatusText_t":
      case "HTML_ShowToolTip_t":
      case "HTML_UpdateToolTip_t":
      case "HTML_HideToolTip_t":
      case "HTML_BrowserRestarted_t":

      // isteamhttp
      case "HTTPRequestCompleted_t":
      case "HTTPRequestHeadersReceived_t":
      case "HTTPRequestDataReceived_t":

      // isteaminput
      case "SteamInputDeviceConnected_t":
      case "SteamInputDeviceDisconnected_t":
      case "SteamInputConfigurationLoaded_t":

      // isteaminventory
      case "SteamItemDetails_t":
      case "SteamInventoryResultReady_t":
      case "SteamInventoryFullUpdate_t":
      case "SteamInventoryDefinitionUpdate_t":
      case "SteamInventoryEligiblePromoItemDefIDs_t":
      case "SteamInventoryStartPurchaseResult_t":
      case "SteamInventoryRequestPricesResult_t":

      // isteammatchmaking
      case "SteamPartyBeaconLocation_t":
      case "FavoritesListChanged_t":
      case "LobbyInvite_t":
      case "LobbyEnter_t":
      case "LobbyDataUpdate_t":
      case "LobbyChatUpdate_t":
      case "LobbyChatMsg_t":
      case "LobbyGameCreated_t":
      case "LobbyMatchList_t":
      case "LobbyKicked_t":
      case "LobbyCreated_t":
      case "PSNGameBootInviteResult_t":
      case "FavoritesListAccountsUpdated_t":
      case "SearchForGameProgressCallback_t":
      case "SearchForGameResultCallback_t":
      case "RequestPlayersForGameProgressCallback_t":
      case "RequestPlayersForGameResultCallback_t":
      case "RequestPlayersForGameFinalResultCallback_t":
      case "SubmitPlayerResultResultCallback_t":
      case "EndGameResultCallback_t":
      case "JoinPartyCallback_t":
      case "CreateBeaconCallback_t":
      case "ReservationNotificationCallback_t":
      case "ChangeNumOpenSlotsCallback_t":
      case "AvailableBeaconLocationsUpdated_t":
      case "ActiveBeaconsUpdated_t":

      // isteammusic
      case "PlaybackStatusHasChanged_t":
      case "VolumeHasChanged_t":

      // isteammusicremote
      case "MusicPlayerRemoteWillActivate_t":
      case "MusicPlayerRemoteWillDeactivate_t":
      case "MusicPlayerRemoteToFront_t":
      case "MusicPlayerWillQuit_t":
      case "MusicPlayerWantsPlay_t":
      case "MusicPlayerWantsPause_t":
      case "MusicPlayerWantsPlayPrevious_t":
      case "MusicPlayerWantsPlayNext_t":
      case "MusicPlayerWantsShuffled_t":
      case "MusicPlayerWantsLooped_t":
      case "MusicPlayerWantsVolume_t":
      case "MusicPlayerSelectsQueueEntry_t":
      case "MusicPlayerSelectsPlaylistEntry_t":
      case "MusicPlayerWantsPlayingRepeatStatus_t":

      // isteamnetworking
      case "P2PSessionState_t":
      case "P2PSessionRequest_t":
      case "P2PSessionConnectFail_t":
      case "SocketStatusCallback_t":

      // isteamnetworkingsockets
      case "SteamNetConnectionStatusChangedCallback_t":
      case "SteamNetAuthenticationStatus_t":

      // isteamremoteplay
      case "SteamRemotePlaySessionConnected_t":
      case "SteamRemotePlaySessionDisconnected_t":

      // isteamremotestorage
      case "SteamParamStringArray_t":
      case "RemoteStorageFileShareResult_t":
      case "RemoteStoragePublishFileResult_t":
      case "RemoteStorageDeletePublishedFileResult_t":
      case "RemoteStorageEnumerateUserPublishedFilesResult_t":
      case "RemoteStorageSubscribePublishedFileResult_t":
      case "RemoteStorageEnumerateUserSubscribedFilesResult_t":
      case "RemoteStorageUnsubscribePublishedFileResult_t":
      case "RemoteStorageUpdatePublishedFileResult_t":
      case "RemoteStorageDownloadUGCResult_t":
      case "RemoteStorageGetPublishedFileDetailsResult_t":
      case "RemoteStorageEnumerateWorkshopFilesResult_t":
      case "RemoteStorageGetPublishedItemVoteDetailsResult_t":
      case "RemoteStoragePublishedFileSubscribed_t":
      case "RemoteStoragePublishedFileUnsubscribed_t":
      case "RemoteStoragePublishedFileDeleted_t":
      case "RemoteStorageUpdateUserPublishedItemVoteResult_t":
      case "RemoteStorageUserVoteDetails_t":
      case "RemoteStorageEnumerateUserSharedWorkshopFilesResult_t":
      case "RemoteStorageSetUserPublishedFileActionResult_t":
      case "RemoteStorageEnumeratePublishedFilesByUserActionResult_t":
      case "RemoteStoragePublishFileProgress_t":
      case "RemoteStoragePublishedFileUpdated_t":
      case "RemoteStorageFileWriteAsyncComplete_t":
      case "RemoteStorageFileReadAsyncComplete_t":
      case "RemoteStorageLocalFileChange_t":

      // isteamscreenhots
      case "ScreenshotReady_t":
      case "ScreenshotRequested_t":

      // isteamugc
      case "SteamUGCDetails_t":
      case "SteamUGCQueryCompleted_t":
      case "SteamUGCRequestUGCDetailsResult_t":
      case "CreateItemResult_t":
      case "SubmitItemUpdateResult_t":
      case "ItemInstalled_t":
      case "DownloadItemResult_t":
      case "UserFavoriteItemsListChanged_t":
      case "SetUserItemVoteResult_t":
      case "GetUserItemVoteResult_t":
      case "StartPlaytimeTrackingResult_t":
      case "StopPlaytimeTrackingResult_t":
      case "AddUGCDependencyResult_t":
      case "RemoveUGCDependencyResult_t":
      case "AddAppDependencyResult_t":
      case "RemoveAppDependencyResult_t":
      case "GetAppDependenciesResult_t":
      case "DeleteItemResult_t":
      case "UserSubscribedItemsListChanged_t":
      case "WorkshopEULAStatus_t":

      // isteamuser
      case "SteamServersConnected_t":
      case "SteamServerConnectFailure_t":
      case "SteamServersDisconnected_t":
      case "ClientGameServerDeny_t":
      case "IPCFailure_t":
      case "LicensesUpdated_t":
      case "ValidateAuthTicketResponse_t":
      case "MicroTxnAuthorizationResponse_t":
      case "EncryptedAppTicketResponse_t":
      case "GetAuthSessionTicketResponse_t":
      case "GameWebCallback_t":
      case "StoreAuthURLResponse_t":
      case "MarketEligibilityResponse_t":
      case "DurationControl_t":

      // isteamuserstats
      case "LeaderboardEntry_t":
      case "UserStatsReceived_t":
      case "UserStatsStored_t":
      case "UserAchievementStored_t":
      case "LeaderboardFindResult_t":
      case "LeaderboardScoresDownloaded_t":
      case "LeaderboardScoreUploaded_t":
      case "NumberOfCurrentPlayers_t":
      case "UserStatsUnloaded_t":
      case "UserAchievementIconFetched_t":
      case "GlobalAchievementPercentagesReady_t":
      case "LeaderboardUGCSet_t":
      case "PS3TrophiesInstalled_t":
      case "GlobalStatsReceived_t":

      // isteamutils
      case "IPCountry_t":
      case "LowBatteryPower_t":
      case "SteamAPICallCompleted_t":
      case "SteamShutdown_t":
      case "CheckFileSignature_t":
      case "GamepadTextInputDismissed_t":
      case "AppResumingFromSuspend_t":
      case "FloatingGamepadTextInputDismissed_t":

      // isteamvideo
      case "GetVideoURLResult_t":
      case "GetOPFSettingsResult_t":

      // steam_api_internal
      case "CallbackMsg_t":

      // steamclientpublic ?
      // case "ValvePackingSentinel_t":

      // steamnetworkingfakeip
      case "SteamNetworkingFakeIPResult_t":

      // steamnetworkingtypes
      case "SteamDatagramRelayAuthTicket":
      case "SteamDatagramHostedAddress":
      case "SteamDatagramGameCoordinatorServerLogin":
      case "SteamRelayNetworkStatus_t":
      case "SteamNetConnectionInfo_t":
      // TODO: delete below when the following is resolved: https://github.com/dart-lang/sdk/issues/46644
      // and uncomment the related case below for packed 1
      case "SteamNetworkingMessagesSessionFailed_t":
      case "SteamNetConnectionRealTimeStatus_t":
      case "SteamNetConnectionRealTimeLaneStatus_t":
        return _steamPackSize(
          target: target,
        );

      // isteamcontroller
      case "ControllerAnalogActionData_t":
      case "ControllerDigitalActionData_t":
      case "ControllerMotionData_t":

      // isteaminput
      case "InputAnalogActionData_t":
      case "InputDigitalActionData_t":
      case "InputMotionData_t":
      case "SteamInputActionEvent_t":
      case "AnalogAction_t":

      // isteamnetworkingmessages
      case "SteamNetworkingMessagesSessionRequest_t":
      // case "SteamNetworkingMessagesSessionFailed_t":

      // steamclientpublic ?

      // steamnetworkingtypes
      case "SteamNetworkingIPAddr":
      case "SteamNetworkingIdentity":

      // steamtypes
      case "SteamIPAddress_t":
        return 1;
      default:
        return 4;
    }
  }

  int _steamPackSize({
    required String target,
  }) {
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
  Future<void> generate({
    required String path,
    required String target,
    Set<String> enumSet = const {},
    Set<String> structSet = const {},
    Set<String> callbackStructSet = const {},
  }) async {
    for (SteamStruct struct in this) {
      await struct.generateFile(
        path: path,
        target: target,
        enumSet: enumSet,
        structSet: structSet,
        callbackStructSet: callbackStructSet,
      );
    }
  }
}
