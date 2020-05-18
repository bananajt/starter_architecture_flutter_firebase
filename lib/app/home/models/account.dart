import 'dart:ui';

import 'package:meta/meta.dart';

class Account {
  Account({@required this.id, this.displayName, this.photoUrl, this.bio});
  final String id;
  final String displayName;
  final String photoUrl;
  final String bio;

  factory Account.fromMap(Map<String, dynamic> data, String documentId) {
    if (data == null) {
      return null;
    }
    final String displayName = data['displayName'];
    if (displayName == null) {
      return null;
    }
    final String photoUrl = data['photoUrl'];
    if (photoUrl == null) {
      return null;
    }
    final String bio = data['bio'];
    if (bio == null) {
      return null;
    }
    return Account(id: documentId, displayName: displayName, photoUrl: photoUrl, bio: bio);
  }

  Map<String, dynamic> toMap() {
    return {
      'displayName': displayName,
      'photoUrl': photoUrl,
      'bio': bio,
    };
  }

  @override
  int get hashCode => hashValues(id, displayName, photoUrl, bio);

  @override
  bool operator ==(other) {
    if (identical(this, other)) return true;
    if (runtimeType != other.runtimeType) return false;
    final Account otherAccount = other;
    return id == otherAccount.id &&
        displayName == otherAccount.displayName &&
        photoUrl == otherAccount.photoUrl &&
        bio == otherAccount.bio;
  }

  @override
  String toString() => 'id: $id, displayName: $displayName, photoUrl: $photoUrl, bio: $bio';
}
