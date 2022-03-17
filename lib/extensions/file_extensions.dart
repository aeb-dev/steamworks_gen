import "dart:io";

import "string_extensions.dart";

/// Extensions for generating dart class with ease
extension FileExtensions on IOSink {
  /// writes import in a dart file
  void writeImport(String packageName, [String? asName]) {
    write("import \"$packageName\"");
    if (asName != null) {
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
  void writeClass(String className, [String? extend]) {
    write("class $className");
    if (extend != null) {
      write(" extends $extend");
    }
  }

  /// writes an enum declaration
  /// dart does not support assigning values to enums
  /// and since steam has jump between enum values
  /// we create a class until dart adds assigning values to enums
  /// write("enum $enumName");
  void writeEnum(String enumName) {
    writeClass(enumName);
  }

  /// writes a field of a struct
  void writeStructField(
    String fieldName,
    String fieldType,
    String annotation, {
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
  void writeTypedef(String alias, String of) {
    write("typedef $alias = $of;");
  }

  /// writes a constant
  void writeConst(String type, String name, String value, bool isStatic) {
    if (isStatic) {
      write("static ");
    }
    write("const $type $name = $value;");
  }

  /// writes an extension class
  void writeExtension(String extensionName, String on) {
    write("extension ");
    if (extensionName.isNotEmpty) {
      write("$extensionName ");
    }

    write("on $on");
  }

  /// writes import according its type
  void importType(
    String type,
    Set<String> enumSet,
    Set<String> structSet,
    Set<String> callbackStructSet,
    Set<String> interfaceSet,
  ) {
    bool isEnum = enumSet.contains(type);
    if (isEnum) {
      writeImport("../enums/${type.toFileName()}.dart");
      return;
    }

    bool isStruct = structSet.contains(type);
    if (isStruct) {
      writeImport("../structs/${type.toFileName()}.dart");
      return;
    }

    bool iscallbackStruct = callbackStructSet.contains(type);
    if (iscallbackStruct) {
      writeImport("../callback_structs/${type.toFileName()}.dart");
      return;
    }

    bool isInterface = interfaceSet.contains(type);
    if (isInterface) {
      writeImport(
        "../interfaces/${type.clearInterfaceName().toFileName()}.dart",
      );
      return;
    }
  }
}
