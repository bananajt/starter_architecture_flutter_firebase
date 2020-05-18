import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:starter_architecture_flutter_firebase/app/home/entries/daily_bananas_details.dart';
import 'package:starter_architecture_flutter_firebase/app/home/entries/entries_list_tile.dart';
import 'package:starter_architecture_flutter_firebase/app/home/entries/entry_banana.dart';
import 'package:starter_architecture_flutter_firebase/app/home/banana_entries/format.dart';
import 'package:starter_architecture_flutter_firebase/app/home/models/entry.dart';
import 'package:starter_architecture_flutter_firebase/app/home/models/banana.dart';
import 'package:starter_architecture_flutter_firebase/services/firestore_database.dart';

class EntriesViewModel {
  EntriesViewModel({@required this.database});
  final FirestoreDatabase database;

  /// combine List<Banana>, List<Entry> into List<EntryBanana>
  Stream<List<EntryBanana>> get _allEntriesStream => CombineLatestStream.combine2(
        database.entriesStream(),
        database.bananasStream(),
        _entriesBananasCombiner,
      );

  static List<EntryBanana> _entriesBananasCombiner(
      List<Entry> entries, List<Banana> bananas) {
    return entries.map((entry) {
      final banana = bananas.firstWhere((banana) => banana.id == entry.bananaId);
      return EntryBanana(entry, banana);
    }).toList();
  }

  /// Output stream
  Stream<List<EntriesListTileModel>> get entriesTileModelStream =>
      _allEntriesStream.map(_createModels);

  static List<EntriesListTileModel> _createModels(List<EntryBanana> allEntries) {
    if (allEntries.isEmpty) {
      return [];
    }
    final allDailyBananasDetails = DailyBananasDetails.all(allEntries);

    // total duration across all bananas
    final totalDuration = allDailyBananasDetails
        .map((dateBananasDuration) => dateBananasDuration.duration)
        .reduce((value, element) => value + element);

    // total pay across all bananas
    final totalPay = allDailyBananasDetails
        .map((dateBananasDuration) => dateBananasDuration.pay)
        .reduce((value, element) => value + element);

    return <EntriesListTileModel>[
      EntriesListTileModel(
        leadingText: 'All Entries',
        middleText: Format.currency(totalPay),
        trailingText: Format.hours(totalDuration),
      ),
      for (DailyBananasDetails dailyBananasDetails in allDailyBananasDetails) ...[
        EntriesListTileModel(
          isHeader: true,
          leadingText: Format.date(dailyBananasDetails.date),
          middleText: Format.currency(dailyBananasDetails.pay),
          trailingText: Format.hours(dailyBananasDetails.duration),
        ),
        for (BananaDetails bananaDuration in dailyBananasDetails.bananasDetails)
          EntriesListTileModel(
            leadingText: bananaDuration.name,
            middleText: Format.currency(bananaDuration.pay),
            trailingText: Format.hours(bananaDuration.durationInHours),
          ),
      ]
    ];
  }
}
