import "dart:io";

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
  void writeStructField(String fieldName, String fieldType, String annotation) {
    if (annotation.isNotEmpty) {
      write("@$annotation ");
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
}
