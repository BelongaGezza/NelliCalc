import 'package:flutter_test/flutter_test.dart';
import 'package:nelli_calc/models/history_entry.dart';

void main() {
  group('HistoryEntry', () {
    test('generates UUID and timestamp when not provided', () {
      final entry = HistoryEntry(expression: '2 + 3', result: 5);

      expect(entry.id, isNotEmpty);
      // UUID v4 format: 8-4-4-4-12 hex characters
      expect(
        entry.id,
        matches(
          RegExp(
            r'^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$',
          ),
        ),
      );
      expect(entry.timestamp, isA<DateTime>());
    });

    test('uses provided id and timestamp', () {
      final timestamp = DateTime.utc(2026, 2, 11, 14, 30);
      final entry = HistoryEntry(
        id: 'custom-id',
        expression: '2 + 3',
        result: 5,
        timestamp: timestamp,
      );

      expect(entry.id, 'custom-id');
      expect(entry.timestamp, timestamp);
    });

    test('generates unique IDs for different instances', () {
      final a = HistoryEntry(expression: '2 + 3', result: 5);
      final b = HistoryEntry(expression: '2 + 3', result: 5);

      expect(a.id, isNot(equals(b.id)));
    });

    group('displayValue', () {
      test('returns integer string for whole numbers', () {
        final entry = HistoryEntry(expression: '2 + 3', result: 5);
        expect(entry.displayValue, '5');
      });

      test('returns integer string for zero', () {
        final entry = HistoryEntry(expression: '5 - 5', result: 0);
        expect(entry.displayValue, '0');
      });

      test('returns decimal string for fractional results', () {
        final entry = HistoryEntry(expression: '1 / 3', result: 3.14);
        expect(entry.displayValue, '3.14');
      });

      test('returns integer string for negative whole numbers', () {
        final entry = HistoryEntry(expression: '3 - 5', result: -2);
        expect(entry.displayValue, '-2');
      });

      test('returns decimal string for negative fractional results', () {
        final entry = HistoryEntry(expression: '0 - 1.5', result: -1.5);
        expect(entry.displayValue, '-1.5');
      });
    });

    group('copyWith', () {
      late HistoryEntry original;

      setUp(() {
        original = HistoryEntry(
          id: 'test-id',
          expression: '2 + 3',
          result: 5,
          timestamp: DateTime.utc(2026, 2, 11),
        );
      });

      test('copies with no changes', () {
        final copy = original.copyWith();

        expect(copy.id, original.id);
        expect(copy.expression, original.expression);
        expect(copy.result, original.result);
        expect(copy.timestamp, original.timestamp);
      });

      test('copies with expression changed', () {
        final copy = original.copyWith(expression: '10 * 2');
        expect(copy.expression, '10 * 2');
        expect(copy.id, original.id);
      });

      test('copies with result changed', () {
        final copy = original.copyWith(result: 42);
        expect(copy.result, 42);
        expect(copy.expression, original.expression);
      });

      test('copies with id changed', () {
        final copy = original.copyWith(id: 'new-id');
        expect(copy.id, 'new-id');
      });

      test('copies with timestamp changed', () {
        final newTimestamp = DateTime.utc(2026, 3);
        final copy = original.copyWith(timestamp: newTimestamp);
        expect(copy.timestamp, newTimestamp);
      });
    });

    group('toJson / fromJson', () {
      test('round-trips correctly', () {
        final original = HistoryEntry(
          id: 'abc-123',
          expression: '12 + 3.14',
          result: 15.14,
          timestamp: DateTime.utc(2026, 2, 11, 14, 30),
        );

        final json = original.toJson();
        final restored = HistoryEntry.fromJson(json);

        expect(restored.id, original.id);
        expect(restored.expression, original.expression);
        expect(restored.result, original.result);
        expect(restored.timestamp, original.timestamp);
      });

      test('toJson produces expected map', () {
        final entry = HistoryEntry(
          id: 'abc-123',
          expression: '42 * 2',
          result: 84,
          timestamp: DateTime.utc(2026, 2, 11, 14, 30),
        );

        expect(entry.toJson(), {
          'id': 'abc-123',
          'expression': '42 * 2',
          'result': 84.0,
          'timestamp': '2026-02-11T14:30:00.000Z',
        });
      });

      test('fromJson handles integer result from JSON', () {
        final entry = HistoryEntry.fromJson(const {
          'id': 'abc-123',
          'expression': '2 + 3',
          'result': 5, // int, not double
          'timestamp': '2026-02-11T14:30:00.000Z',
        });

        expect(entry.result, 5.0);
        expect(entry.result, isA<double>());
      });
    });

    group('equality', () {
      test('equal when all fields match', () {
        final timestamp = DateTime.utc(2026, 2, 11);
        final a = HistoryEntry(
          id: 'same-id',
          expression: '2 + 3',
          result: 5,
          timestamp: timestamp,
        );
        final b = HistoryEntry(
          id: 'same-id',
          expression: '2 + 3',
          result: 5,
          timestamp: timestamp,
        );

        expect(a, equals(b));
        expect(a.hashCode, equals(b.hashCode));
      });

      test('not equal when id differs', () {
        final timestamp = DateTime.utc(2026, 2, 11);
        final a = HistoryEntry(
          id: 'id-a',
          expression: '2 + 3',
          result: 5,
          timestamp: timestamp,
        );
        final b = HistoryEntry(
          id: 'id-b',
          expression: '2 + 3',
          result: 5,
          timestamp: timestamp,
        );

        expect(a, isNot(equals(b)));
      });

      test('not equal when expression differs', () {
        final timestamp = DateTime.utc(2026, 2, 11);
        final a = HistoryEntry(
          id: 'same-id',
          expression: '2 + 3',
          result: 5,
          timestamp: timestamp,
        );
        final b = HistoryEntry(
          id: 'same-id',
          expression: '3 + 2',
          result: 5,
          timestamp: timestamp,
        );

        expect(a, isNot(equals(b)));
      });
    });
  });
}
