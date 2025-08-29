abstract class BottomNavEvent {}

class BottomNavTabChanged extends BottomNavEvent {
  final int index;
  BottomNavTabChanged(this.index);
}

class BottomNavBadgeUpdated extends BottomNavEvent {
  final int count;
  BottomNavBadgeUpdated(this.count);
}