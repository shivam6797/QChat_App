import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketClient {
  static IO.Socket? _socket;
  static final List<Function(dynamic)> _messageListeners = [];

  static void connect(String baseUrl, String userId) {
    _socket = IO.io(
      baseUrl,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .build(),
    );

    _socket?.connect();

    _socket?.onConnect((_) {
      print("Socket connected");
      _socket?.emit("join", {"userId": userId});
    });

    _socket?.onDisconnect((_) {
      print("Socket disconnected");
    });

    _socket?.on("new_message", (data) {
      _notifyAllListeners(data);
    });
  }

  static void _notifyAllListeners(dynamic data) {
    for (final listener in _messageListeners) {
      listener(data);
    }
  }

  static void sendMessage(Map<String, dynamic> message) {
    _socket?.emit("send_message", message);
  }

  static void listenMessages(Function(dynamic data) onMessage) {
    _messageListeners.add(onMessage);
  }

  static void removeMessageListener(Function(dynamic data) onMessage) {
    _messageListeners.remove(onMessage);
  }

  static void disconnect() {
    _messageListeners.clear();
    _socket?.disconnect();
    _socket?.destroy();
    _socket = null;
  }
}