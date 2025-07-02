part of 'sopir_bloc.dart';

sealed class SopirState {}

final class SopirInitial extends SopirState {}

final class SopirLoadingState extends SopirState {}

final class SopirSuccessState extends SopirState {
  final GetAllSopirModel responseModel;

  SopirSuccessState({required this.responseModel});
}

final class SopirAddSuccessState extends SopirState {
  final GetSopirById responseModel;

  SopirAddSuccessState({required this.responseModel});
}

final class SopirDetailSuccessState extends SopirState {
  final GetSopirById responseModel;

  SopirDetailSuccessState({required this.responseModel});
}

final class SopirUpdateSuccessState extends SopirState {
  final GetSopirById responseModel;

  SopirUpdateSuccessState({required this.responseModel});
}

final class SopirDeleteSuccessState extends SopirState {
  final String message;

  SopirDeleteSuccessState({required this.message});
}

final class SopirErrorState extends SopirState {
  final String errorMessage;

  SopirErrorState({required this.errorMessage});
}