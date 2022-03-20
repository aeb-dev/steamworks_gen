/// Field definition for steam api
class SteamField {
  /// name of the field
  late String name;

  /// c type of the field
  late String type;

  /// whether it is private
  late bool private;

  /// Creates a [SteamField]. This constructor is used
  /// for manual [SteamField] creation
  SteamField({
    required this.name,
    required this.type,
    this.private = false,
  });

  /// Creates a [SteamField] from json
  SteamField.fromJson(Map<String, dynamic> json) {
    name = json["fieldname"];
    type = json["fieldtype"];
    private = json["private"] ?? false;
  }
}
