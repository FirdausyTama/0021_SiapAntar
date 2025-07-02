part of 'sopir_bloc.dart';

sealed class SopirEvent {}

class SopirRequestEvent extends SopirEvent {
  final SopirRequestModel requestModel;

  SopirRequestEvent({required this.requestModel});
}

class SopirGetAllEvent extends SopirEvent {}

class SopirGetByIdEvent extends SopirEvent {
  final int id;

  SopirGetByIdEvent({required this.id});
}

class SopirUpdateEvent extends SopirEvent {
  final int id;
  final SopirRequestModel requestModel;

  SopirUpdateEvent({required this.id, required this.requestModel});
}

class SopirDeleteEvent extends SopirEvent {
  final int id;

  SopirDeleteEvent({required this.id});
}