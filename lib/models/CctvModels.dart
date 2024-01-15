import 'dart:convert';

class CCTVModel {
  String? name;
  String? detail;
  String? provine;
  String? type;
  String? url;
  String? lat;
  String? long;
  String? distance;
  CCTVModel({
    this.name,
    this.detail,
    this.provine,
    this.type,
    this.url,
    this.lat,
    this.long,
    this.distance,
  });

  CCTVModel copyWith({
    String? name,
    String? detail,
    String? provine,
    String? type,
    String? url,
    String? lat,
    String? long,
    String? distance,
  }) {
    return CCTVModel(
      name: name ?? this.name,
      detail: detail ?? this.detail,
      provine: provine ?? this.provine,
      type: type ?? this.type,
      url: url ?? this.url,
      lat: lat ?? this.lat,
      long: long ?? this.long,
      distance: distance ?? this.distance,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    if (name != null) {
      result.addAll({'name': name});
    }
    if (detail != null) {
      result.addAll({'detail': detail});
    }
    if (provine != null) {
      result.addAll({'provine': provine});
    }
    if (type != null) {
      result.addAll({'type': type});
    }
    if (url != null) {
      result.addAll({'url': url});
    }
    if (lat != null) {
      result.addAll({'lat': lat});
    }
    if (long != null) {
      result.addAll({'long': long});
    }
    if (distance != null) {
      result.addAll({'distance': distance});
    }

    return result;
  }

  factory CCTVModel.fromMap(Map<String, dynamic> map) {
    return CCTVModel(
      name: map['name'],
      detail: map['detail'],
      provine: map['provine'],
      type: map['type'],
      url: map['url'],
      lat: map['lat'],
      long: map['long'],
      distance: map['distance'],
    );
  }

  String toJson() => json.encode(toMap());

  factory CCTVModel.fromJson(String source) =>
      CCTVModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'CCTVModel(name: $name, detail: $detail, provine: $provine, type: $type, url: $url, lat: $lat, long: $long, distance: $distance)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CCTVModel &&
        other.name == name &&
        other.detail == detail &&
        other.provine == provine &&
        other.type == type &&
        other.url == url &&
        other.lat == lat &&
        other.long == long &&
        other.distance == distance;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        detail.hashCode ^
        provine.hashCode ^
        type.hashCode ^
        url.hashCode ^
        lat.hashCode ^
        long.hashCode ^
        distance.hashCode;
  }
}
