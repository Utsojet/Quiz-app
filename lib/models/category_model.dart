import 'package:html_unescape/html_unescape.dart';

final HtmlUnescape _unescape = HtmlUnescape();

/// Represents a quiz trivia category from OpenTDB.
class Category {
  final int id;
  final String name;

  const Category({
    required this.id,
    required this.name,
  });

  /// Factory constructor to parse category from OpenTDB API JSON.
  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as int? ?? 0,
      name: _unescape.convert(json['name'] as String? ?? 'Unknown'),
    );
  }

  /// Converts Category to JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }

  @override
  String toString() => 'Category(id: $id, name: $name)';
}
