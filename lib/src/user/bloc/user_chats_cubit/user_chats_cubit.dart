import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maydon_go/src/common/service/api/api_client.dart';
import 'package:maydon_go/src/common/service/api/common_service.dart';
import 'package:maydon_go/src/user/bloc/user_chats_cubit/user_chats_state.dart';


class UserChatsCubit extends Cubit<UserChatsState> {
  UserChatsCubit() : super(UserChatsInitial());

  Future<void> loadChats() async {
    emit(UserChatsLoading());
    try {
      final commonService = CommonService(ApiClient().dio);

      // API chaqiruvlar
      final allChats = await commonService.getChatsFromApi();
      final allClubs = await commonService.getClubsChatsFromApi();

      // unread xabarlari borlarni ajratib olish
      final unreadChats = allChats.where((chat) => chat.unreadMessages!.isNotEmpty).toList();
      final readChats = allChats.where((chat) => chat.unreadMessages!.isEmpty).toList();

      final unreadClubs = allClubs.where((club) => club.unreadMessages!.isNotEmpty).toList();
      final readClubs = allClubs.where((club) => club.unreadMessages!.isEmpty).toList();

      // unread birinchi, keyin read qo‘shiladi
      final sortedChats = [...unreadChats, ...readChats];
      final sortedClubs = [...unreadClubs, ...readClubs];

      emit(UserChatsLoaded(sortedChats, sortedClubs));
    } catch (e) {
      emit(UserChatsError(e.toString()));
    }
  }

}
