part of 'sign_in_cubit.dart';

sealed class SignInState extends Equatable {
  const SignInState();

  @override
  List<Object> get props => [];
}

class SignInStateInitial extends SignInState {}

class SignInStateLoading extends SignInState {}

class SignInStateSuccess extends SignInState {}

class SignInStateFailure extends SignInState {
  const SignInStateFailure({required this.errorMessage});

  final String errorMessage;

  @override
  List<Object> get props => [errorMessage];
}
