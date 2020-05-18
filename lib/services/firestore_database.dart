import 'dart:async';

import 'package:meta/meta.dart';
import 'package:starter_architecture_flutter_firebase/app/home/models/entry.dart';
import 'package:starter_architecture_flutter_firebase/app/home/models/banana.dart';
import 'package:starter_architecture_flutter_firebase/app/home/models/account.dart';
import 'package:starter_architecture_flutter_firebase/services/firestore_path.dart';
import 'package:starter_architecture_flutter_firebase/services/firestore_service.dart';

String documentIdFromCurrentDate() => DateTime.now().toIso8601String();

class FirestoreDatabase {
  FirestoreDatabase({@required this.uid}) : assert(uid != null);
  final String uid;

  final _service = FirestoreService.instance;

  Future<void> setBanana(Banana banana) async => await _service.setData(
        path: FirestorePath.banana(uid, banana.id),
        data: banana.toMap(),
      );

  Future<void> deleteBanana(Banana banana) async {
    // delete where entry.bananaId == banana.bananaId
    final allEntries = await entriesStream(banana: banana).first;
    for (Entry entry in allEntries) {
      if (entry.bananaId == banana.id) {
        await deleteEntry(entry);
      }
    }
    // delete banana
    await _service.deleteData(path: FirestorePath.banana(uid, banana.id));
  }

  Stream<Banana> bananaStream({@required String bananaId}) => _service.documentStream(
        path: FirestorePath.banana(uid, bananaId),
        builder: (data, documentId) => Banana.fromMap(data, documentId),
      );

  Stream<List<Banana>> bananasStream() => _service.collectionStream(
        path: FirestorePath.bananas(uid),
        builder: (data, documentId) => Banana.fromMap(data, documentId),
      );

  Future<void> setAccount(Account account) async => await _service.setData(
        path: FirestorePath.account(uid, account.id),
        data: account.toMap(),
      );

  Future<void> deleteAccount(Account account) async =>
      await _service.deleteData(path: FirestorePath.account(uid, account.id));

  Stream<Account> accountStream({@required String accountId}) => _service.documentStream(
        path: FirestorePath.account(uid, accountId),
        builder: (data, documentId) => Account.fromMap(data, documentId),
      );

  Stream<List<Account>> accountsStream() => _service.collectionStream(
        path: FirestorePath.accounts(uid),
        builder: (data, documentId) => Account.fromMap(data, documentId),
      );

  Future<void> setEntry(Entry entry) async => await _service.setData(
        path: FirestorePath.entry(uid, entry.id),
        data: entry.toMap(),
      );

  Future<void> deleteEntry(Entry entry) async =>
      await _service.deleteData(path: FirestorePath.entry(uid, entry.id));

  Stream<List<Entry>> entriesStream({Banana banana}) =>
      _service.collectionStream<Entry>(
        path: FirestorePath.entries(uid),
        queryBuilder: banana != null
            ? (query) => query.where('bananaId', isEqualTo: banana.id)
            : null,
        builder: (data, documentID) => Entry.fromMap(data, documentID),
        sort: (lhs, rhs) => rhs.start.compareTo(lhs.start),
      );
}
