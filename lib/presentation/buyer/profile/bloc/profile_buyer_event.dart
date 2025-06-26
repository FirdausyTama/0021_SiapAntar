part of 'profile_buyer_bloc.dart';

sealed class ProfileBuyerEvent {}

class AddProfileBuyerEvent extends ProfileBuyerEvent {
  final PenyewaProfileRequestModel requestModel;

  AddProfileBuyerEvent({required this.requestModel});
}

class GetProfileBuyerEvent extends ProfileBuyerEvent {}