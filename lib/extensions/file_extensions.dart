import "dart:io";

import "string_extensions.dart";

/// Extensions for generating dart class with ease
extension FileExtensions on IOSink {
  /// writes import in a dart file
  void writeImport({
    required String packageName,
    String asName = "",
  }) {
    write("import \"$packageName\"");
    if (asName.isNotEmpty) {
      write(" as $asName");
    }
    write(";");
  }

  /// starts a code block or a class body, etc.
  void writeStartBlock() {
    write("{");
  }

  /// ends a code block or a class body, etc.
  void writeEndBlock() {
    write("}");
  }

  /// writes a class declaration
  void writeClass({
    required String className,
    String extend = "",
  }) {
    write("class $className");
    if (extend.isNotEmpty) {
      write(" extends $extend");
    }
  }

  /// writes an enum declaration
  /// dart does not support assigning values to enums
  /// and since steam has jump between enum values
  /// we create a class until dart adds assigning values to enums
  /// write("enum $enumName");
  void writeEnum({
    required String enumName,
  }) {
    writeClass(
      className: enumName,
    );
  }

  /// writes a field of a struct
  void writeStructField({
    required String fieldName,
    required String fieldType,
    String annotation = "",
    bool isPrivate = false,
  }) {
    if (annotation.isNotEmpty) {
      writeln("@$annotation ");
    }

    if (isPrivate) {
      fieldName = "_$fieldName";
      writeln("  // ignore: unused_field");
    }

    writeln("external $fieldType $fieldName;\n");
  }

  /// writes a typedef
  void writeTypedef({
    required String alias,
    required String of,
  }) {
    write("typedef $alias = $of;");
  }

  /// writes a constant
  void writeConst({
    required String type,
    required String name,
    required String value,
    bool isStatic = false,
  }) {
    if (isStatic) {
      write("static ");
    }
    write("const $type $name = $value;");
  }

  /// writes an extension class
  void writeExtension({
    String extensionName = "",
    required String on,
  }) {
    write("extension ");
    if (extensionName.isNotEmpty) {
      write("$extensionName ");
    }

    write("on $on");
  }

  /// writes import according its type
  void importType({
    required String type,
    Set<String> enumSet = const {},
    Set<String> structSet = const {},
    Set<String> callbackStructSet = const {},
    Set<String> interfaceSet = const {},
  }) {
    bool isEnum = enumSet.contains(type);
    if (isEnum) {
      writeImport(
        packageName: "../enums/${type.toFileName()}.dart",
      );
      return;
    }

    bool isStruct = structSet.contains(type);
    if (isStruct) {
      writeImport(
        packageName: "../structs/${type.toFileName()}.dart",
      );
      return;
    }

    bool iscallbackStruct = callbackStructSet.contains(type);
    if (iscallbackStruct) {
      writeImport(
        packageName: "../callback_structs/${type.toFileName()}.dart",
      );
      return;
    }

    bool isInterface = interfaceSet.contains(type);
    if (isInterface) {
      writeImport(
        packageName:
            "../interfaces/${type.clearInterfaceName().toFileName()}.dart",
      );
      return;
    }
  }
}
