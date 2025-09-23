import 'dart:async';

/// Basit bir publish/subscribe event bus. Ülke değişimi gibi global refresh tetiklerinde kullanılır.
class RefreshBus {
  final _controller = StreamController<RefreshEvent>.broadcast();
  Stream<RefreshEvent> get stream => _controller.stream;

  void publish(RefreshEvent event) => _controller.add(event);
  void countryChanged() =>
      publish(const RefreshEvent(RefreshEventType.countryChanged));
  void dispose() => _controller.close();
}

enum RefreshEventType { countryChanged }

class RefreshEvent {
  const RefreshEvent(this.type);
  final RefreshEventType type;
}
