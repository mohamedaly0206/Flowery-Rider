sealed class BaseEvent {
  const BaseEvent();
}

class DisplayError extends BaseEvent {
  final String message;
  const DisplayError(this.message);
}

class DisplaySuccess extends BaseEvent {
  final String message;
  const DisplaySuccess(this.message);
}

class NavigateEvent extends BaseEvent {
  final String routeName;
  const NavigateEvent(this.routeName);
}
