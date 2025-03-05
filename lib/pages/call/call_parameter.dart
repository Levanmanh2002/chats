enum CallType { call, incomingCall }

class CallCallParameter {
  // id người gọi đến
  final int id;

  final int messageId;
  final int? callId;
  // thông tin người gọi
  final String name;
  final String avatar;

  // thông tin cuộc gọi
  final String? token;
  final String? channel;

  final CallType type;

  CallCallParameter({
    required this.id,
    required this.messageId,
    required this.callId,
    required this.name,
    required this.avatar,
    required this.channel,
    this.token,
    required this.type,
  });
}
