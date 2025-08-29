import 'package:bloc/bloc.dart';
import 'package:feed_app/app/features/bottom_nav/presentation/bloc/bottom_nav_events.dart';
import 'package:feed_app/app/features/bottom_nav/presentation/bloc/bottom_nav_state.dart';

class BottomNavBloc extends Bloc<BottomNavEvent, BottomNavState> {
  BottomNavBloc() : super(const BottomNavState()) {
    on<BottomNavTabChanged>(_onTabChanged);
  }

  void _onTabChanged(BottomNavTabChanged event, Emitter<BottomNavState> emit) {
    emit(state.copyWith(currentIndex: event.index));
  }
}
