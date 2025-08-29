class BottomNavState {
  final int currentIndex;
  final int notificationCount;

  const BottomNavState({
    this.currentIndex = 0,
    this.notificationCount = 0,
  });

  BottomNavState copyWith({
    int? currentIndex,
    int? notificationCount,
  }) {
    return BottomNavState(
      currentIndex: currentIndex ?? this.currentIndex,
      notificationCount: notificationCount ?? this.notificationCount,
    );
  }
}