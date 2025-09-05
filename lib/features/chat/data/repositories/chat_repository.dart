import 'package:qchat_app/core/errors/api_exception.dart';
import 'package:qchat_app/core/network/api_client.dart';
import 'package:qchat_app/core/network/api_endpoint.dart';
import 'package:qchat_app/features/chat/data/model/chat_model.dart';
import 'package:qchat_app/features/chat/data/model/chat_detail_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatRepository {
  final ApiClient _apiClient;

  ChatRepository({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  Future<List<ChatModel>> fetchChats() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString("userId");

      if (userId == null || userId.isEmpty) {
        throw ApiException("User ID not found, please login again");
      }

      final response = await _apiClient.get(ApiEndpoints.userChats(userId));

      if (response is List) {
        return response
            .map((e) => ChatModel.fromJson(Map<String, dynamic>.from(e)))
            .toList();
      } else if (response is Map && response['data'] is List) {
        return (response['data'] as List)
            .map((e) => ChatModel.fromJson(Map<String, dynamic>.from(e)))
            .toList();
      } else {
        throw ApiException("Invalid chat response format");
      }
    } catch (error) {
      throw ApiException.fromDioError(error);
    }
  }

  Future<List<ChatDetailModel>> getMessages(String chatId) async {
    try {
      if (chatId.trim().isEmpty) {
        throw ApiException("chatId is required to fetch messages");
      }

      final response = await _apiClient.get(ApiEndpoints.getMessages(chatId));

      if (response is List) {
        return response
            .map((e) => ChatDetailModel.fromJson(Map<String, dynamic>.from(e)))
            .toList();
      } else if (response is Map) {
        if (response['data'] is List) {
          return (response['data'] as List)
              .map((e) => ChatDetailModel.fromJson(Map<String, dynamic>.from(e)))
              .toList();
        } else if (response['messages'] is List) {
          return (response['messages'] as List)
              .map((e) => ChatDetailModel.fromJson(Map<String, dynamic>.from(e)))
              .toList();
        }
      }

      return <ChatDetailModel>[];
    } catch (error) {
      throw ApiException.fromDioError(error);
    }
  }

  Future<ChatDetailModel> sendMessage({
    required String chatId,
    required String senderId,
    required String content,
    String messageType = "text",
    String fileUrl = "",
  }) async {
    try {
      final body = {
        "chatId": chatId,
        "senderId": senderId,
        "content": content,
        "messageType": messageType,
        "fileUrl": fileUrl,
      };

      final response = await _apiClient.post(ApiEndpoints.sendMessage, data: body);

      if (response is Map<String, dynamic>) {
        return ChatDetailModel.fromJson(response);
      } else {
        throw ApiException("Invalid response from sendMessage API");
      }
    } catch (error) {
      throw ApiException.fromDioError(error);
    }
  }
}
