import 'package:bloc/bloc.dart';
import 'package:wedlist/core/logging/app_logger.dart';

/// Uygulama genelinde Bloc transition ve hata gözlemi.
class AppBlocObserver extends BlocObserver {
  @override
  void onTransition(
    Bloc<dynamic, dynamic> bloc,
    Transition<dynamic, dynamic> transition,
  ) {
    AppLogger.blocTransition(
      bloc.runtimeType.toString(),
      transition.event.runtimeType.toString(),
      transition.nextState.runtimeType.toString(),
    );
    super.onTransition(bloc, transition);
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    AppLogger.blocError(
      bloc.runtimeType.toString(),
      error,
      stackTrace,
    );
    super.onError(bloc, error, stackTrace);
  }
}
