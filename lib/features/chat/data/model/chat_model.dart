class ChatModel {
  String? id;
  bool? isGroupChat;
  List<Participants>? participants;
  String? createdAt;
  String? updatedAt;
  int? iV;
  LastMessage? lastMessage;

  ChatModel(
      {this.id,
      this.isGroupChat,
      this.participants,
      this.createdAt,
      this.updatedAt,
      this.iV,
      this.lastMessage});

  ChatModel.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    isGroupChat = json['isGroupChat'];
    if (json['participants'] != null) {
      participants = <Participants>[];
      json['participants'].forEach((v) {
        participants!.add(Participants.fromJson(v));
      });
    }
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    lastMessage = json['lastMessage'] != null
        ?  LastMessage.fromJson(json['lastMessage'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['_id'] = id;
    data['isGroupChat'] = isGroupChat;
    if (participants != null) {
      data['participants'] = participants!.map((v) => v.toJson()).toList();
    }
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    if (lastMessage != null) {
      data['lastMessage'] = lastMessage!.toJson();
    }
    return data;
  }
}

class Participants {
  Location? location;
  String? id;
  String? name;
  String? email;
  String? password;
  String? gender;
  String? phone;
  String? addressLane1;
  String? addressLane2;
  String? city;
  String? state;
  String? postalCode;
  String? country;
  bool? isOnline;
  List<String>? blockedUsers;
  String? role;
  bool? isVerified;
  bool? isDeleted;
  String? deletedMessage;
  bool? isDisabled;
  String? createdAt;
  String? updatedAt;
  int? iV;
  String? lastSeen;
  String? plan;
  String? profile;
  List<PaymentHistory>? paymentHistory;
  String? createdForTTL;
  String? deletedTime;
  String? previousPlan;
  String? referralCode;
  String? planEndDate;
  List<String>? fcmTokens;

  Participants({
    this.location,
    this.id,
    this.name,
    this.email,
    this.password,
    this.gender,
    this.phone,
    this.addressLane1,
    this.addressLane2,
    this.city,
    this.state,
    this.postalCode,
    this.country,
    this.isOnline,
    this.blockedUsers,
    this.role,
    this.isVerified,
    this.isDeleted,
    this.deletedMessage,
    this.isDisabled,
    this.createdAt,
    this.updatedAt,
    this.iV,
    this.lastSeen,
    this.plan,
    this.profile,
    this.paymentHistory,
    this.createdForTTL,
    this.deletedTime,
    this.previousPlan,
    this.referralCode,
    this.planEndDate,
    this.fcmTokens,
  });

  Participants.fromJson(Map<String, dynamic> json) {
    location =
        json['location'] != null ? Location.fromJson(json['location']) : null;
    id = json['_id'];
    name = json['name'];
    email = json['email'];
    password = json['password'];
    gender = json['gender'];
    phone = json['phone'];
    addressLane1 = json['addressLane1'];
    addressLane2 = json['addressLane2'];
    city = json['city'];
    state = json['state'];
    postalCode = json['postalCode'];
    country = json['country'];
    isOnline = json['isOnline'];
    if (json['blockedUsers'] != null) {
      blockedUsers = List<String>.from(json['blockedUsers']);
    }
    role = json['role'];
    isVerified = json['isVerified'];
    isDeleted = json['isDeleted'];
    deletedMessage = json['deletedMessage'];
    isDisabled = json['isDisabled'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    lastSeen = json['lastSeen'];
    plan = json['plan'];
    profile = json['profile'];
    if (json['paymentHistory'] != null) {
      paymentHistory = <PaymentHistory>[];
      json['paymentHistory'].forEach((v) {
        paymentHistory!.add(PaymentHistory.fromJson(v));
      });
    }
    createdForTTL = json['createdForTTL'];
    deletedTime = json['deletedTime'];
    previousPlan = json['previousPlan'];
    referralCode = json['referralCode'];
    planEndDate = json['planEndDate'];
    fcmTokens = json['fcmTokens'] != null
        ? List<String>.from(json['fcmTokens'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (location != null) {
      data['location'] = location!.toJson();
    }
    data['_id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['password'] = password;
    data['gender'] = gender;
    data['phone'] = phone;
    data['addressLane1'] = addressLane1;
    data['addressLane2'] = addressLane2;
    data['city'] = city;
    data['state'] = state;
    data['postalCode'] = postalCode;
    data['country'] = country;
    data['isOnline'] = isOnline;
    if (blockedUsers != null) {
      data['blockedUsers'] = blockedUsers;
    }
    data['role'] = role;
    data['isVerified'] = isVerified;
    data['isDeleted'] = isDeleted;
    data['deletedMessage'] = deletedMessage;
    data['isDisabled'] = isDisabled;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    data['lastSeen'] = lastSeen;
    data['plan'] = plan;
    data['profile'] = profile;
    if (paymentHistory != null) {
      data['paymentHistory'] =
          paymentHistory!.map((v) => v.toJson()).toList();
    }
    data['createdForTTL'] = createdForTTL;
    data['deletedTime'] = deletedTime;
    data['previousPlan'] = previousPlan;
    data['referralCode'] = referralCode;
    data['planEndDate'] = planEndDate;
    data['fcmTokens'] = fcmTokens;
    return data;
  }
}


class Location {
  double? latitude;
  double? longitude;

  Location({this.latitude, this.longitude});

  Location.fromJson(Map<String, dynamic> json) {
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    return data;
  }
}

class PaymentHistory {
  String? orderId;
  int? amount;
  String? currency;
  String? status;
  Method? method;
  String? paidAt;
  String? id;

  PaymentHistory(
      {this.orderId,
      this.amount,
      this.currency,
      this.status,
      this.method,
      this.paidAt,
      this.id
      });

  PaymentHistory.fromJson(Map<String, dynamic> json) {
    orderId = json['orderId'];
    amount = json['amount'];
    currency = json['currency'];
    status = json['status'];
    method =
        json['method'] != null ? Method.fromJson(json['method']) : null;
    paidAt = json['paidAt'];
    id = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['orderId'] = orderId;
    data['amount'] = amount;
    data['currency'] = currency;
    data['status'] = status;
    if (method != null) {
      data['method'] = method!.toJson();
    }
    data['paidAt'] = paidAt;
    data['_id'] = id;
    return data;
  }
}

class Method {
  Upi? upi;

  Method({this.upi});

  Method.fromJson(Map<String, dynamic> json) {
    upi = json['upi'] != null ?  Upi.fromJson(json['upi']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    if (upi != null) {
      data['upi'] = upi!.toJson();
    }
    return data;
  }
}

class Upi {
  String? channel;
  String? upiId;

  Upi({this.channel, this.upiId});

  Upi.fromJson(Map<String, dynamic> json) {
    channel = json['channel'];
    upiId = json['upi_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['channel'] = channel;
    data['upi_id'] = upiId;
    return data;
  }
}

class LastMessage {
  String? id;
  String? senderId;
  String? content;
  String? messageType;
  String? fileUrl;
  String? createdAt;

  LastMessage(
      {this.id,
      this.senderId,
      this.content,
      this.messageType,
      this.fileUrl,
      this.createdAt});

  LastMessage.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    senderId = json['senderId'];
    content = json['content'];
    messageType = json['messageType'];
    fileUrl = json['fileUrl'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['_id'] = id;
    data['senderId'] = senderId;
    data['content'] = content;
    data['messageType'] = messageType;
    data['fileUrl'] = fileUrl;
    data['createdAt'] = createdAt;
    return data;
  }
}
