import 'package:cloud_firestore/cloud_firestore.dart';

enum MessageStatus { sent, delivered, read }
enum MessageType { text, image, video, audio, file }

class MessageModel {
  final String id;
  final String senderId;
  final String text;
  final MessageType type;
  final String? mediaUrl;
  final MessageStatus status;
  final Timestamp timestamp;
  final Map<String, dynamic>? replyTo; 

  MessageModel({
    required this.id,
    required this.senderId,
    required this.text,
    this.type = MessageType.text,
    this.mediaUrl,
    this.status = MessageStatus.sent,
    required this.timestamp,
    this.replyTo,
  });

  factory MessageModel.fromFirestore(Map<String, dynamic> data, String id) {
    return MessageModel(
      id: id,
      senderId: data['senderId'] ?? '',
      text: data['text'] ?? '',
      type: MessageType.values.firstWhere((e) => e.toString() == data['type'], orElse: () => MessageType.text),
      mediaUrl: data['mediaUrl'],
      status: MessageStatus.values.firstWhere((e) => e.toString() == data['status'], orElse: () => MessageStatus.sent),
      timestamp: data['timestamp'] ?? Timestamp.now(),
      replyTo: data['replyTo'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'text': text,
      'type': type.toString(),
      'mediaUrl': mediaUrl,
      'status': status.toString(),
      'timestamp': timestamp,
      'replyTo': replyTo,
    };
  }
}

