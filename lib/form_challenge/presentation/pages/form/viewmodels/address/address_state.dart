part of 'address_cubit.dart';

sealed class AddressState extends Equatable {
  const AddressState();

  @override
  List<Object?> get props => [];
}

final class AddressEmptyState extends AddressState {}

final class AddressLoadingState extends AddressState {}

final class AddressSuccessState extends AddressState {
  final List<AddressEntity> listAddress;

  const AddressSuccessState({
    required this.listAddress,
  });

  @override
  List<Object?> get props => [listAddress];
}

final class AddressErrorState extends AddressState {}

