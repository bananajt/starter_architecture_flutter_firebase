import 'package:flutter_test/flutter_test.dart';
import 'package:starter_architecture_flutter_firebase/app/home/models/banana.dart';

void main() {
  group('fromMap', () {
    test('null data', () {
      final banana = Banana.fromMap(null, 'abc');
      expect(banana, null);
    });
    test('banana with all properties', () {
      final banana = Banana.fromMap({
        'name': 'Blogging',
        'ratePerHour': 10,
      }, 'abc');
      expect(banana, Banana(name: 'Blogging', ratePerHour: 10, id: 'abc'));
    });

    test('missing name', () {
      final banana = Banana.fromMap({
        'ratePerHour': 10,
      }, 'abc');
      expect(banana, null);
    });
  });

  group('toMap', () {
    test('valid name, ratePerHour', () {
      final banana = Banana(name: 'Blogging', ratePerHour: 10, id: 'abc');
      expect(banana.toMap(), {
        'name': 'Blogging',
        'ratePerHour': 10,
      });
    });
  });
}
