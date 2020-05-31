import 'dart:convert';

class ChuckResponse {
  final String icon_url;
  final String id;
  final String url;
  final String value;
  final String categories;

  ChuckResponse(this.icon_url, this.id, this.url, this.value, this.categories);



  Map<String, dynamic> toMap() {
    return {
      'icon_url': icon_url,
      'id': id,
      'url': url,
      'value': value,
    };
  }

  static ChuckResponse fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    var map2 = map['categories'] as List<dynamic>;
    String categorie = ' - ';
    if (map2.length > 0) {
      categorie = map2[0];
    }
        return ChuckResponse(
          map['icon_url'],
          map['id'],
          map['url'],
          map['value'],
          categorie
    );
  }

  String toJson() => json.encode(toMap());

  static ChuckResponse fromJson(String source) => fromMap(json.decode(source));
}
