class UserItemEntity {
  UserItemEntity(
    this.price,
    this.note,
    this.imgUrl, {
    required this.id,
    required this.title,
    required this.category,
    this.createdAt,
    this.owners = const [],
    this.createdBy = '',
  });

  final String id;
  final String title;
  final String category;
  final double price;
  final String note;
  final String imgUrl;
  final DateTime? createdAt;
  final List<String> owners;
  final String createdBy;
}
