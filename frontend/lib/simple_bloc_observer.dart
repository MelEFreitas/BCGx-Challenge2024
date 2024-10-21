import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';

/// A custom observer for managing the lifecycle of [Bloc] instances.
///
/// This observer logs lifecycle events for each [Bloc] to the developer console. 
/// It provides hooks to observe when a bloc is created, receives events, 
/// changes state, transitions, encounters errors, and is closed.
///
/// This class overrides the following methods from [BlocObserver]:
/// - [onCreate]
/// - [onEvent]
/// - [onChange]
/// - [onTransition]
/// - [onError]
/// - [onClose]
class SimpleBlocObserver extends BlocObserver {
  
  /// Called when a new [Bloc] is created.
  ///
  /// Logs the type of the created [Bloc].
  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    log('onCreate -- bloc: ${bloc.runtimeType}');
  }

  /// Called when a [Bloc] receives a new event.
  ///
  /// Logs the type of the [Bloc] and the received event.
  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    log('onEvent -- bloc: ${bloc.runtimeType}, event: $event');
  }

  /// Called when a [Bloc] changes its state.
  ///
  /// Logs the type of the [Bloc] and the [Change] representing the state change.
  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    log('onChange -- bloc: ${bloc.runtimeType}, change: $change');
  }

  /// Called when a [Bloc] transitions to a new state.
  ///
  /// Logs the type of the [Bloc] and the [Transition] object containing the 
  /// previous and current states.
  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    log('onChange -- bloc: ${bloc.runtimeType}, transition: $transition');
  }

  /// Called when a [Bloc] encounters an error.
  ///
  /// Logs the type of the [Bloc], the error encountered, and the stack trace.
  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    log('onError -- bloc: ${bloc.runtimeType}, error: $error');
    super.onError(bloc, error, stackTrace);
  }

  /// Called when a [Bloc] is closed.
  ///
  /// Logs the type of the [Bloc] that is being closed.
  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);
    log('onClose -- bloc: ${bloc.runtimeType}');
  }
}

