import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pict_frontend/models/User.dart';
import 'package:pict_frontend/services/user_service.dart';

class UserNotifier extends StateNotifier<List<User>> {
  UserNotifier() : super(const []);

  Future<int> getCountOfUserRewards(String userId) async {
    final response = await UserServices.getCountOfUserRewards(userId);

    return response;
  }
}

final userNotifier = StateNotifierProvider<UserNotifier, List<User>>(
  (ref) => UserNotifier(),
);
