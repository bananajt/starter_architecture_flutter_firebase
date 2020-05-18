import 'dart:ui';

import 'package:meta/meta.dart';

class Banana {
  Banana({@required this.id, @required this.name, @required this.ratePerHour, @required this.description});
  final String id;
  final String name;
  final int ratePerHour;
  final String description;

  factory Banana.fromMap(Map<String, dynamic> data, String documentId) {
    if (data == null) {
      return null;
    }
    final String name = data['name'];
    if (name == null) {
      return null;
    }
    final int ratePerHour = data['ratePerHour'];
    final String description = data['description'];
    if (description == null) {
      return null;
    }
    return Banana(id: documentId, name: name, ratePerHour: ratePerHour, description: description);
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'ratePerHour': ratePerHour,
      'description': description,
    };
  }

  @override
  int get hashCode => hashValues(id, name, ratePerHour, description);

  @override
  bool operator ==(other) {
    if (identical(this, other)) return true;
    if (runtimeType != other.runtimeType) return false;
    final Banana otherBanana = other;
    return id == otherBanana.id &&
        name == otherBanana.name &&
        ratePerHour == otherBanana.ratePerHour &&
        description == otherBanana.description;
  }

  @override
  String toString() => 'id: $id, name: $name, ratePerHour: $ratePerHour, description: $description';
}
