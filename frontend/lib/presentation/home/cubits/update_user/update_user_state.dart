part of 'update_user_cubit.dart';

sealed class UpdateUserState extends Equatable {
  const UpdateUserState();

  @override
  List<Object> get props => [];
}

class UpdateUserStateInitial extends UpdateUserState {}

class UpdateUserStateLoading extends UpdateUserState {}

class UpdateUserStateSuccess extends UpdateUserState {}

class UpdateUserStateFailure extends UpdateUserState {
  const UpdateUserStateFailure({required this.errorMessage});

  final String errorMessage;

  @override
  List<Object> get props => [errorMessage];
}