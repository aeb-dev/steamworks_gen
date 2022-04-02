import "dart:io";

import "package:path/path.dart" as p;
import "package:recase/recase.dart";

import "../../steam/steam_api.dart";
import "../../steam/steam_field.dart";
import "../../steam/steam_initalizer.dart";
import "../../steam/steam_interface.dart";
import "../../steam/steam_method.dart";
import "../../steam/steam_param.dart";
import "../../steam/steam_struct.dart";
import "../file_extensions.dart";
import "../string_extensions.dart";
import "steam_const_extensions.dart";
import "steam_enum_extensions.dart";
import "steam_initializer_extensions.dart";
import "steam_interface_extensions.dart";
import "steam_struct_extensions.dart";
import "steam_typedef_extensions.dart";

/// Extensions on [SteamApi] to generate ffi code
extension SteamApiExtensions on SteamApi {
  /// This is entrypoint for code generation. Generates code according to the
  /// [SteamApi] definition by traversing all fields and emitting necessary code
  Future<void> generate({
    required String path,
    required String target,
  }) async {
    List<SteamStruct> missingStructs = [
      SteamStruct(name: "SteamDatagramRelayAuthTicket"),
      SteamStruct(
        name: "CallbackMsg_t",
        fields: [
          SteamField(
            name: "m_hSteamUser",
            type: "HSteamUser",
          ),
          SteamField(
            name: "m_iCallback",
            type: "int",
          ),
          SteamField(
            name: "m_pubParam",
            type: "uint8 *",
          ),
          SteamField(
            name: "m_cubParam",
            type: "int",
          ),
        ],
      ),
      SteamStruct(
        name: "AnalogAction_t",
        fields: [
          SteamField(
            name: "actionHandle",
            type: "InputAnalogActionHandle_t",
          ),
          SteamField(
            name: "analogActionData",
            type: "InputAnalogActionData_t",
          ),
        ],
      ),
    ];

    List<SteamInterface> missingInterfaces = [
      SteamInterface(name: "ISteamNetworkingConnectionSignaling"),
      SteamInterface(name: "ISteamNetworkingSignalingRecvContext"),
    ];

    Set<String> enumSet = enums.map((e) => e.name).toSet();
    enumSet.addAll(structs.expand((s) => s.enums.map((e) => e.name)));
    enumSet.addAll(callbackStructs.expand((cs) => cs.enums.map((e) => e.name)));
    enumSet.addAll(interfaces.expand((i) => i.enums.map((e) => e.name)));

    Set<String> structSet = structs.map((s) => s.name).toSet()
      ..addAll(missingStructs.map((s) => s.name));

    Set<String> callbackStructSet =
        callbackStructs.map((cs) => cs.name).toSet();

    Set<String> interfaceSet = interfaces.map((i) => i.name).toSet()
      ..addAll(missingInterfaces.map((i) => i.name));

    await generateCallbackIdMap(
      path: path,
      callbackStructSet: callbackStructSet,
    );

    await generateDl(
      path: path,
    );
    await generateSteamApi(
      path: path,
      enumSet: enumSet,
      structSet: structSet,
      callbackStructSet: callbackStructSet,
    );
    await generateSteamGameServer(
      path: path,
      enumSet: enumSet,
      structSet: structSet,
      callbackStructSet: callbackStructSet,
    );
    await generateDispatch(
      path: path,
      enumSet: enumSet,
      structSet: structSet,
      callbackStructSet: callbackStructSet,
    );
    await consts.generateFile(
      path: path,
      fileMode: FileMode.writeOnly,
    );
    await typedefs.generate(
      path: path,
    );
    await enums.generate(
      path: path,
    );
    await missingStructs.generate(
      path: path,
      target: target,
      enumSet: enumSet,
      structSet: structSet,
      callbackStructSet: callbackStructSet,
    );
    await structs.generate(
      path: path,
      target: target,
      // typedefSet,
      enumSet: enumSet,
      structSet: structSet,
      callbackStructSet: callbackStructSet,
    );
    await callbackStructs.generate(
      path: path,
      target: target,
      // typedefSet,
      enumSet: enumSet,
      structSet: structSet,
      callbackStructSet: callbackStructSet,
    );

    await missingInterfaces.generate(
      path: path,
      enumSet: enumSet,
      structSet: structSet,
      callbackStructSet: callbackStructSet,
      interfaceSet: interfaceSet,
    );
    await interfaces.generate(
      path: path,
      enumSet: enumSet,
      structSet: structSet,
      callbackStructSet: callbackStructSet,
      interfaceSet: interfaceSet,
    );
  }

  /// Generates code for accessing the library file
  Future<void> generateDl({
    required String path,
  }) async {
    String filePath = p.join(path, "dl.dart");
    File file = File(filePath);
    await file.create(recursive: true);

    IOSink fileSink = file.openWrite(mode: FileMode.writeOnly);

    fileSink.writeImport(
      packageName: "dart:ffi",
    );

    fileSink.writeln(
      "DynamicLibrary dl = DynamicLibrary.open(\"./steam_api64.dll\");\n",
    );
  }

  /// Generates callback id map by type to make
  /// it easier to lookup callback ids
  Future<void> generateCallbackIdMap({
    required String path,
    Set<String> callbackStructSet = const {},
  }) async {
    String filePath = p.join(path, "callback_id_map.dart");
    File file = File(filePath);
    await file.create(recursive: true);

    IOSink fileSink = file.openWrite(mode: FileMode.writeOnly);

    for (String name in callbackStructs.map((cs) => cs.name)) {
      String importPath = name.importPath(
        relativeness: "",
        callbackStructSet: callbackStructSet,
      );

      fileSink.writeImport(packageName: importPath);
    }

    fileSink.write(
      "Map<Type, int> callbackIdMapByType =",
    );

    fileSink.writeStartBlock();

    for (String name in callbackStructs.map((cs) => cs.name)) {
      String typeName = name.clearSteamNaming().pascalCase;
      fileSink.write("$typeName: $typeName.callbackId,");
    }

    fileSink.writeEndBlock();

    fileSink.write(";");
  }

  /// Generates code for common steam apis
  Future<void> generateSteamApi({
    required String path,
    Set<String> enumSet = const {},
    Set<String> structSet = const {},
    Set<String> callbackStructSet = const {},
  }) async {
    SteamInitializer steamApi = SteamInitializer(
      name: "SteamApi",
      methods: [
        SteamMethod(
          name: "Init",
          nameFlat: "SteamAPI_Init",
          returnType: "bool",
        ),
        SteamMethod(
          name: "ReleaseCurrentThreadMemory",
          nameFlat: "SteamAPI_ReleaseCurrentThreadMemory",
          returnType: "void",
        ),
        SteamMethod(
          name: "RestartAppIfNecessary",
          nameFlat: "SteamAPI_RestartAppIfNecessary",
          returnType: "bool",
          params: [
            SteamParam(
              name: "unOwnAppID",
              type: "uint32",
            ),
          ],
        ),
        // SteamMethod(
        //   name: "RunCallbacks",
        //   nameFlat: "SteamAPI_RunCallbacks",
        //   returnType: "void",
        // ),
        SteamMethod(
          name: "Shutdown",
          nameFlat: "SteamAPI_Shutdown",
          returnType: "void",
        ),
        SteamMethod(
          name: "GetHSteamPipe",
          nameFlat: "SteamAPI_GetHSteamPipe",
          returnType: "HSteamPipe",
        ),
        SteamMethod(
          name: "GetHSteamUser",
          nameFlat: "SteamAPI_GetHSteamUser",
          returnType: "HSteamUser",
        ),
      ],
    );

    await steamApi.generateFile(
      path: path,
      enumSet: enumSet,
      structSet: structSet,
      callbackStructSet: callbackStructSet,
    );
  }

  /// Generates code for steam game server
  Future<void> generateSteamGameServer({
    required String path,
    Set<String> enumSet = const {},
    Set<String> structSet = const {},
    Set<String> callbackStructSet = const {},
  }) async {
    SteamInitializer gameServer = SteamInitializer(
      name: "SteamGameServer",
      methods: [
        SteamMethod(
          name: "Init",
          nameFlat: "SteamGameServer_Init",
          returnType: "bool",
          params: [
            SteamParam(
              name: "unIP",
              type: "uint32",
            ),
            SteamParam(
              name: "usSteamPort",
              type: "uint16",
            ),
            SteamParam(
              name: "usGamePort",
              type: "uint16",
            ),
            SteamParam(
              name: "usQueryPort",
              type: "uint16",
            ),
            SteamParam(
              name: "eServerMode",
              type: "EServerMode",
            ),
            SteamParam(
              name: "pchVersionString",
              type: "const char *",
            ),
          ],
        ),
        SteamMethod(
          name: "ReleaseCurrentThreadMemory",
          nameFlat: "SteamGameServer_ReleaseCurrentThreadMemory",
          returnType: "void",
        ),
        // SteamMethod(
        //   name: "RunCallbacks",
        //   nameFlat: "SteamGameServer_RunCallbacks",
        //   returnType: "void",
        // ),
        SteamMethod(
          name: "Shutdown",
          nameFlat: "SteamGameServer_Shutdown",
          returnType: "void",
        ),
        SteamMethod(
          name: "GetHSteamPipe",
          nameFlat: "SteamGameServer_GetHSteamPipe",
          returnType: "HSteamPipe",
        ),
        SteamMethod(
          name: "GetHSteamUser",
          nameFlat: "SteamGameServer_GetHSteamUser",
          returnType: "HSteamUser",
        ),
      ],
    );

    await gameServer.generateFile(
      path: path,
      enumSet: enumSet,
      structSet: structSet,
      callbackStructSet: callbackStructSet,
    );
  }

  /// Generates code for dispatch
  Future<void> generateDispatch({
    required String path,
    Set<String> enumSet = const {},
    Set<String> structSet = const {},
    Set<String> callbackStructSet = const {},
  }) async {
    SteamInitializer dispatch = SteamInitializer(
      name: "Dispatch",
      methods: [
        SteamMethod(
          name: "Init",
          nameFlat: "SteamAPI_ManualDispatch_Init",
          returnType: "void",
        ),
        SteamMethod(
          name: "RunFrame",
          nameFlat: "SteamAPI_ManualDispatch_RunFrame",
          returnType: "void",
          params: [
            SteamParam(
              name: "hSteamPipe",
              type: "HSteamPipe",
            ),
          ],
        ),
        SteamMethod(
          name: "GetNextCallback",
          nameFlat: "SteamAPI_ManualDispatch_GetNextCallback",
          returnType: "bool",
          params: [
            SteamParam(
              name: "hSteamPipe",
              type: "HSteamPipe",
            ),
            SteamParam(
              name: "pCallbackMsg",
              type: "CallbackMsg_t *",
            ),
          ],
        ),
        SteamMethod(
          name: "FreeLastCallback",
          nameFlat: "SteamAPI_ManualDispatch_FreeLastCallback",
          returnType: "void",
          params: [
            SteamParam(
              name: "hSteamPipe",
              type: "HSteamPipe",
            ),
          ],
        ),
        SteamMethod(
          name: "GetAPICallResult",
          nameFlat: "SteamAPI_ManualDispatch_GetAPICallResult",
          returnType: "bool",
          params: [
            SteamParam(
              name: "hSteamPipe",
              type: "HSteamPipe",
            ),
            SteamParam(
              name: "hSteamAPICall",
              type: "SteamAPICall_t",
            ),
            SteamParam(
              name: "pCallback",
              type: "void *",
            ),
            SteamParam(
              name: "cubCallback",
              type: "int",
            ),
            SteamParam(
              name: "iCallbackExpected",
              type: "int",
            ),
            SteamParam(
              name: "pbFailed",
              type: "bool *",
            ),
          ],
        ),
      ],
    );

    await dispatch.generateFile(
      path: path,
      enumSet: enumSet,
      structSet: structSet,
      callbackStructSet: callbackStructSet,
    );
  }
}
