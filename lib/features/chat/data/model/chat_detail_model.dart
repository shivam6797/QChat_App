class ChatDetailModel {
  String? id;
  String? chatId;
  String? senderId;
  String? content;
  String? messageType;
  List<String>? deletedBy;
  String? status;
  String? deliveredAt;
  String? seenAt;
  List<String>? seenBy;
  List<String>? reactions;
  String? sentAt;
  String? createdAt;
  String? updatedAt;
  int? v;

  ChatDetailModel({
    this.id,
    this.chatId,
    this.senderId,
    this.content,
    this.messageType,
    this.deletedBy,
    this.status,
    this.deliveredAt,
    this.seenAt,
    this.seenBy,
    this.reactions,
    this.sentAt,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory ChatDetailModel.fromJson(Map<String, dynamic> json) {
    return ChatDetailModel(
      id: json['_id'],
      chatId: json['chatId'],
      senderId: json['senderId'],
      content: json['content'],
      messageType: json['messageType'],
      deletedBy: (json['deletedBy'] as List?)?.map((e) => e.toString()).toList() ?? [],
      status: json['status'],
      deliveredAt: json['deliveredAt'],
      seenAt: json['seenAt'],
      seenBy: (json['seenBy'] as List?)?.map((e) => e.toString()).toList() ?? [],
      reactions: (json['reactions'] as List?)?.map((e) => e.toString()).toList() ?? [],
      sentAt: json['sentAt'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      v: json['__v'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'chatId': chatId,
      'senderId': senderId,
      'content': content,
      'messageType': messageType,
      'deletedBy': deletedBy,
      'status': status,
      'deliveredAt': deliveredAt,
      'seenAt': seenAt,
      'seenBy': seenBy,
      'reactions': reactions,
      'sentAt': sentAt,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': v,
    };
  }
}
