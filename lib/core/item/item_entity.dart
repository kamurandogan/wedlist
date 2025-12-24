class ItemEntity {
  ItemEntity({
    required this.id,
    required this.title,
    required this.category,
    this.isPendingSync = false,
    this.isPendingDelete = false,
    this.lastSyncedAt,
  });

  final String id;
  final String title;
  final String category;
  // Offline sync metadata
  final bool isPendingSync;
  final bool isPendingDelete;
  final DateTime? lastSyncedAt;

  ItemEntity copyWith({
    String? id,
    String? title,
    String? category,
    bool? isPendingSync,
    bool? isPendingDelete,
    DateTime? lastSyncedAt,
  }) {
    return ItemEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      isPendingSync: isPendingSync ?? this.isPendingSync,
      isPendingDelete: isPendingDelete ?? this.isPendingDelete,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
    );
  }
}
