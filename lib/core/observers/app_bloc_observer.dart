import 'package:bloc/bloc.dart';

/// Uygulama genelinde Bloc transition ve hata gözlemi.
class AppBlocObserver extends BlocObserver {
  @override
  void onTransition(Bloc<dynamic, dynamic> bloc, Transition<dynamic, dynamic> transition) {
    // Debug amaçlı sade log (gerekirse dev/prod ayrıştırılabilir)
    // ignore: avoid_print
    print(
      '[BLOC][TRANSITION] ${bloc.runtimeType} => ${transition.event.runtimeType} : ${transition.nextState.runtimeType}',
    );
    super.onTransition(bloc, transition);
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    // ignore: avoid_print
    print('[BLOC][ERROR] ${bloc.runtimeType} => $error');
    super.onError(bloc, error, stackTrace);
  }
}
