// TODO(sprint-003): Implement abstract HistoryRepository interface.
//
// Defines the contract for persisting and retrieving history entries.

import 'package:nelli_calc/models/history_entry.dart';

/// Abstract interface for history persistence.
abstract class HistoryRepository {
  /// Loads all saved history entries.
  Future<List<HistoryEntry>> loadAll();

  /// Saves a new [entry] to storage.
  Future<void> save(HistoryEntry entry);

  /// Clears all stored history entries.
  Future<void> clearAll();
}
