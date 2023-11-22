import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../data/models/user_data.dart';
import '../../data/services/repository.dart';

part 'users_state.dart';

class UsersCubit extends Cubit<UsersState> {
  UsersCubit() : super(const UsersInitial());

  final _repository = Repository.instance;

  Future<void> fetch({bool withAdmins = false}) async {
    try {
      emit(const UsersLoading());
      final users = await _repository.getUsers(withAdmins: withAdmins);
      emit(UsersLoaded(users));
    } catch (e) {
      emit(UsersError('$e'));
    }
  }
}
