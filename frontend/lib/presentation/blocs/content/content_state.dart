// # File: frontend/lib/presentation/blocs/content/content_state.dart

part of 'content_bloc.dart';

abstract class ContentState extends Equatable {
  const ContentState();

  @override
  List<Object?> get props => [];
}

class ContentInitial extends ContentState {}

class ContentLoading extends ContentState {}

class ContentLoaded extends ContentState {
  final List<dynamic> content;

  const ContentLoaded(this.content);

  @override
  List<Object> get props => [content];
}

class ContentError extends ContentState {
  final String message;

  const ContentError(this.message);

  @override
  List<Object> get props => [message];
}
