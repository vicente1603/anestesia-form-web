import 'package:equatable/equatable.dart';

abstract class UIState extends Equatable {
  final String description;

  const UIState(this.description);
}

class UIInitialState extends UIState {
  UIInitialState() : super('');

  @override
  List<Object> get props => [description];
}

class UIInactiveState extends UIState {
  UIInactiveState() : super('');

  @override
  List<Object> get props => [description];
}

class UILoadingState extends UIState {
  UILoadingState() : super('');

  @override
  List<Object> get props => [description];
}

class UILoadingInternalState extends UIState {
  UILoadingInternalState() : super('');

  @override
  List<Object> get props => [description];
}

class UIErrorState extends UIState {
  final bool shouldRetry;
  final String errorDetails;

  UIErrorState(
    String description, {
    this.shouldRetry = true,
    this.errorDetails = "",
  }) : super(description);

  @override
  List<Object> get props => [description, this.shouldRetry, this.errorDetails];
}

class UISuccessState extends UIState {
  UISuccessState(String description) : super(description);

  @override
  List<Object> get props => [description];
}

class UIQuestionState extends UIState {
  UIQuestionState(String description) : super(description);

  @override
  List<Object> get props => [description];
}
