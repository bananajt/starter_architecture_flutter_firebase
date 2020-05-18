import 'package:flutter/foundation.dart';
import 'package:starter_architecture_flutter_firebase/app/home/entries/entry_banana.dart';

/// Temporary model class to store the time tracked and pay for a banana
class BananaDetails {
  BananaDetails({
    @required this.name,
    @required this.durationInHours,
    @required this.pay,
  });
  final String name;
  double durationInHours;
  double pay;
}

/// Groups together all bananas/entries on a given day
class DailyBananasDetails {
  DailyBananasDetails({@required this.date, @required this.bananasDetails});
  final DateTime date;
  final List<BananaDetails> bananasDetails;

  double get pay => bananasDetails
      .map((bananaDuration) => bananaDuration.pay)
      .reduce((value, element) => value + element);

  double get duration => bananasDetails
      .map((bananaDuration) => bananaDuration.durationInHours)
      .reduce((value, element) => value + element);

  /// splits all entries into separate groups by date
  static Map<DateTime, List<EntryBanana>> _entriesByDate(List<EntryBanana> entries) {
    Map<DateTime, List<EntryBanana>> map = {};
    for (var entryBanana in entries) {
      final entryDayStart = DateTime(entryBanana.entry.start.year,
          entryBanana.entry.start.month, entryBanana.entry.start.day);
      if (map[entryDayStart] == null) {
        map[entryDayStart] = [entryBanana];
      } else {
        map[entryDayStart].add(entryBanana);
      }
    }
    return map;
  }

  /// maps an unordered list of EntryBanana into a list of DailyBananasDetails with date information
  static List<DailyBananasDetails> all(List<EntryBanana> entries) {
    final byDate = _entriesByDate(entries);
    List<DailyBananasDetails> list = [];
    for (var date in byDate.keys) {
      final entriesByDate = byDate[date];
      final byBanana = _bananasDetails(entriesByDate);
      list.add(DailyBananasDetails(date: date, bananasDetails: byBanana));
    }
    return list.toList();
  }

  /// groups entries by banana
  static List<BananaDetails> _bananasDetails(List<EntryBanana> entries) {
    Map<String, BananaDetails> bananaDuration = {};
    for (var entryBanana in entries) {
      final entry = entryBanana.entry;
      final pay = entry.durationInHours * entryBanana.banana.ratePerHour;
      if (bananaDuration[entry.bananaId] == null) {
        bananaDuration[entry.bananaId] = BananaDetails(
          name: entryBanana.banana.name,
          durationInHours: entry.durationInHours,
          pay: pay,
        );
      } else {
        bananaDuration[entry.bananaId].pay += pay;
        bananaDuration[entry.bananaId].durationInHours += entry.durationInHours;
      }
    }
    return bananaDuration.values.toList();
  }
}
