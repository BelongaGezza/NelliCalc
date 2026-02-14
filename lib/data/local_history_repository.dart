// TODO(sprint-003): Implement LocalHistoryRepository with local storage.
//
// Concrete implementation of HistoryRepository that persists history
// entries to local device storage.

import 'package:nelli_calc/data/history_repository.dart';
import 'package:nelli_calc/models/history_entry.dart';

/// Local-storage implementation of [HistoryRepository].
class LocalHistoryRepository implements HistoryRepository {
  /// Creates a [LocalHistoryRepository].
  const LocalHistoryRepository();

  @override
  Future<List<HistoryEntry>> loadAll() async {
    // TODO(sprint-003): Implement local storage load.
    return [];
  }

  @override
  Future<void> save(HistoryEntry entry) async {
    // TODO(sprint-003): Implement local storage save.
  }

  @override
  Future<void> clearAll() async {
    // TODO(sprint-003): Implement local storage clear.
  }
}
