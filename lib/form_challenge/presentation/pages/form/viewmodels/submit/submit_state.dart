part of 'submit_cubit.dart';

sealed class SubmitState extends Equatable {
  const SubmitState();

  @override
  List<Object> get props => [];
}

final class SubmitInitialState extends SubmitState {}

final class SubmitLoadingState extends SubmitState {}

final class SubmitErrorState extends SubmitState {
  final String message;

  const SubmitErrorState({required this.message});
  @override
  List<Object> get props => [message];
}

final class SubmitSuccessState extends SubmitState {}
