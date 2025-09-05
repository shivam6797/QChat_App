class ApiEndpoints {

  // Base URL for the API
  static const String baseUrl = "http://45.129.87.38:6065";

 // ---------- Auth ----------
  static const String login = "$baseUrl/user/login";

  // ---------- Chats ----------
  static String userChats(String userId) =>
      "$baseUrl/chats/user-chats/$userId";

  static String getMessages(String chatId) =>
      "$baseUrl/messages/get-messagesformobile/$chatId";

  static const String sendMessage = "$baseUrl/messages/sendMessage";
}
