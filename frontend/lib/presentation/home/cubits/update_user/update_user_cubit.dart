import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/error_handling/failure.dart';
import 'package:frontend/data/models/user/update_user_req.dart';
import 'package:frontend/domain/usecases/user/update_user.dart';
import 'package:frontend/service_locator.dart';

part 'update_user_state.dart';

class UpdateUserCubit extends Cubit<UpdateUserState>{
  UpdateUserCubit() : super(UpdateUserStateInitial());

  Future<void> updateUser(String role) async {
    emit(UpdateUserStateLoading());
    final Either<Failure, void> result = await sl<UpdateUserUsecase>().call(
      params: UpdateUserReq(role: role)
    );
    result.fold(
      (failure) => emit(UpdateUserStateFailure(errorMessage: failure.message)),
      (_) => emit(UpdateUserStateSuccess())
    );
  }
}