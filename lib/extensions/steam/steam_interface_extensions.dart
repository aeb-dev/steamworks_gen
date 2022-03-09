import "dart:io";

import "package:path/path.dart" as p;

import "../../steam/steam_field.dart";
import "../../steam/steam_interface.dart";
import "../../steam/steam_method.dart";
import "../../steam/steam_param.dart";
import "../file_extensions.dart";
import "../string_extensions.dart";
import "steam_accessor_extensions.dart";
import "steam_enum_extensions.dart";
import "steam_field_extensions.dart";
import "steam_method_extensions.dart";

/// Extensions on [SteamInterface] to generate ffi code
extension SteamInterfaceExtensions on SteamInterface {
  /// Generates necessary code for a [SteamInterface]
  Future<void> generate(
    IOSink fileSink,
    Set<String> enumSet,
    Set<String> structSet,
    Set<String> callbackStructSet,
    Set<String> interfaceSet,
  ) async {
    fileSink.writeImport("dart:ffi");
    fileSink.writeImport("package:ffi/ffi.dart");
    fileSink.writeImport("../steam_api.dart");
    fileSink.writeImport("../typedefs.dart");

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

      bool isCallbackStruct = callbackStructSet.contains(checkType);
      if (isCallbackStruct) {
        fileSink
            .writeImport("../callback_structs/${checkType.toFileName()}.dart");
        // continue;
      }

      bool isInterface = interfaceSet.contains(checkType);
      if (isInterface) {
        fileSink.writeImport(
          "../interfaces/${checkType.clearInterfaceName().toFileName()}.dart",
        );
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

      bool isInterface = interfaceSet.contains(checkType);
      if (isInterface) {
        fileSink.writeImport(
          "../interfaces/${checkType.clearInterfaceName().toFileName()}.dart",
        );
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

        bool isInterface = interfaceSet.contains(checkType);
        if (isInterface) {
          fileSink.writeImport(
            "../interfaces/${checkType.clearInterfaceName().toFileName()}.dart",
          );
          // continue;
        }
      }
    }

    String correctedName = name.clearSteamNaming().clearInterfaceName();

    fileSink.writeClass(correctedName, "Opaque");
    fileSink.writeStartBlock();

    await accessors.generate(fileSink, correctedName);

    fileSink.writeEndBlock();

    await fields.generate(fileSink);

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
  }
}

/// Extensions on [Iterable<SteamInterface>] to generate ffi code
extension SteamInterfaceIterableExtensions on Iterable<SteamInterface> {
  /// Creates a file for each [SteamInterface] and generates respective code
  Future<void> generate(
    String path,
    Set<String> enumSet,
    Set<String> structSet,
    Set<String> callbackStructSet,
    Set<String> interfaceSet,
  ) async {
    for (SteamInterface interface in this) {
      await interface.enums.generate(path);

      String fileName = interface.name.clearInterfaceName().toFileName();
      String filePath = p.join(path, "interfaces", "$fileName.dart");
      File file = File(filePath);
      await file.create(recursive: true);

      IOSink fileSink = file.openWrite(mode: FileMode.writeOnly);
      await interface.generate(
        fileSink,
        enumSet,
        structSet,
        callbackStructSet,
        interfaceSet,
      );

      await fileSink.flush();
      await fileSink.close();
    }
  }
}
