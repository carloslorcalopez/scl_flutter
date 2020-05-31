import 'dart:convert';

class ChuckResponse {
  final String icon_url;
  final String id;
  final String url;
  final String value;

  ChuckResponse(this.icon_url, this.id, this.url, this.value);



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
  
    return ChuckResponse(
      map['icon_url'],
      map['id'],
      map['url'],
      map['value'],
    );
  }

  String toJson() => json.encode(toMap());

  static ChuckResponse fromJson(String source) => fromMap(json.decode(source));
}
