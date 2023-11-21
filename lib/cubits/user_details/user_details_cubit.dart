import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../data/models/user_data.dart';
import '../../data/services/repository.dart';

part 'user_details_state.dart';

class UserDetailsCubit extends Cubit<UserDetailsState> {
  UserDetailsCubit() : super(const UserDetailsInitial());

  final repository = Repository.instance;

  Future<void> add(UserData userData) async {
    try {
      emit(const UserDetailsLoading());
      await repository.addUser(userData);
      emit(const UserDetailsLoaded());
    } catch (e) {
      emit(UserDetailsError('$e'));
    }
  }

  Future<void> updateUser(UserData userData, String email) async {
    try {
      emit(const UserDetailsLoading());
      await repository.updateUser(userData, email);
      emit(const UserDetailsLoaded());
    } catch (e) {
      emit(UserDetailsError('$e'));
    }
  }
}
