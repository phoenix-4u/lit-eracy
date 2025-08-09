import 'package:equatable/equatable.dart';

class UserPoints extends Equatable {
  final int knowledgeGems;

  const UserPoints({required this.knowledgeGems});

  @override
  List<Object> get props => [knowledgeGems];

  factory UserPoints.fromJson(Map<String, dynamic> json) {
    return UserPoints(
      knowledgeGems: json['knowledge_gems'],
    );
  }
}