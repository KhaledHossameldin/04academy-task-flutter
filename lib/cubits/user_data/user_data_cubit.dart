import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../data/models/user_data.dart';
import '../../data/services/repository.dart';

part 'user_data_state.dart';

// This cubit handles fetching user data logic only by emitting states which
// translates in the UI as loading animation and displaying the fetched data in
// the HomeScreen or any screen needed when the request is done
class UserDataCubit extends Cubit<UserDataState> {
  UserDataCubit() : super(const UserDataInitial());

  final repository = Repository.instance;

  Future<void> fetch() async {
    try {
      emit(const UserDataLoading());
      final data = await repository.getUserData();
      emit(UserDataLoaded(data));
    } catch (e) {
      emit(UserDataError('$e'));
    }
  }
}
