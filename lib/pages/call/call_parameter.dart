class CallCallParameter {
  // id người gọi đến
  final int id;
  // thông tin người gọi
  final String name;
  final String avatar;

  // thông tin cuộc gọi
  final String channel;

  CallCallParameter({
    required this.id,
    required this.name,
    required this.avatar,
    required this.channel,
  });
}
