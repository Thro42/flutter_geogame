import 'package:cloud_firestore/cloud_firestore.dart';

class Cache {
  String id;
  String icon;
  String description;
  String header;
  bool visible;
  bool found;
  bool is_final;
  String found_by;
  String schow_for;
  String bild;
  GeoPoint coordinates;
  String symbolId;
  String code;

  Cache(
      this.id,
      this.icon,
      this.description,
      this.header,
      this.visible,
      this.found,
      this.found_by,
      this.schow_for,
      this.code,
      this.is_final,
      this.coordinates);

  Cache copyWith(
      {String id,
      String icon,
      String description,
      String header,
      bool visible,
      bool found,
      String found_by,
      String schow_for,
      String code,
      String is_final,
      GeoPoint coordinates}) {
    return Cache(
        id ?? this.id,
        icon ?? this.icon,
        description ?? this.description,
        header ?? this.header,
        visible ?? this.visible,
        found ?? this.found,
        found_by ?? this.found_by,
        schow_for ?? this.schow_for,
        code ?? this.code,
        is_final ?? this.is_final,
        coordinates ?? this.coordinates);
  }

  static Cache fromSnapshot(DocumentSnapshot snap) {
    return Cache(
      snap.documentID,
      snap.data['icon'],
      snap.data['description'],
      snap.data['header'],
      snap.data['visible'],
      snap.data['found'],
      snap.data['found_by'],
      snap.data['schow_for'],
      snap.data['code'],
      snap.data['is_final'],
      snap.data['coordinates'],
    );
  }

  String toString() {
    return 'Cache{id: $id, icon: $icon, description: $description, header: $header, symbolId: $symbolId}';
  }

  Map<String, Object> toDocument() {
    return {
      "id": id,
      "icon": icon,
      "description": description,
      "header": header,
      "visible": visible,
      "found": found,
      "found_by": found_by,
      "schow_for": schow_for,
      "code": code,
      "is_final": is_final,
      "coordinates": coordinates,
    };
  }
}
