abstract class ItemGetEvent {}

class FetchItemDetail extends ItemGetEvent {
  FetchItemDetail(this.id);
  final String id;
}
