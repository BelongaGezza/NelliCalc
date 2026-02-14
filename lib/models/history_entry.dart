import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

/// A single completed calculation stored in the history list.
///
/// Each entry has a stable [id] (UUID v4) that persists across
/// drag operations, serialisation, and app restarts.
///
/// Example:
/// ```dart
/// final entry = HistoryEntry(
///   expression: '12 + 3',
///   result: 15,
/// );
/// ```
class HistoryEntry extends Equatable {
  /// Creates a [HistoryEntry].
  ///
  /// Generates a UUID v4 [id] and captures [DateTime.now] for
  /// [timestamp] by default. Explicit values can be provided for
  /// deserialisation and testing.
  HistoryEntry({
    required this.expression,
    required this.result,
    String? id,
    DateTime? timestamp,
  }) : id = id ?? const Uuid().v4(),
       timestamp = timestamp ?? DateTime.now();

  /// Deserialises a [HistoryEntry] from a JSON-compatible map.
  factory HistoryEntry.fromJson(Map<String, dynamic> json) {
    return HistoryEntry(
      id: json['id'] as String,
      expression: json['expression'] as String,
      result: (json['result'] as num).toDouble(),
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  /// Unique identifier (UUID v4).
  ///
  /// Used by Flutter to track draggable items across the widget tree
  /// and by the persistence layer to identify entries.
  final String id;

  /// The expression that produced this result (e.g., `'12 + 3.14'`).
  final String expression;

  /// The evaluated result value.
  final double result;

  /// When the calculation was performed (UTC).
  final DateTime timestamp;

  /// The result formatted for display and drag-and-drop.
  ///
  /// Returns an integer string if the result has no fractional part
  /// (e.g., `'42'` instead of `'42.0'`), otherwise the full double
  /// string (e.g., `'3.14'`).
  String get displayValue {
    return result == result.truncateToDouble()
        ? result.toInt().toString()
        : result.toString();
  }

  /// Creates a copy of this entry with the given fields replaced.
  HistoryEntry copyWith({
    String? id,
    String? expression,
    double? result,
    DateTime? timestamp,
  }) {
    return HistoryEntry(
      id: id ?? this.id,
      expression: expression ?? this.expression,
      result: result ?? this.result,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  /// Serialises this entry to a JSON-compatible map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'expression': expression,
      'result': result,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [id, expression, result, timestamp];
}
