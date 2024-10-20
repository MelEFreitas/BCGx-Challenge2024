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

/// An abstract class that defines the API service operations for chat functionalities.
abstract class ChatApiService {
  /// Retrieves all chat summaries.
  ///
  /// Returns a list of [ChatSummaryModel].
  /// Throws [GetAllChatSummariesException] if the retrieval fails.
  Future<List<ChatSummaryModel>> getAllChatSummaries();

  /// Retrieves a specific chat based on the provided [req].
  ///
  /// Returns a [ChatModel] if the chat is found.
  /// Throws [GetChatException] if the retrieval fails.
  Future<ChatModel> getChat(GetChatReq req);

  /// Creates a new chat using the provided [req].
  ///
  /// Returns the newly created [ChatModel].
  /// Throws [CreateChatException] if the creation fails.
  Future<ChatModel> createChat(CreateChatReq req);

  /// Deletes a chat based on the provided [req].
  ///
  /// Throws [DeleteChatException] if the deletion fails.
  Future<void> deleteChat(DeleteChatReq req);

  /// Updates an existing chat based on the provided [req].
  ///
  /// Throws [UpdateChatException] if the update fails.
  Future<void> updateChat(UpdateChatReq req);
}

/// Implementation of the [ChatApiService] interface.
///
/// This class manages chat-related API calls such as retrieving chat summaries, creating chats, deleting chats, and updating chats.
class ChatApiServiceImpl implements ChatApiService {
  /// Creates a new chat using the provided [req].
  ///
  /// Retrieves the access token and sends a POST request to create a chat.
  /// Returns a [ChatModel] if the creation is successful.
  /// Throws a [CreateChatException] if the creation process encounters an error.
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

  /// Deletes a chat based on the provided [req].
  ///
  /// Constructs the URL using the chat ID and sends a DELETE request.
  /// Throws a [DeleteChatException] if the deletion process encounters an error.
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

  /// Retrieves all chat summaries.
  ///
  /// Sends a GET request to retrieve the chat summaries.
  /// Returns a list of [ChatSummaryModel] if successful.
  /// Throws a [GetAllChatSummariesException] if the retrieval process encounters an error.
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

  /// Retrieves a specific chat based on the provided [req].
  ///
  /// Constructs the URL using the chat ID and sends a GET request.
  /// Returns a [ChatModel] if the retrieval is successful.
  /// Throws a [GetChatException] if the retrieval process encounters an error.
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

  /// Updates an existing chat based on the provided [req].
  ///
  /// Constructs the URL using the chat ID and sends a POST request with updated data.
  /// Throws a [UpdateChatException] if the update process encounters an error.
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
