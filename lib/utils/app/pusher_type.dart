class PusherType {
  // static const NEW_INVITE_EVENT = 'NEW_INVITE'; // Phát sự kiện tới user khi nhận được 1 lời mời kết bạn mới
  static const NEW_MESSAGE_EVENT = 'NEW_MESSAGE'; // Phát sự kiện tới user khi có 1 tin nhắn mới
  static const ROLLBACK_EVENT = 'ROLLBACK_MESSAGE'; // Trong 1 cuộc chat đơn hoặc chat nhóm có tin nhắn bị thu hồi
  static const LIKE_MESSAGE_EVENT = 'LIKE_MESSAGE'; // Tin nhắn trong cuộc chat đơn hoặc chat nhóm có người like mới
  static const ADD_TO_GROUP_EVENT = 'ADD_TO_GROUP'; // Khi user được thêm vào 1 nhóm
  static const REMOVE_FROM_GROUP_EVENT = 'REMOVE_FROM_GROUP'; // Phát sự kiện tới user bị xóa khỏi nhóm
  static const HAS_USER_REMOVED_FROM_GROUP_EVENT =
      'HAS_USER_REMOVED_FROM_GROUP'; // Phát sự kiện tới user còn lại trong nhóm rằng user đó bị xóa
  static const LEFT_GROUP_GROUP_EVENT =
      'LEFT_GROUP_GROUP'; // Phát sự kiện tới các user còn lại trong nhóm khi có 1 user tự rời nhóm
  static const GROUP_RENAME_EVENT = 'GROUP_RENAME'; // Phát sự kiện tới các user trong nhóm kho nhóm được đổi tên
  static const NEW_MESSAGE_FOR_LIST_EVENT = 'NEW_MESSAGE_FOR_LIST';

  static const NEW_INVITE_EVENT = 'NEW_INVITE'; // Phát sự kiện tới user khi nhận được 1 lời mời kết bạn mới
  static const ROLLBACK_INVITE_EVENT =
      'ROLLBACK_INVITE'; //  Phát sự kiện tới user nhân lời mời khi người gửi thu hồi lời mới kết bạn
  static const CANCEL_INVITE_EVANT = 'CANCEL_INVITE'; // Phát sự kiện tới user gửi khi lời mời bị từ chốt
  static const ACCEPTED_INVITE_EVENT = 'ACCEPTED_INVITE'; // Phát sự kiện tới user lời mời kết bạn được đồng ý
  static const UNFRIEND_EVENT = 'UNFRIEND'; // Phát sự kiện khi có người dùng hủy kết bạn
  static const NEW_CALL_EVENT = 'NEW_CALL'; // Phát sự kiện tới user khi có cuộc gọi mới
  static const END_CALL_EVENT = 'end_call'; // Phát sự kiện tới user khi có cuộc gọi kết thúc
}
