/// Token representation of any steam type in steam api json file
/// This class holds corresponding values for a steam type that will
/// be used in code generation
class Token {
  /// type to be used in common dart functions. i.e. int, bool etc.
  final String typeDart;

  /// type to be used in dart part of ffi. i.e. int, bool, EnumAlias
  final String typeFfiDart;

  /// type to be used in C part of ffi. i.e. Int, Bool, EnumAlias
  final String typeFfiC;

  /// annotation of the current type. i.e Int()
  final String typeAnnotation;

  /// accessor of the current type. Currently this only changes for Enums
  /// for example: C returns enums as integer, to be developer friendly
  /// code is generated so that the integer values is returned as Dart enums
  /// i.e. EnumType.fromValue(integeValue)
  final String fieldAccessor;

  /// caller of the current type. Current this only changes for Enums. It is counterpart
  /// of the field accessor. i.e. EnumType.value
  final String caller;

  /// [TokenType] of the token
  final TokenType tokenType;

  /// const constructor
  const Token({
    required this.typeDart,
    required this.typeFfiDart,
    required this.typeFfiC,
    required this.typeAnnotation,
    required this.fieldAccessor,
    required this.caller,
    required this.tokenType,
  });
}

/// Type of the [Token]
enum TokenType {
  /// int, char, bool etc. (except string)
  primitive,

  /// enum
  enums,

  /// typedef
  typedefs,

  /// struct or interface
  structOrInterface,

  /// function
  function,
}
