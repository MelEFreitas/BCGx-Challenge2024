import 'package:dio/dio.dart';
import 'package:frontend/core/constants/api_urls.dart';
import 'package:frontend/core/error_handling/exception.dart';
import 'package:frontend/core/infrastructure/shared_preferences_service.dart';
import 'package:frontend/core/network/dio_client.dart';
import 'package:frontend/data/models/chat/chat.dart';
import 'package:frontend/data/models/chat/chat_summary.dart';
import 'package:frontend/data/models/chat/create_chat_req.dart';
import 'package:frontend/data/models/chat/delete_chat_req.dart';
import 'package:frontend/data/models/chat/get_chat_req.dart';
import 'package:frontend/data/models/chat/update_chat_req.dart';
import 'package:frontend/service_locator.dart';

abstract class ChatApiService {
  Future<List<ChatSummaryModel>> getAllChatSummaries();
  Future<ChatModel> getChat(GetChatReq req);
  Future<ChatModel> createChat(CreateChatReq req);
  Future<void> deleteChat(DeleteChatReq req);
  Future<void> updateChat(UpdateChatReq req);
}

class ChatApiServiceImpl implements ChatApiService {
  @override
  Future<ChatModel> createChat(CreateChatReq req) async {
    try {
      final accessToken = await sl<SharedPreferencesService>()
          .getToken(TokenKeys.accessTokenKey);
      final response = await sl<DioClient>().post(
        ApiUrls.chatUrl,
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
        data: req.toMap(),
      );
      return ChatModel.fromJson(response.data);
    } on DioException catch (e) {
      throw CreateChatException(message: e.response?.data['message']);
    }
  }

  @override
  Future<void> deleteChat(DeleteChatReq req) async {
    final String url = '${ApiUrls.chatUrl}/${req.chatId}';
    final accessToken =
        await sl<SharedPreferencesService>().getToken(TokenKeys.accessTokenKey);
    try {
      await sl<DioClient>().delete(
        url,
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );
    } on DioException catch (e) {
      throw DeleteChatException(message: e.response?.data['message']);
    }
  }

  @override
  Future<List<ChatSummaryModel>> getAllChatSummaries() async {
    try {
      final accessToken = await sl<SharedPreferencesService>()
          .getToken(TokenKeys.accessTokenKey);
      final response = await sl<DioClient>().get(ApiUrls.chatUrl,
          options: Options(
            headers: {
              'Authorization': 'Bearer $accessToken',
            },
          ));
      List<ChatSummaryModel> chatSummaries = (response.data as List)
          .map(
              (item) => ChatSummaryModel.fromJson(item as Map<String, dynamic>))
          .toList();
      return chatSummaries;
    } on DioException catch (e) {
      throw GetAllChatSummariesException(message: e.response?.data['message']);
    }
  }

  @override
  Future<ChatModel> getChat(GetChatReq req) async {
    try {
      final String url = '${ApiUrls.chatUrl}/${req.chatId}';
      final accessToken = await sl<SharedPreferencesService>()
          .getToken(TokenKeys.accessTokenKey);
      final response = await sl<DioClient>().get(url,
          options: Options(
            headers: {
              'Authorization': 'Bearer $accessToken',
            },
          ));
      return ChatModel.fromJson(response.data);
    } on DioException catch (e) {
      throw GetChatException(message: e.response?.data['message']);
    }
  }

  @override
  Future<void> updateChat(UpdateChatReq req) async {
    try {
      final String url = '${ApiUrls.chatUrl}/${req.chatId}';
      final accessToken = await sl<SharedPreferencesService>()
          .getToken(TokenKeys.accessTokenKey);
      await sl<DioClient>().post(
        url,
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
        data: req.toMap(),
      );
    } on DioException catch (e) {
      throw UpdateChatException(message: e.response?.data['message']);
    }
  }
}
